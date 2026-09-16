const Booking = require('../models/Booking');

/**
 * Minimal manager-facing statistics endpoint (the "báo cáo thống kê quan
 * trọng của người quản lý" item from the PE's 6-điểm tier). Any logged-in
 * user can call it today; add a `role` field on User + check it here once
 * the team needs a real admin-only gate.
 */
async function stats(req, res) {
  const bookings = await Booking.find({ status: { $ne: 'cancelled' } });

  const totalBookings = bookings.length;
  const totalRevenueVnd = bookings.reduce(
    (sum, b) => sum + b.services.reduce((s, svc) => s + svc.priceVnd, 0),
    0,
  );

  const byStatus = { pending: 0, confirmed: 0, completed: 0, cancelled: 0 };
  const allBookings = await Booking.find();
  allBookings.forEach((b) => { byStatus[b.status] = (byStatus[b.status] || 0) + 1; });

  const revenueBySalon = {};
  const countByService = {};
  bookings.forEach((b) => {
    revenueBySalon[b.salonName] = (revenueBySalon[b.salonName] || 0)
      + b.services.reduce((s, svc) => s + svc.priceVnd, 0);
    b.services.forEach((svc) => {
      countByService[svc.name] = (countByService[svc.name] || 0) + 1;
    });
  });

  const topServices = Object.entries(countByService)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([name, count]) => ({ name, count }));

  res.json({
    totalBookings,
    totalRevenueVnd,
    byStatus,
    revenueBySalon,
    topServices,
  });
}

module.exports = { stats };
