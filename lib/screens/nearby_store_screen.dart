import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../entities/cua_hang.dart';
import '../services/cua_hang_service.dart';
import 'store_detail_screen.dart';

class NearbyStoreScreen extends StatefulWidget {
  final CuaHang? initialStore;

  const NearbyStoreScreen({super.key, this.initialStore});

  @override
  State<NearbyStoreScreen> createState() => _NearbyStoreScreenState();
}

class _NearbyStoreScreenState extends State<NearbyStoreScreen> {
  final CuaHangService _cuaHangService = CuaHangService();
  final ScrollController _scrollController = ScrollController();

  List<CuaHang> allNearby = [];
  List<CuaHang> displayed = [];

  int itemsPerPage = 10;
  int currentPage = 0;
  bool hasMore = true;
  bool isLoadingMore = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNearby();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore &&
        !isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadNearby() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final near3km = await _cuaHangService.getNearbyStores(
          pos.latitude, pos.longitude, 3000);
      near3km.shuffle();
      allNearby = near3km;
      displayed = allNearby.take(itemsPerPage).toList();
      currentPage = 1;
      hasMore = allNearby.length > itemsPerPage;
    } catch (_) {}

    setState(() => isLoading = false);
  }

  void _loadMore() {
    if (!hasMore || isLoadingMore) return;
    setState(() => isLoadingMore = true);

    final nextItems = allNearby
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    displayed.addAll(nextItems);
    currentPage++;
    if (displayed.length >= allNearby.length) hasMore = false;

    setState(() => isLoadingMore = false);
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
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.storefront_outlined,
                    color: Color(0xffb0b8bb),
                    size: 32,
                  ),
                ),
              ),
            ),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xff8a8f9e)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            store.diaChi,
                            style: const TextStyle(
                                fontSize: 12.5, color: Color(0xff8a8f9e)),
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
              child: Icon(Icons.chevron_right,
                  color: Color(0xffb0b8bb), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xfff2f4f3),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_outlined, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 14),
          const Text(
            "Không có cửa hàng trong bán kính 3km",
            style: TextStyle(color: Color(0xff8a8f9e), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff00b14f),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Cửa hàng gần tôi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, __) => _buildShimmerCard(),
            )
          : allNearby.isEmpty
              ? _buildEmptyState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Count bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xffe8f8ef),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              "${allNearby.length} cửa hàng",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff00913f),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "trong bán kính 3km",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xff8a8f9e),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // List
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        itemCount: displayed.length + (hasMore ? 1 : 0),
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          if (index >= displayed.length) {
                            return _buildShimmerCard();
                          }
                          return _buildStoreCard(displayed[index]);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}