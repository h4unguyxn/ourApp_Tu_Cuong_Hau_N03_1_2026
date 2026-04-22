# HCT Food - Ứng dụng đặt đồ ăn

## Thành viên
- Nguyễn Xuân Hậu - 23010206
- Nguyễn Mạnh Cường - 23010271
- Nguyễn Xuân Tú - 23010538
  
## Công nghệ
- Flutter
- Dart
- GitHub
# 📱 HCT Food - Bài thực hành 02

## 🧾 Giới thiệu
Bài thực hành 02 xây dựng mô hình dữ liệu cho ứng dụng đặt đồ ăn **HCT Food** bằng Flutter.  
Mục tiêu là sử dụng các biến cơ bản và Collections (List, Map) để quản lý và hiển thị dữ liệu lên giao diện.

---

## 🎯 Nội dung thực hiện

### 1. Sử dụng biến
Khai báo các biến để mô tả thông tin món ăn:

- `int idFood`: mã món ăn  
- `String tenMon`: tên món  
- `int soLuong`: số lượng  
- `String nhaHang`: nơi bán  
- `String namBan`: năm bán  

---

### 2. Sử dụng Collections

#### 👤 Người dùng (Map)
```dart
var user = {
  'id': 1,
  'ten': 'Nguyễn Mạnh Cường'
};
