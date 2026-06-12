import 'san_pham.dart';

class DoUong extends SanPham {
  Map<String, double> prices;

  DoUong(
    super.id,
    super.ten,
    super.gia,
    super.category,
    super.cuaHangId,
    super.tenCuaHang,
    this.prices,
    super.imageUrl,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ten': ten,
      'gia': gia,
      'category': category,
      'cuaHangId': cuaHangId,
      'tenCuaHang': tenCuaHang,
      'prices': prices,
      'type': 'douong',
      'imageUrl': imageUrl,
    };
  }

  factory DoUong.fromMap(Map<String, dynamic> map) {
    final rawPrices = Map<String, dynamic>.from(map['prices'] ?? {});
    final prices = rawPrices.map((k, v) => MapEntry(k, (v as num).toDouble()));

    final gia = map['gia'] != null 
        ? (map['gia'] as num).toDouble()  // <- convert num -> double
        : (prices.isNotEmpty ? prices.values.first : 0.0);

    return DoUong(
      map['id'] ?? '',
      map['ten'] ?? '',
      gia,
      map['category'] ?? '',
      map['cuaHangId'] ?? '',
      map['tenCuaHang'] ?? '',
      prices,
      map['imageUrl'],
    );
  }
}