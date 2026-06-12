import 'package:flutter/material.dart';

import '../entities/cart_item.dart';
import '../entities/do_uong.dart';
import '../entities/kem.dart';
import '../entities/san_pham.dart';
import '../services/cart_service.dart';
import '../services/san_pham_service.dart';

class StoreDetailScreen extends StatefulWidget {
  final String cuaHangId;
  final String tenCuaHang;

  const StoreDetailScreen({
    super.key,
    required this.cuaHangId,
    required this.tenCuaHang,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final SanPhamService _service = SanPhamService();
  final CartService _cart = CartService();

  Future<void> _addToCart(SanPham sanPham, {String? size, double? price}) async {
    double finalPrice = price ?? sanPham.gia;
    _cart.add(CartItem(
      sanPham: sanPham,
      selectedSize: size,
      gia: finalPrice,
    ));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          "Đã thêm ${sanPham.ten}${size != null ? " size $size" : ""}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _showSizeDialog(SanPham sanPham) async {
    if (sanPham is! DoUong && sanPham is! Kem) return;

    final Map<String, double> prices =
        (sanPham is DoUong) ? sanPham.prices : (sanPham as Kem).prices;

    String selectedSize = prices.keys.first;
    double selectedPrice = prices[selectedSize]!;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chọn size",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff8a8f9e),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sanPham.ten,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff1a1a2e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...prices.entries.map((entry) {
                      final isSelected = selectedSize == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedSize = entry.key;
                              selectedPrice = entry.value;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xffe8f8ef) : const Color(0xfff2f4f3),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? const Color(0xff00b14f) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Size ${entry.key}",
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                          color: const Color(0xff1a1a2e),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${entry.value.toStringAsFixed(0)} đ",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff8a8f9e),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: Color(0xff00b14f), size: 22)
                                else
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xffd0d5d8), width: 1.5),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: const Color(0xff8a8f9e),
                            ),
                            child: const Text("Hủy", style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _addToCart(sanPham, size: selectedSize, price: selectedPrice);
                              Navigator.pop(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00b14f),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Thêm vào giỏ", style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFoodCard(SanPham sanPham) {
    final isDrinkOrIce = sanPham is DoUong || sanPham is Kem;

    final existing = _cart.items
        .where((item) =>
            item.sanPham.id == sanPham.id &&
            (!isDrinkOrIce ||
                (item.selectedSize != null && item.selectedSize!.isNotEmpty)))
        .fold<int>(0, (prev, item) => prev + item.quantity);

    String priceText;
    if (isDrinkOrIce) {
      final Map<String, double> prices =
          (sanPham is DoUong) ? sanPham.prices : (sanPham as Kem).prices;
      priceText = prices.isNotEmpty
          ? prices.entries
              .map((e) => "${e.key}: ${e.value.toStringAsFixed(0)} đ")
              .join("  ·  ")
          : "${sanPham.gia.toStringAsFixed(0)} đ";
    } else {
      priceText = "${sanPham.gia.toStringAsFixed(0)} đ";
    }

    final bool hasSizeOptions = isDrinkOrIce &&
        ((sanPham is DoUong && sanPham.prices.isNotEmpty) ||
            (sanPham is Kem && sanPham.prices.isNotEmpty));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                sanPham.imageUrl ?? 'assets/images/default_food.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xfff2f4f3),
                  child: const Icon(
                    Icons.restaurant_outlined,
                    color: Color(0xffb0b8bb),
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanPham.ten,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff1a1a2e),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xff8a8f9e),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            existing > 0
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f4f3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                          onTap: () {
                            _cart.decrease(CartItem(
                                sanPham: sanPham,
                                selectedSize: isDrinkOrIce ? null : null,
                                gia: sanPham.gia));
                            setState(() {});
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.remove, size: 18, color: Color(0xff555e61)),
                          ),
                        ),
                        Text(
                          "$existing",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xff1a1a2e),
                          ),
                        ),
                        InkWell(
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                          onTap: () {
                            if (hasSizeOptions) {
                              _showSizeDialog(sanPham);
                            } else {
                              _addToCart(sanPham);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.add, size: 18, color: Color(0xff00b14f)),
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (hasSizeOptions) {
                        _showSizeDialog(sanPham);
                      } else {
                        _addToCart(sanPham);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xff00b14f),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        hasSizeOptions ? "Chọn size" : "Thêm",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xff1a1a2e),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthAuto = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f7f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7f5),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          widget.tenCuaHang,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xff1a1a2e),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Color(0xff1a1a2e)),
      ),
      body: FutureBuilder<List<SanPham>>(
        future: _service.getSanPhamByCuaHangId(widget.cuaHangId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: const TextStyle(color: Color(0xff8a8f9e)),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff00b14f)),
            );
          }

          final list = snapshot.data!;

          final foods = list.where((item) => item is! DoUong && item is! Kem).toList();
          final drinks = list.where((item) => item is DoUong).toList();
          final iceCreams = list.where((item) => item is Kem).toList();

          if (foods.isEmpty && drinks.isEmpty && iceCreams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_outlined, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  const Text(
                    "Cửa hàng này chưa có món nào",
                    style: TextStyle(color: Color(0xff8a8f9e), fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(widthAuto * 0.045, 8, widthAuto * 0.045, 24),
            children: [
              if (foods.isNotEmpty) ...[
                _buildSectionHeader("Món ăn"),
                ...foods.map(_buildFoodCard),
              ],
              if (drinks.isNotEmpty) ...[
                if (foods.isNotEmpty) const SizedBox(height: 16),
                _buildSectionHeader("Đồ uống"),
                ...drinks.map(_buildFoodCard),
              ],
              if (iceCreams.isNotEmpty) ...[
                if (foods.isNotEmpty || drinks.isNotEmpty) const SizedBox(height: 16),
                _buildSectionHeader("Kem"),
                ...iceCreams.map(_buildFoodCard),
              ],
            ],
          );
        },
      ),
    );
  }
}