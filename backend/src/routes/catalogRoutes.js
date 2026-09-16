const { Router } = require('express');
const { listSalons, listServices, listStylists } = require('../controllers/catalogController');
const { asyncHandler } = require('../utils/asyncHandler');

const router = Router();

router.get('/salons', asyncHandler(listSalons));
router.get('/services', asyncHandler(listServices));
router.get('/salons/:salonId/stylists', asyncHandler(listStylists));

module.exports = router;
