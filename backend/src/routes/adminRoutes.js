const { Router } = require('express');
const { stats } = require('../controllers/adminController');
const { requireAuth } = require('../middleware/auth');
const { asyncHandler } = require('../utils/asyncHandler');

const router = Router();

router.get('/stats', requireAuth, asyncHandler(stats));

module.exports = router;
