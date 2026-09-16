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
| 1 | Đăng ký / Đăng nhập (JWT thật, SharedPreferences lưu token, tự đăng nhập lại) | ✅ |
| 2 | Danh sách chi nhánh + chi tiết chi nhánh | ✅ dữ liệu từ MongoDB |
| 3 | Chọn dịch vụ (nhiều lựa chọn, tính tổng tiền) | ✅ |
| 4 | Chọn thợ cắt (hoặc "Bất kỳ") + chọn ngày + khung giờ trống (chống double-book) | ✅ |
| 5 | Xác nhận đặt lịch + màn hình thành công | ✅ |
| 6 | Lịch sử đặt lịch + chi tiết + huỷ lịch hẹn | ✅ |
| 7 | Trang tài khoản + đăng xuất | ✅ |
| 8 | Kết nối RESTful API thật tới backend riêng | ✅ Node.js + Express (`backend/`) |
| 9 | Lưu dữ liệu vào database server thật (không SQLite) | ✅ MongoDB |
| 10a | Thống kê cho quản lý (tổng lịch hẹn, doanh thu, top dịch vụ) | ✅ API `/api/admin/stats` (chưa có màn hình riêng) |
| 10b | Local notification | ⏳ Chưa làm |
| 10c | Chat giữa user | ⏳ Chưa làm |
| 10d | Thanh toán VNPay/MoMo | ⏳ Cần tài khoản sandbox VNPay/MoMo (tự đăng ký, miễn phí) trước khi code phần này |

Mục 1–9 và 10a đã chạy với **dữ liệu thật** qua backend riêng (không còn mock), theo đúng
kiến trúc Repository pattern định sẵn từ Slot 6: `lib/repositories/*.dart` gọi HTTP thay vì
trả dữ liệu giả lập, còn `providers/` và toàn bộ `screens/` giữ nguyên không đổi.

## 4. Công nghệ sử dụng

- **Frontend:** Flutter 3.47 / Dart 3.13, Material 3
- **State management:** Provider (`ChangeNotifier`)
- **Backend:** Node.js + Express (thư mục `backend/`)
- **Database:** MongoDB (Mongoose ODM) — không dùng SQLite
- **Auth:** JWT (`jsonwebtoken`) + mật khẩu băm bằng `bcryptjs`
- **Local storage (Flutter):** `shared_preferences` (lưu token phiên đăng nhập)
- **Kiến trúc:** Repository pattern — UI → Provider → Repository → REST API → MongoDB
- **Testing:** `flutter_test` — unit test cho `Validators`, widget test cho `LoginScreen`

## 5. Cấu trúc thư mục

```
lib/
  main.dart               Khởi tạo app, đăng ký Provider
  app.dart                MaterialApp + theme
  models/                 Các model: User, Salon, ServiceItem, Stylist, Booking (đều có fromJson)
  services/api_client.dart  Wrapper http + đính kèm JWT (Module 8 pattern)
  repositories/           AuthRepository, BookingRepository — gọi REST API thật
  providers/              AuthProvider, BookingProvider (ChangeNotifier)
  screens/
    splash_screen.dart
    auth/                 login_screen.dart, register_screen.dart
    home/                 home_shell.dart (bottom nav), home_tab.dart, salon_detail_screen.dart
    booking/              service_selection, booking_schedule, booking_review, booking_success
    my_bookings/          my_bookings_screen.dart, booking_detail_screen.dart
    profile/              profile_screen.dart
  widgets/                Các widget dùng chung (card, button, tile, error+retry...)
  utils/                  validators.dart, formatters.dart
docs/
  database-design.md      ERD + danh sách bảng (Slot 6 deliverable)
backend/                  REST API + MongoDB — xem backend/README.md
test/
  unit/validators_test.dart
  widget/login_screen_test.dart
```

## 6. Cách chạy app (cả frontend lẫn backend)

```bash
# 1. Chạy backend trước (xem chi tiết trong backend/README.md)
cd backend
cp .env.example .env
npm install
npm run seed        # nạp 3 chi nhánh, 5 dịch vụ, 9 thợ mẫu vào MongoDB
npm run dev          # http://localhost:4000

# 2. Chạy app Flutter (terminal khác, tại thư mục gốc)
flutter pub get
flutter run                 # chọn thiết bị/emulator Android, hoặc:
flutter run -d chrome       # chạy thử nhanh trên web
flutter test                # chạy unit + widget test
flutter analyze             # kiểm tra lint
```

App gọi API tại `http://localhost:4000/api` khi chạy web/desktop, và
`http://10.0.2.2:4000/api` khi chạy trên Android emulator (xem `lib/services/api_client.dart`).
Chạy trên máy thật (điện thoại) hoặc để cả nhóm cùng test cần đổi `baseUrl` thành địa chỉ
IP LAN của máy chạy backend, hoặc deploy backend lên một server thật.

**Tài khoản demo có sẵn:** `demo@30shine.vn` / `123456` (đã điền sẵn ở màn Đăng nhập) —
cần chạy `npm run seed` **và** đăng ký tài khoản này một lần qua màn Đăng ký trước khi dùng
được, vì seed script chỉ tạo salons/services/stylists, không tạo sẵn user.

## 7. Lộ trình theo mốc slot (đề PE)

- [x] **Slot 6** — Flutter source khởi tạo đủ, UI các màn Login/Register/Home/chức năng
      chính, navigation hoạt động, thiết kế CSDL (ERD), README này.
- [x] **Slot 12** — Backend Node.js/Express + MongoDB thật, REST API đầy đủ cho
      Login/Register + CRUD lịch hẹn, test được bằng curl/Postman (xem `backend/README.md`).
- [ ] **Slot 16** — Đã thay xong repository mock bằng API thật + xử lý loading/lỗi/retry;
      còn lại: deploy backend lên server thật (Render/Railway/VPS...) để chạy ngoài máy dev.
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
