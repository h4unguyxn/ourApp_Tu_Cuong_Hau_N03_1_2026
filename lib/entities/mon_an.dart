import 'san_pham.dart';

class MonAn extends SanPham {
  MonAn(
    super.id,
    super.ten,
    super.gia,
    super.category,
    super.cuaHangId,
    super.tenCuaHang,
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
      'type': 'monan',
      'imageUrl': imageUrl,
    };
  }

  factory MonAn.fromMap(Map<String, dynamic> map) {
    return MonAn(
      map['id'] ?? '',
      map['ten'] ?? '',
      (map['gia'] as num? ?? 0).toDouble(),
      map['category'] ?? '',
      map['cuaHangId'] ?? '',
      map['tenCuaHang'] ?? '',
      map['imageUrl'], // <-- new field
    );
  }
}