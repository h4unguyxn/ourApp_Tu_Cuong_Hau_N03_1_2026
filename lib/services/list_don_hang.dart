import '../entities/don_hang.dart';

class ListDonHang {
  List<DonHang> listDonHang = [];

  // CREATE
  void themDonHang(DonHang dh) {
    listDonHang.add(dh);
  }

  // READ
  void hienThi() {
    for (var dh in listDonHang) {
      print("Đơn ${dh.id} - ${dh.tenKhachHang} - Tổng: ${dh.tinhTongTien()}");
    }
  }

  // UPDATE
  void suaDonHang(int id, DonHang moi) {
    for (int i = 0; i < listDonHang.length; i++) {
      if (listDonHang[i].id == id) {
        listDonHang[i] = moi;
        break;
      }
    }
  }

  // DELETE
  void xoaDonHang(int id) {
    listDonHang.removeWhere((dh) => dh.id == id);
  }
}