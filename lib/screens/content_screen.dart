import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../widgets/location_appbar_title.dart';
import '../entities/cart_item.dart';
import '../entities/don_hang.dart';
import '../services/cart_service.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int selectedTab = 0;
  final CartService cartService = CartService();
  Map<String, bool> expandedOrders = {};

  List<DonHang> _getCartOrders() {
    final Map<String, List<CartItem>> grouped = {};
    for (var item in cartService.items) {
      grouped.putIfAbsent(item.sanPham.cuaHangId, () => []);
      grouped[item.sanPham.cuaHangId]!.add(item);
    }
    return grouped.entries.map((e) {
      final firstItem = e.value.first;
      return DonHang(
        e.key,
        firstItem.sanPham.tenCuaHang,
        e.value,
      );
    }).toList();
  }

  Future<void> _placeOrder(String cuaHangId) async {
    final orderItems =
        cartService.items.where((e) => e.sanPham.cuaHangId == cuaHangId).toList();
    if (orderItems.isEmpty) return;

    final docRef =
        FirebaseFirestore.instance.collection('lich_su_don_hang').doc();
    final donHang = DonHang(
      docRef.id,
      orderItems.first.sanPham.tenCuaHang,
      orderItems,
      trangThai: 'dang_giao',
      thoiGianHoanThanh: DateTime.now(),
    );

    await docRef.set(donHang.toMap());

    for (var item in orderItems) {
      cartService.remove(item);
    }

    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Đã đặt ${orderItems.first.sanPham.tenCuaHang} thành công!"),
          backgroundColor: const Color(0xff00b14f),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _markAsDelivered(DonHang order) async {
    final docRef = FirebaseFirestore.instance
        .collection('lich_su_don_hang')
        .doc(order.id);
    await docRef.update({
      'trangThai': 'da_nhan_hang',
      'thoiGianNhanHang': DateTime.now().toUtc(),
    });
  }

  double _calculateOrderTotal(DonHang order) {
    return order.danhSachSanPham
        .fold(0, (sum, item) => sum + item.gia * item.quantity);
  }

  Widget _buildOrderCard(DonHang order, {bool isCart = false}) {
    final isExpanded = expandedOrders[order.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          GestureDetector(
            onTap: () {
              setState(() {
                expandedOrders[order.id] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  // Store icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xffe8f8ef),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Color(0xff00b14f),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.tenKhachHang,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff1a1a2e),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${order.danhSachSanPham.length} món · ${_calculateOrderTotal(order).toStringAsFixed(0)} đ",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xff8a8f9e),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xfff2f4f3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xff555e61),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Divider ──────────────────────────────────────────
          if (isExpanded)
            const Divider(height: 1, thickness: 1, color: Color(0xfff2f4f3)),

          // ── Item list ─────────────────────────────────────────
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: order.danhSachSanPham.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.ten,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1a1a2e),
                                ),
                              ),
                              if (item.selectedSize != null &&
                                  item.selectedSize!.isNotEmpty)
                                Text(
                                  "Size: ${item.selectedSize}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff8a8f9e),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isCart) ...[
                          // Quantity controls
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff2f4f3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cartService.decrease(item);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.remove_rounded,
                                      size: 16,
                                      color: Color(0xff555e61),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    "${item.quantity}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff1a1a2e),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cartService.add(CartItem(
                                      sanPham: item.sanPham,
                                      gia: item.gia,
                                      selectedSize: item.selectedSize,
                                    ));
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.add_rounded,
                                      size: 16,
                                      color: Color(0xff00b14f),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          "${(item.gia * item.quantity).toStringAsFixed(0)} đ",
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1a1a2e),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          // ── Footer: total + CTA ───────────────────────────────
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xfff2f4f3)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                children: [
                  if (!isCart && selectedTab == 2 && order.thoiGianNhanHang != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Ngày nhận hàng: ${DateFormat('dd/MM/yyyy – HH:mm').format(order.thoiGianNhanHang!.toLocal())}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xff555e61),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng cộng",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff555e61),
                        ),
                      ),
                      Text(
                        "${_calculateOrderTotal(order).toStringAsFixed(0)} đ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff00b14f),
                        ),
                      ),
                    ],
                  ),
                  if (isCart) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(order.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00b14f),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Đặt hàng",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (!isCart && selectedTab == 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _markAsDelivered(order),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff00b14f),
                          side: const BorderSide(
                              color: Color(0xff00b14f), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          "Đã nhận được hàng",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // ── Collapsed: date (tab lịch sử) + total ────────────
          if (!isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  if (!isCart && selectedTab == 2 && order.thoiGianNhanHang != null) ...[
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Color(0xff00b14f),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy – HH:mm')
                          .format(order.thoiGianNhanHang!.toLocal()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff8a8f9e),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    "Tổng: ${_calculateOrderTotal(order).toStringAsFixed(0)} đ",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff00b14f),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<DonHang> _currentOrders(List<DonHang> allOrders) {
    switch (selectedTab) {
      case 0:
        return _getCartOrders();
      case 1:
        return allOrders.where((o) => o.trangThai == 'dang_giao').toList();
      case 2:
        return allOrders.where((o) => o.trangThai == 'da_nhan_hang').toList();
      default:
        return [];
    }
  }

  Widget _buildTabBar() {
    final tabs = [
      (icon: Icons.shopping_bag_outlined, label: "Giỏ hàng"),
      (icon: Icons.delivery_dining_outlined, label: "Đang giao"),
      (icon: Icons.receipt_long_outlined, label: "Lịch sử"),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xfff2f4f3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedTab == index;
          final tab = tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xff00b14f) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xff00b14f).withOpacity(0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff8a8f9e),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xff8a8f9e),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    final configs = [
      (
        icon: Icons.shopping_bag_outlined,
        title: "Giỏ hàng trống",
        subtitle: "Thêm món ăn yêu thích để bắt đầu đặt hàng",
      ),
      (
        icon: Icons.delivery_dining_outlined,
        title: "Chưa có đơn đang giao",
        subtitle: "Đơn hàng đang xử lý sẽ hiển thị ở đây",
      ),
      (
        icon: Icons.receipt_long_outlined,
        title: "Chưa có lịch sử",
        subtitle: "Các đơn đã nhận sẽ được lưu lại tại đây",
      ),
    ];
    final cfg = configs[selectedTab];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffe8f8ef),
                shape: BoxShape.circle,
              ),
              child: Icon(cfg.icon, size: 36, color: const Color(0xff00b14f)),
            ),
            const SizedBox(height: 18),
            Text(
              cfg.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff1a1a2e),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cfg.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xff8a8f9e),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7f5),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const LocationAppBarTitle(),
        iconTheme: const IconThemeData(color: Color(0xff1a1a2e)),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('lich_su_don_hang')
                  .orderBy('thoiGianHoanThanh', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff00b14f),
                      strokeWidth: 2.5,
                    ),
                  );
                }

                final allOrders = snapshot.data!.docs
                    .map((doc) =>
                        DonHang.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();
                final currentOrders = _currentOrders(allOrders);

                if (currentOrders.isEmpty) return _buildEmptyState();

                return RefreshIndicator(
                  color: const Color(0xff00b14f),
                  onRefresh: () async => setState(() {}),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: currentOrders
                        .map((order) => _buildOrderCard(order,
                            isCart: selectedTab == 0))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}