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

* Static là biến/phương thức thuộc class
* Gọi bằng: `ClassName.method()`
* Ưu điểm: tiết kiệm bộ nhớ
* Nhược điểm: dễ gây lỗi nếu dùng chung

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
```

---

## 📌 Câu 3: Class Food

```dart
class Food {
  int id;
  String name;
  int price;
  int quantity;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  void display() {
    print('$id - $name - $price - $quantity');
  }
}
```

---

## 📌 Câu 4: CRUD

```dart
class ListFood {
  List<Food> foods = [];

  void addFood(Food food) {
    foods.add(food);
  }

  void getAllFood() {
    for (var food in foods) {
      food.display();
    }
  }

  void updateFood(int id, String name, int price, int quantity) {
    for (var food in foods) {
      if (food.id == id) {
        food.name = name;
        food.price = price;
        food.quantity = quantity;
      }
    }
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

# 📸 Demo



