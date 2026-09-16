const { Router } = require('express');
const {
  availableSlots,
  createBooking,
  myBookings,
  cancelBooking,
} = require('../controllers/bookingController');
const { requireAuth } = require('../middleware/auth');
const { asyncHandler } = require('../utils/asyncHandler');

const router = Router();

router.use(requireAuth);

router.get('/available-slots', asyncHandler(availableSlots));
router.post('/', asyncHandler(createBooking));
router.get('/my', asyncHandler(myBookings));
router.patch('/:id/cancel', asyncHandler(cancelBooking));

module.exports = router;
