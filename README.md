# HCT Food - Ứng dụng đặt đồ ăn
## 🧾 Giới thiệu

HCT Food là một ứng dụng đặt đồ ăn toàn diện được phát triển trên nền tảng Flutter, nhằm mang đến trải nghiệm đặt món tiện lợi và nhanh chóng cho người dùng. Ứng dụng cho phép người dùng tìm kiếm và lựa chọn các món ăn, đồ uống và kem từ nhiều cửa hàng khác nhau, với thông tin chi tiết về giá cả, hình ảnh và đánh giá cửa hàng.  

Người dùng có thể:
- Tìm kiếm món ăn yêu thích hoặc khám phá các cửa hàng gần vị trí hiện tại của mình thông qua GPS.
- Lựa chọn size cho đồ uống và kem, đồng thời theo dõi giá tương ứng.
- Thêm món vào giỏ hàng, tăng giảm số lượng hoặc xóa món dễ dàng.
- Đặt hàng và theo dõi trạng thái đơn hàng: "Đang giao" hoặc "Lịch sử đơn hàng".
- Cập nhật và quản lý địa chỉ giao hàng một cách linh hoạt, sử dụng GPS hoặc nhập thủ công.
- Quản lý thông tin cá nhân, đăng xuất an toàn và theo dõi phiên bản ứng dụng.  

Ứng dụng sử dụng Firebase Firestore để lưu trữ dữ liệu thời gian thực, giúp đồng bộ thông tin giữa người dùng và cửa hàng, đảm bảo rằng giỏ hàng, đơn hàng và dữ liệu sản phẩm luôn được cập nhật tức thì. Tích hợp Provider giúp quản lý trạng thái giỏ hàng một cách hiệu quả, còn Geolocator hỗ trợ xác định vị trí chính xác để hiển thị cửa hàng gần nhất.  

HCT Food hướng đến việc cung cấp trải nghiệm đặt đồ ăn liền mạch, trực quan và hiện đại, giúp người dùng tiết kiệm thời gian và mang lại sự hài lòng tối đa khi đặt món online.

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



