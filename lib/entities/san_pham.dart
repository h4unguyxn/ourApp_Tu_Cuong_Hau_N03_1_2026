import 'mon_an.dart';
import 'do_uong.dart';
import 'kem.dart';

abstract class SanPham {
  String id;
  String ten;
  double gia;
  String category;
  String cuaHangId;
  String tenCuaHang;
  String? imageUrl;

  SanPham(
    this.id,
    this.ten,
    this.gia,
    this.category,
    this.cuaHangId,
    this.tenCuaHang,
    this.imageUrl,
  );

  factory SanPham.fromMap(Map<String, dynamic> map) {
    final type = map['type'];
    if (type == 'monan') return MonAn.fromMap(map);
    if (type == 'douong') return DoUong.fromMap(map);
    if (type == 'kem') return Kem.fromMap(map);
    throw Exception("Unknown type: $type");
  }

  Map<String, dynamic> toMap();
}