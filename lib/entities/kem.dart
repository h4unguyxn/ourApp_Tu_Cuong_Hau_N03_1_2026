import 'san_pham.dart';

class Kem extends SanPham {
  Map<String, double> prices;

  Kem(
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
      'category': category, // ví dụ "kem"
      'cuaHangId': cuaHangId,
      'tenCuaHang': tenCuaHang,
      'prices': prices,
      'type': 'kem', 
      'imageUrl': imageUrl,
    };
  }

  factory Kem.fromMap(Map<String, dynamic> map) {
    final rawPrices = Map<String, dynamic>.from(map['prices'] ?? {});
    final prices = rawPrices.map((k, v) => MapEntry(k, (v as num).toDouble()));

    final gia = map['gia'] != null
        ? (map['gia'] as num).toDouble()
        : (prices.isNotEmpty ? prices.values.first : 0.0);

    return Kem(
      map['id'] ?? '',
      map['ten'] ?? '',
      gia,
      map['category'] ?? 'kem', // mặc định kem
      map['cuaHangId'] ?? '',
      map['tenCuaHang'] ?? '',
      prices,
      map['imageUrl'],
    );
  }
}