# HCT Food - Ứng dụng đặt đồ ăn
## 🧾 Giới thiệu

HCT Food là ứng dụng đặt đồ ăn được xây dựng bằng Flutter trong khuôn khổ môn học Lập trình thiết bị di động.
Project bao gồm các bài thực hành từ cơ bản đến nâng cao: tạo framework, quản lý dữ liệu và lập trình hướng đối tượng.

---

## Thành viên
- Nguyễn Xuân Hậu - 23010206
- Nguyễn Mạnh Cường - 23010271
- Nguyễn Xuân Tú - 23010538
  
## Công nghệ
- Flutter
- Dart
- GitHub

# 🚀 BÀI THỰC HÀNH 01

## 🎯 Nội dung

* Tạo repository GitHub cho nhóm
* Tạo framework Flutter
* Hiển thị thông tin nhóm trên app

## 🛠 Kết quả

* App chạy thành công với tiêu đề **HCT Food**
* Hiển thị đầy đủ thành viên

---

# 📦 BÀI THỰC HÀNH 02

## 🎯 Nội dung

### 1. Sử dụng biến

* int, String để mô tả món ăn

### 2. Collections

* Map: lưu thông tin người dùng
* List + Map: lưu danh sách món ăn

### 3. Hiển thị dữ liệu

* Dùng Text, Row, ListView để hiển thị

## 📊 Dữ liệu mẫu

```dart
var user = {
  'id': 1,
  'ten': 'Nguyễn Văn Cường'
};

var listFood = [
  {'idFood': 1, 'tenMon': 'Burger', 'soLuong': 10, 'nhaHang': 'HCT Food', 'namBan': '2026'},
  {'idFood': 2, 'tenMon': 'Pizza', 'soLuong': 20, 'nhaHang': 'HCT Food', 'namBan': '2025'},
  {'idFood': 3, 'tenMon': 'Trà sữa', 'soLuong': 30, 'nhaHang': 'HCT Food', 'namBan': '2024'}
];
```

## 🛠 Kết quả

* Hiển thị thành công danh sách món ăn
* Giao diện rõ ràng, dễ nhìn

---

# 🧠 BÀI THỰC HÀNH 03

## 📌 Câu 1: Static

Static là gì?
Trong lập trình (đặc biệt là Java, C++, C#), static là một từ khóa dùng để khai báo các thành phần (biến, phương thức, lớp lồng) thuộc về lớp (class) thay vì thuộc về đối tượng (object). Điều này có nghĩa là tất cả các đối tượng của lớp sẽ dùng chung một bản sao duy nhất của thành phần static. Ví dụ: một biến static sẽ không thay đổi theo từng object mà chỉ tồn tại một lần trong bộ nhớ.

Cách sử dụng static:

Biến static (static variable): Dùng để lưu dữ liệu chung cho tất cả các đối tượng.
Ví dụ: đếm số lượng object đã tạo.
Phương thức static (static method): Có thể gọi trực tiếp bằng tên lớp mà không cần tạo object.
Ví dụ: Math.sqrt() trong Java.
Khối static (static block): Dùng để khởi tạo dữ liệu tĩnh ngay khi lớp được load.
Lớp static (trong Java): Thường dùng cho lớp lồng (nested class).
Ưu điểm của static:

Tiết kiệm bộ nhớ vì chỉ tồn tại một bản duy nhất.
Dễ truy cập, không cần tạo object vẫn dùng được.
Phù hợp cho các giá trị dùng chung như hằng số (static final).
Nhược điểm của static:

Khó kiểm soát khi nhiều nơi cùng thay đổi giá trị (dễ gây lỗi).
Làm giảm tính hướng đối tượng (OOP), vì không gắn với object.
Khó mở rộng và kiểm thử (test), đặc biệt trong các hệ thống lớn.
Tóm lại, static rất hữu ích khi cần chia sẻ dữ liệu hoặc chức năng chung, nhưng cần sử dụng hợp lý để tránh ảnh hưởng đến thiết kế chương trình.

---

## 📌 Câu 2: Generics

### Ý tưởng

Tạo class tổng quát để xử lý nhiều kiểu dữ liệu

```dart
class MyGeneric<T> {
  T obj;

  MyGeneric(this.obj);

  void printData() {
    print(obj);
  }
}

void main() {
  var student = [
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ];

  var myData = MyGeneric(student);

  myData.printData();
}
```

---

## 📌 Câu 3: Class

```dart
import 'monan.dart';

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
```

---

## 📌 Câu 4: CRUD

```dart
import 'donhang.dart';

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
```

---

## 🎯 Kết quả đạt được

* Hiểu về Generics trong Dart
* Áp dụng OOP vào project
* Xây dựng CRUD cơ bản

---

# 🛠 Công nghệ sử dụng

* Flutter
* Dart
* GitHub

---

# 🚀 Hướng phát triển

* Xây dựng UI đặt đồ ăn
* Kết nối API
* Thêm chức năng đăng nhập
* Thanh toán online

---

# Bài kiểm tra giữa kỳ Flutter

## Thành viên nhóm

| STT | Họ tên | Công việc |
|---|---|---|
| 1 | Nguyễn Mạnh Cường | About Screen |
| 2 | Nguyễn Xuân Hậu | Home Screen|
| 3 | Nguyễn Xuân Tú | Content Screen |

## Phân chia màn hình

- Home: `lib/screens/home_screen.dart`
- Content: `lib/screens/content_screen.dart`
- About: `lib/screens/about_screen.dart`

## Cách chạy project

```bash
flutter pub get
flutter run



