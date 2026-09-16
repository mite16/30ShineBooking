// One-off script: node src/seed/seed.js
// Seeds the same salons/services/stylists used by the Flutter mock data,
// so switching the app from mock repositories to the real API shows
// identical content.
require('dotenv').config();
const { connectDb } = require('../config/db');
const Salon = require('../models/Salon');
const Service = require('../models/Service');
const Stylist = require('../models/Stylist');
const mongoose = require('mongoose');

const salons = [
  { name: '30Shine Cầu Giấy', district: 'Cầu Giấy', address: '123 Xuân Thuỷ, Cầu Giấy, Hà Nội', rating: 4.7, openHours: '08:00 - 21:00' },
  { name: '30Shine Đống Đa', district: 'Đống Đa', address: '45 Tây Sơn, Đống Đa, Hà Nội', rating: 4.5, openHours: '08:00 - 21:00' },
  { name: '30Shine Hai Bà Trưng', district: 'Hai Bà Trưng', address: '78 Bạch Mai, Hai Bà Trưng, Hà Nội', rating: 4.8, openHours: '08:00 - 21:30' },
];

const services = [
  { name: 'Cắt gội cơ bản', description: 'Cắt tạo kiểu + gội massage thư giãn', priceVnd: 89000, durationMinutes: 30, category: 'cutWash' },
  { name: 'Cắt gội cao cấp', description: 'Tư vấn kiểu tóc riêng + gội dưỡng sinh', priceVnd: 159000, durationMinutes: 45, category: 'cutWash' },
  { name: 'Nhuộm thời trang', description: 'Nhuộm phủ bạc hoặc lên màu thời trang', priceVnd: 350000, durationMinutes: 90, category: 'dyeing' },
  { name: 'Uốn tạo kiểu', description: 'Uốn định hình theo khuôn mặt', priceVnd: 420000, durationMinutes: 120, category: 'perm' },
  { name: 'Combo Cắt + Gội dưỡng + Ráy tai', description: 'Trải nghiệm đầy đủ, tiết kiệm hơn mua lẻ', priceVnd: 199000, durationMinutes: 60, category: 'combo' },
];

const stylistTemplate = [
  { name: 'Anh Tuấn', level: 'Thợ chính', rating: 4.9 },
  { name: 'Anh Long', level: 'Thợ chính', rating: 4.6 },
  { name: 'Anh Đức', level: 'Thợ phụ', rating: 4.3 },
];

async function seed() {
  await connectDb();

  await Promise.all([Salon.deleteMany({}), Service.deleteMany({}), Stylist.deleteMany({})]);

  const createdSalons = await Salon.insertMany(salons);
  await Service.insertMany(services);

  const stylistDocs = createdSalons.flatMap((salon) =>
    stylistTemplate.map((st) => ({ ...st, salonId: salon._id })),
  );
  await Stylist.insertMany(stylistDocs);

  console.log(`Seeded ${createdSalons.length} salons, ${services.length} services, ${stylistDocs.length} stylists.`);
  await mongoose.disconnect();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
