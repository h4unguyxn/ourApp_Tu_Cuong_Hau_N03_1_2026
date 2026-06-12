import 'package:flutter/material.dart';

import '../entities/cua_hang.dart';
import '../entities/san_pham.dart';
import '../services/cua_hang_service.dart';
import '../services/san_pham_service.dart';
import 'store_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? category;
  final String? keyword;

  const SearchScreen({super.key, this.category, this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CuaHangService _cuaHangService = CuaHangService();
  final SanPhamService _sanPhamService = SanPhamService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<CuaHang> filteredStores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.keyword != null) {
      _controller.text = widget.keyword!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _loadStores(keyword: widget.keyword);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStores({String? keyword}) async {
    setState(() => isLoading = true);

    final allStores = await _cuaHangService.getAll();
    final allItems = await _sanPhamService.getAllSanPham();

    String? category = widget.category;
    String? searchKeyword = keyword?.toLowerCase().trim();

    List<SanPham> matchedItems = allItems.where((item) {
      bool matchesCategory = category == null || item.category == category;
      bool matchesKeyword = searchKeyword == null ||
          searchKeyword.isEmpty ||
          item.ten.toLowerCase().contains(searchKeyword) ||
          item.tenCuaHang.toLowerCase().contains(searchKeyword);
      return matchesCategory && matchesKeyword;
    }).toList();

    final storeIds = matchedItems.map((e) => e.cuaHangId).toSet();
    filteredStores =
        allStores.where((store) => storeIds.contains(store.id)).toList();

    setState(() => isLoading = false);
  }

  void _performSearch() {
    _loadStores(keyword: _controller.text);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xff8a8f9e)),
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
              child: Icon(Icons.chevron_right,
                  color: Color(0xffb0b8bb), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xffe8f8ef),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded,
                  size: 36, color: Color(0xff00b14f)),
            ),
            const SizedBox(height: 18),
            const Text(
              "Không tìm thấy cửa hàng",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff1a1a2e),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Thử tìm với từ khoá khác hoặc danh mục khác nhé",
              textAlign: TextAlign.center,
              style: TextStyle(
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
        iconTheme: const IconThemeData(color: Color(0xff1a1a2e)),
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xff1a1a2e),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          children: [
            // ── Search bar ───────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                  const SizedBox(width: 14),
                  const Icon(Icons.search_rounded,
                      color: Color(0xff8a8f9e), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onSubmitted: (_) => _performSearch(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff1a1a2e),
                      ),
                      decoration: const InputDecoration(
                        hintText: "Nhập tên món ăn hoặc cửa hàng...",
                        hintStyle: TextStyle(
                          color: Color(0xff8a8f9e),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _performSearch,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xff00b14f),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.search_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Results ──────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff00b14f),
                        strokeWidth: 2.5,
                      ),
                    )
                  : filteredStores.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          children:
                              filteredStores.map(_buildStoreCard).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}