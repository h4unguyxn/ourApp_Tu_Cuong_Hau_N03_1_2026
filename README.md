# HCT Food - Ứng dụng đặt đồ ăn
## 🧾 Giới thiệu

HCT Food là ứng dụng đặt đồ ăn được xây dựng bằng Flutter trong khuôn khổ môn học Lập trình thiết bị di động.
Project bao gồm các bài thực hành từ cơ bản đến nâng cao: tạo framework, quản lý dữ liệu và lập trình hướng đối tượng.

---

## Thành viên
- Nguyễn Xuân Hậu - 23010206
- Nguyễn Mạnh Cường - 23010271
- Nguyễn Xuân Tú - 23010538
  

## 🔹 Demo
- Link demo: *(chèn link nếu có)*

## 🔹 Tính năng chính
1. **Đăng nhập / Đăng ký**  
   - Bảo mật bằng hash SHA-256.
   - Kiểm tra số điện thoại hợp lệ.

2. **Trang chủ (HomeScreen)**  
   - Hiển thị cửa hàng gần nhất dựa trên GPS.
   - Hiển thị các danh mục: cơm, bún, đồ ăn nhanh, đồ uống.

3. **Tìm kiếm (SearchScreen)**  
   - Tìm kiếm theo tên món ăn hoặc cửa hàng.
   - Lọc theo danh mục món ăn.

4. **Chi tiết cửa hàng (StoreDetailScreen)**  
   - Xem danh sách món ăn, đồ uống, kem.
   - Đối với đồ uống/kem: chọn size và giá tương ứng.
   - Thêm món vào giỏ hàng.

5. **Giỏ hàng & Đơn hàng (ContentScreen)**  
   - Xem, tăng/giảm số lượng món.
   - Đặt hàng, xem trạng thái "Đang giao" hoặc "Lịch sử".

6. **Thông tin người dùng (AboutScreen)**  
   - Xem số điện thoại, phiên bản app.
   - Đăng xuất.

7. **Địa chỉ giao hàng (LocationAppBarTitle)**  
   - Lấy vị trí hiện tại bằng GPS hoặc nhập thủ công.

---

## 🔹 Công nghệ sử dụng
- **Flutter & Dart**
- **Firebase Firestore**: quản lý dữ liệu cửa hàng, món ăn, đơn hàng, người dùng.
- **Provider**: quản lý trạng thái giỏ hàng.
- **Geolocator**: xác định vị trí người dùng.
- **HTTP**: truy xuất địa chỉ từ OpenStreetMap.

---

## 🔹 Cấu trúc thư mục
```
lib/
 ├─ entities/          # Các model: SanPham, MonAn, DoUong, Kem, CartItem, DonHang, CuaHang
 ├─ services/          # Service kết nối Firestore, quản lý dữ liệu & Cart
 ├─ screens/           # Các màn hình Flutter
 ├─ widgets/           # Widget tái sử dụng (LocationAppBarTitle)
 ├─ main.dart          # Entry point
 └─ firebase_options.dart
assets/
 └─ images/            # Logo, icon, ảnh mặc định
```

---

## 🔹 Cài đặt & Chạy ứng dụng
1. **Clone repo**
```bash
git clone <link-github>
cd <ten-project>
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy app**
```bash
flutter run
```

> Lưu ý: cần cấu hình Firebase project và file `firebase_options.dart` tương ứng.

---

## 🔹 Quy trình phát triển
- Phát triển theo **User Stories**:
  1. Người dùng đăng nhập/đăng ký
  2. Xem danh mục món ăn và cửa hàng gần
  3. Thêm món ăn vào giỏ, chọn size đồ uống/kem
  4. Đặt hàng, xem trạng thái đơn
  5. Quản lý địa chỉ giao hàng
- Sử dụng **Git commit** để track tiến độ từng thành viên.

---
flutter run



