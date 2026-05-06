import 'mon_an.dart';

class DonHang {
  int id;
  String tenKhachHang;
  List<MonAn> danhSachMon;

  DonHang(this.id, this.tenKhachHang, this.danhSachMon);

  double tinhTongTien() {
    double tong = 0;
    for (var mon in danhSachMon) {
      tong += mon.gia;
    }
    return tong;
  }

  void hienThiDonHang() {
    print("ID: $id");
    print("Khách hàng: $tenKhachHang");

    print("Danh sách món:");
    for (var mon in danhSachMon) {
      print("- ${mon.ten} (${mon.gia} VNĐ)");
    }

    print("Tổng tiền: ${tinhTongTien()} VNĐ");
  }
}