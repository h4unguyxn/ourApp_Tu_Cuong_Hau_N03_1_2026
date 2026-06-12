import 'package:cloud_firestore/cloud_firestore.dart'; // bắt buộc
import 'cart_item.dart';

class DonHang {
  String id;
  String tenKhachHang;
  List<CartItem> danhSachSanPham;

  String? trangThai;
  DateTime? thoiGianHoanThanh;
  DateTime? thoiGianNhanHang;

  DonHang(
    this.id,
    this.tenKhachHang,
    this.danhSachSanPham, {
    this.trangThai,
    this.thoiGianHoanThanh,
    this.thoiGianNhanHang,
  });

  double tinhTongTien() {
    double tong = 0;
    for (var item in danhSachSanPham) {
      tong += item.gia;
    }
    return tong;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenKhachHang': tenKhachHang,
      'danhSachSanPham': danhSachSanPham.map((e) => e.toMap()).toList(),
      'trangThai': trangThai,
      'thoiGianHoanThanh': thoiGianHoanThanh != null ? Timestamp.fromDate(thoiGianHoanThanh!) : null,
      'thoiGianNhanHang': thoiGianNhanHang != null ? Timestamp.fromDate(thoiGianNhanHang!) : null,
    };
  }

  factory DonHang.fromMap(Map<String, dynamic> map) {
    return DonHang(
      map['id'] ?? '',
      map['tenKhachHang'] ?? '',
      (map['danhSachSanPham'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      trangThai: map['trangThai'],
      thoiGianHoanThanh: map['thoiGianHoanThanh'] != null
          ? (map['thoiGianHoanThanh'] is Timestamp
              ? (map['thoiGianHoanThanh'] as Timestamp).toDate()
              : map['thoiGianHoanThanh'] as DateTime)
          : null,
      thoiGianNhanHang: map['thoiGianNhanHang'] != null
          ? (map['thoiGianNhanHang'] is Timestamp
              ? (map['thoiGianNhanHang'] as Timestamp).toDate()
              : map['thoiGianNhanHang'] as DateTime)
          : null,
    );
  }
}