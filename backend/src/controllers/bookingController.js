const Booking = require('../models/Booking');
const Salon = require('../models/Salon');
const Service = require('../models/Service');
const Stylist = require('../models/Stylist');

const ALL_TIME_SLOTS = [
  '09:00', '09:30', '10:00', '10:30',
  '14:00', '14:30', '15:00', '16:00', '16:30',
  '19:00', '19:30',
];

function startOfDay(dateStr) {
  const d = new Date(dateStr);
  d.setHours(0, 0, 0, 0);
  return d;
}

function endOfDay(dateStr) {
  const d = new Date(dateStr);
  d.setHours(23, 59, 59, 999);
  return d;
}

async function availableSlots(req, res) {
  const { salonId, date } = req.query;
  if (!salonId || !date) {
    return res.status(400).json({ message: 'Thiếu salonId hoặc date' });
  }

  const taken = await Booking.find({
    salonId,
    status: { $ne: 'cancelled' },
    date: { $gte: startOfDay(date), $lte: endOfDay(date) },
  }).select('timeSlot');

  const takenSlots = new Set(taken.map((b) => b.timeSlot));
  res.json(ALL_TIME_SLOTS.filter((slot) => !takenSlots.has(slot)));
}

async function createBooking(req, res) {
  const { salonId, serviceIds, stylistId, date, timeSlot, note } = req.body;

  if (!salonId || !Array.isArray(serviceIds) || serviceIds.length === 0 || !date || !timeSlot) {
    return res.status(400).json({ message: 'Thiếu thông tin đặt lịch' });
  }

  const salon = await Salon.findById(salonId);
  if (!salon) return res.status(404).json({ message: 'Không tìm thấy chi nhánh' });

  const services = await Service.find({ _id: { $in: serviceIds } });
  if (services.length !== serviceIds.length) {
    return res.status(400).json({ message: 'Có dịch vụ không hợp lệ' });
  }

  let stylistName = 'Bất kỳ';
  if (stylistId) {
    const stylist = await Stylist.findById(stylistId);
    if (!stylist) return res.status(404).json({ message: 'Không tìm thấy thợ cắt' });
    stylistName = stylist.name;
  }

  // Re-check the slot is still free right before booking (avoid double-booking).
  const clash = await Booking.findOne({
    salonId,
    timeSlot,
    status: { $ne: 'cancelled' },
    date: { $gte: startOfDay(date), $lte: endOfDay(date) },
  });
  if (clash) {
    return res.status(409).json({ message: 'Khung giờ này vừa có người đặt, vui lòng chọn giờ khác' });
  }

  const booking = await Booking.create({
    userId: req.userId,
    salonId,
    salonName: salon.name,
    services: services.map((s) => ({
      serviceId: s._id,
      name: s.name,
      priceVnd: s.priceVnd,
      durationMinutes: s.durationMinutes,
    })),
    stylistId: stylistId || null,
    stylistName,
    date: new Date(date),
    timeSlot,
    note: note || null,
  });

  res.status(201).json(booking.toPublicJSON());
}

async function myBookings(req, res) {
  const bookings = await Booking.find({ userId: req.userId }).sort({ date: -1 });
  res.json(bookings.map((b) => b.toPublicJSON()));
}

async function cancelBooking(req, res) {
  const booking = await Booking.findOne({ _id: req.params.id, userId: req.userId });
  if (!booking) return res.status(404).json({ message: 'Không tìm thấy lịch hẹn' });

  booking.status = 'cancelled';
  await booking.save();
  res.json(booking.toPublicJSON());
}

module.exports = { availableSlots, createBooking, myBookings, cancelBooking };
