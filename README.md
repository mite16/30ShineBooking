# 30Shine Booking — PRM393 PE

## 1. Tên đề tài

**Ứng dụng đặt lịch cắt tóc cho 30Shine** — cho phép khách hàng chọn chi nhánh, dịch vụ,
thợ cắt và khung giờ để đặt lịch cắt tóc, theo dõi và huỷ lịch hẹn đã đặt.

> Lưu ý: đây là bài **PE**, phải **khác đề tài** với đồ án nhóm (ASM) của cùng nhóm, theo
> yêu cầu của giảng viên. Cả hai dự án đều làm theo nhóm tối đa 5 người và push GitHub
> theo tiến độ slot.

## 2. Mô tả ứng dụng

Khách hàng mở app → đăng nhập/đăng ký → chọn 1 trong các chi nhánh 30Shine gần mình →
chọn dịch vụ (cắt gội, nhuộm, uốn, combo...) → chọn thợ cắt (hoặc "Bất kỳ") + ngày giờ
trống → xem lại & xác nhận → nhận lịch hẹn. Khách có thể xem lại lịch sử đặt lịch và huỷ
lịch hẹn chưa diễn ra ở tab "Lịch hẹn".

## 3. Chức năng dự kiến

| # | Chức năng | Trạng thái Slot 6 |
|---|---|---|
| 1 | Đăng ký / Đăng nhập (session lưu qua SharedPreferences, tự đăng nhập lại) | ✅ UI + logic mock |
| 2 | Danh sách chi nhánh + chi tiết chi nhánh | ✅ UI + dữ liệu mock |
| 3 | Chọn dịch vụ (nhiều lựa chọn, tính tổng tiền) | ✅ |
| 4 | Chọn thợ cắt (hoặc "Bất kỳ") + chọn ngày + khung giờ trống | ✅ |
| 5 | Xác nhận đặt lịch + màn hình thành công | ✅ |
| 6 | Lịch sử đặt lịch + chi tiết + huỷ lịch hẹn | ✅ |
| 7 | Trang tài khoản + đăng xuất | ✅ |
| 8 | Kết nối RESTful API thật tới backend riêng | ⏳ Slot 12 |
| 9 | Lưu dữ liệu vào database server thật (không SQLite) | ⏳ Slot 12 |
| 10 | (Khuyến khích) Thanh toán VNPay/MoMo, thống kê cho quản lý, chat giữa user, notification | ⏳ Chưa làm |

Toàn bộ chức năng 1–7 hiện chạy trên **dữ liệu & service giả lập** (`lib/repositories/`),
cùng một mẫu hình với các Mock Service dùng trong Module 10/11 của môn — để chạy được
ngay không phụ thuộc backend, và để khi có API thật ở Slot 12 chỉ cần thay nội dung 2 file
repository mà không đụng tới UI.

## 4. Công nghệ sử dụng

- **Frontend:** Flutter 3.47 / Dart 3.13, Material 3
- **State management:** Provider (`ChangeNotifier`)
- **Local storage:** `shared_preferences` (lưu token phiên đăng nhập)
- **Kiến trúc:** Repository pattern — UI → Provider → Repository → (mock hiện tại / REST API thật ở Slot 12)
- **Backend & Database (dự kiến, quyết định trước Slot 12):** chưa chốt — xem `docs/database-design.md`
  mục "Nếu chọn NoSQL" để so sánh hướng SQL (MySQL/SQL Server) và NoSQL (MongoDB/Firebase)
- **Testing:** `flutter_test` — unit test cho `Validators`, widget test cho `LoginScreen`

## 5. Cấu trúc thư mục

```
lib/
  main.dart               Khởi tạo app, đăng ký Provider
  app.dart                MaterialApp + theme
  models/                 Các model: User, Salon, ServiceItem, Stylist, Booking
  data/mock_data.dart     Dữ liệu mẫu (chi nhánh, dịch vụ, thợ, khung giờ)
  repositories/           AuthRepository, BookingRepository (sẽ đổi sang gọi API thật ở Slot 12)
  providers/              AuthProvider, BookingProvider (ChangeNotifier)
  screens/
    splash_screen.dart
    auth/                 login_screen.dart, register_screen.dart
    home/                 home_shell.dart (bottom nav), home_tab.dart, salon_detail_screen.dart
    booking/              service_selection, booking_schedule, booking_review, booking_success
    my_bookings/          my_bookings_screen.dart, booking_detail_screen.dart
    profile/              profile_screen.dart
  widgets/                Các widget dùng chung (card, button, tile...)
  utils/                  validators.dart, formatters.dart
docs/
  database-design.md      ERD + danh sách bảng (Slot 6 deliverable)
test/
  unit/validators_test.dart
  widget/login_screen_test.dart
```

## 6. Cách chạy app

```bash
flutter pub get
flutter run                 # chọn thiết bị/emulator Android, hoặc:
flutter run -d chrome       # chạy thử nhanh trên web
flutter test                # chạy unit + widget test
flutter analyze             # kiểm tra lint
```

**Tài khoản demo có sẵn:** `demo@30shine.vn` / `123456` (đã điền sẵn ở màn Đăng nhập).

## 7. Lộ trình theo mốc slot (đề PE)

- [x] **Slot 6** — Flutter source khởi tạo đủ, UI các màn Login/Register/Home/chức năng
      chính, navigation hoạt động, thiết kế CSDL (ERD), README này.
- [ ] **Slot 12** — Dựng backend (Node.js/PHP/Java/C#/Python) + database thật, REST API
      cho Login/Register + CRUD chức năng chính, test bằng Postman/Swagger.
- [ ] **Slot 16** — Thay repository mock bằng API thật, hoàn thiện xử lý loading/lỗi,
      đồng bộ backend.
- [ ] **Slot 18** — Nộp link YouTube demo + GitHub (Flutter + Backend) + link chợ ứng dụng.

## 8. Phân công (cập nhật khi đủ nhóm)

| Thành viên | Màn hình phụ trách |
|---|---|
| _(điền tên)_ | Splash, Login, Register |
| _(điền tên)_ | Home, Salon detail |
| _(điền tên)_ | Service selection, Booking schedule |
| _(điền tên)_ | Booking review/success, My bookings, Booking detail |
| _(điền tên)_ | Profile, Backend & API (Slot 12) |

> Theo đề PE: mỗi thành viên phải code tối thiểu 2 màn hình và tất cả cần commit lên
> GitHub đúng tiến độ mô tả ở mục 7.
