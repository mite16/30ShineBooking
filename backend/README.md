# 30Shine Booking — Backend (Node.js + Express + MongoDB)

REST API cho app Flutter `booking30shine`. Không dùng SQLite — dữ liệu lưu ở MongoDB.

## Cách chạy

```bash
cd backend
cp .env.example .env      # chỉnh MONGODB_URI nếu cần
npm install
npm run seed               # nạp dữ liệu mẫu: 3 chi nhánh, 5 dịch vụ, 9 thợ cắt
npm run dev                 # http://localhost:4000, tự reload khi sửa code
```

Yêu cầu MongoDB đang chạy tại `MONGODB_URI` trong `.env` (mặc định
`mongodb://127.0.0.1:27017/booking30shine`). 3 cách để có MongoDB chạy:

1. **MongoDB Community Server (portable, khuyến nghị cho máy chưa cài gì)** — tải file
   zip tương ứng hệ điều hành tại mongodb.com/try/download/community, giải nén, rồi chạy:
   ```bash
   # Windows, từ thư mục bin/ sau khi giải nén
   mongod.exe --dbpath "<đường-dẫn-thư-mục-data-bất-kỳ>" --port 27017
   ```
   Để chạy nền: dùng Docker `docker run -d -p 27017:27017 --name mongo mongo:8` nếu máy
   có Docker Desktop đang bật.
2. **Cài MongoDB Community Edition** theo hướng dẫn chính thức (chạy như Windows Service,
   không cần tự gõ lệnh `mongod` mỗi lần).
3. **MongoDB Atlas (cloud, miễn phí, không cần cài gì)** — tạo tài khoản tại
   mongodb.com/atlas, tạo cluster free tier, lấy connection string rồi dán vào
   `MONGODB_URI` trong `.env`. Phù hợp nhất khi cả nhóm cần dùng chung 1 database —
   không cần sửa bất kỳ dòng code nào khác.

Muốn đổi giữa các cách trên, chỉ cần sửa `MONGODB_URI`, không đụng tới code.

## Danh sách API

| Method | Endpoint | Auth | Mô tả |
|---|---|---|---|
| GET | `/api/health` | – | Kiểm tra server sống |
| POST | `/api/auth/register` | – | `{fullName, phone, email, password}` → `{token, user}` |
| POST | `/api/auth/login` | – | `{emailOrPhone, password}` → `{token, user}` |
| GET | `/api/auth/me` | Bearer token | Thông tin user hiện tại |
| GET | `/api/salons` | – | Danh sách chi nhánh |
| GET | `/api/services` | – | Danh sách dịch vụ |
| GET | `/api/salons/:salonId/stylists` | – | Danh sách thợ cắt của 1 chi nhánh |
| GET | `/api/bookings/available-slots?salonId=&date=YYYY-MM-DD` | Bearer token | Khung giờ còn trống |
| POST | `/api/bookings` | Bearer token | Tạo lịch hẹn: `{salonId, serviceIds[], stylistId?, date, timeSlot, note?}` |
| GET | `/api/bookings/my` | Bearer token | Lịch sử đặt lịch của user hiện tại |
| PATCH | `/api/bookings/:id/cancel` | Bearer token | Huỷ lịch hẹn |
| GET | `/api/admin/stats` | Bearer token | Thống kê: tổng lịch hẹn, doanh thu, top dịch vụ (mục "khuyến khích" 6 điểm) |

Gửi token ở header: `Authorization: Bearer <token>` — đúng pattern JWT học ở Module 10.

## Test nhanh bằng curl

```bash
curl -X POST http://localhost:4000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Nguyen Van A","phone":"0911111111","email":"a@test.com","password":"123456"}'

curl http://localhost:4000/api/salons
```

Hoặc import các endpoint trên vào Postman/Swagger để demo theo đúng yêu cầu Slot 12
("API test được bằng Postman/Swagger").
