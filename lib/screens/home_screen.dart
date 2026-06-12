import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/location_appbar_title.dart';
import '../entities/cua_hang.dart';
import '../services/cua_hang_service.dart';
import '../services/san_pham_service.dart';

import 'store_detail_screen.dart';
import 'nearby_store_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CuaHangService _cuaHangService = CuaHangService();
  final SanPhamService _sanPhamService = SanPhamService();

  List<CuaHang> nearbyStores = [];
  List<CuaHang> randomStores = [];
  List<CuaHang> filteredStores = [];

  String? selectedCategory;
  bool locationDenied = false;
  bool isLoadingStores = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    Position? pos = await _getUserPosition();
    if (pos != null) {
      final stores3km = await _cuaHangService.getNearbyStores(pos.latitude, pos.longitude, 3000);
      stores3km.shuffle();
      nearbyStores = stores3km.take(5).toList();

      final stores5km = await _cuaHangService.getNearbyStores(pos.latitude, pos.longitude, 5000);
      stores5km.shuffle();
      randomStores = stores5km.take(10).toList();
    } else {
      locationDenied = true;
    }

    setState(() {
      isLoadingStores = false;
    });
  }

  Future<Position?> _getUserPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> _toggleCategory(String category) async {
    if (selectedCategory == category) {
      selectedCategory = null;
      filteredStores = [];
      setState(() {});
      return;
    }

    selectedCategory = category;

    final allStores = await _cuaHangService.getAll();
    final allItems = await _sanPhamService.getAllSanPham();

    final matchedItems = allItems.where((item) => item.category == category).toList();
    final storeIds = matchedItems.map((e) => e.cuaHangId).toSet();

    filteredStores = allStores.where((store) => storeIds.contains(store.id)).toList();

    setState(() {});
  }

  Widget _buildCategoryChip(String imagePath, String title, String category) {
    final bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => _toggleCategory(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 82,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xfff2f4f3),
                border: isSelected
                    ? Border.all(color: const Color(0xff00b14f), width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xff00b14f) : const Color(0xff555e61),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(CuaHang store) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoreDetailScreen(
            cuaHangId: store.id,
            tenCuaHang: store.ten,
          ),
        ),
      ),
      child: Container(
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
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 88,
                height: 88,
                color: const Color(0xfff2f4f3),
                child: Image.asset(
                  store.thumbnailUrl ?? 'assets/images/default_store.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.storefront_outlined,
                    color: Color(0xffb0b8bb),
                    size: 32,
                  ),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.ten,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff1a1a2e),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: Color(0xff8a8f9e)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            store.diaChi,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xff8a8f9e),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Color(0xffb0b8bb), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xff1a1a2e),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xfff2f4f3),
        borderRadius: BorderRadius.circular(16),
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
        title: const LocationAppBarTitle(),
        iconTheme: const IconThemeData(color: Color(0xff1a1a2e)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: widthAuto * 0.045, vertical: 8),
        children: [
          // ── Hero banner ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff00b14f), Color(0xff00913f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff00b14f).withOpacity(0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bạn đang thèm gì hôm nay? 🍜",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: Color(0xff8a8f9e), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Tìm món ăn hoặc cửa hàng...",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff8a8f9e),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Categories ───────────────────────────────────────
          _buildSectionHeader("Danh mục"),
          SizedBox(
            height: 106,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('assets/images/com.png', 'Cơm', 'com'),
                _buildCategoryChip('assets/images/bun.png', 'Bún · Phở · Cháo', 'bun_pho_chao'),
                _buildCategoryChip('assets/images/fastfood.png', 'Đồ ăn nhanh', 'do_an_nhanh'),
                _buildCategoryChip('assets/images/drink.png', 'Đồ uống', 'do_uong'),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Filtered / Default content ────────────────────────
          if (selectedCategory != null) ...[
            _buildSectionHeader(
              "Cửa hàng phù hợp",
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = null;
                    filteredStores = [];
                  });
                },
                child: const Text(
                  "Bỏ lọc",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff00b14f),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (filteredStores.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(Icons.storefront_outlined, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      const Text(
                        "Không tìm thấy cửa hàng",
                        style: TextStyle(color: Color(0xff8a8f9e), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredStores.map(_buildStoreCard),
          ] else ...[
            // Nearby button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NearbyStoreScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xffe8f8ef),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xff00b14f),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cửa hàng gần tôi",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1a1a2e),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Tìm quán trong bán kính 3km",
                            style: TextStyle(
                              color: Color(0xff8a8f9e),
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xfff2f4f3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xff555e61),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            _buildSectionHeader("Đề xuất cho bạn"),

            if (isLoadingStores)
              ...List.generate(4, (_) => _buildShimmerCard())
            else if (randomStores.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    locationDenied
                        ? "Bật định vị để xem đề xuất gần bạn"
                        : "Không có cửa hàng gần đây",
                    style: const TextStyle(color: Color(0xff8a8f9e), fontSize: 14),
                  ),
                ),
              )
            else
              ...randomStores.map(_buildStoreCard),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}