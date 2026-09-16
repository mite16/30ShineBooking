const Salon = require('../models/Salon');
const Service = require('../models/Service');
const Stylist = require('../models/Stylist');

async function listSalons(req, res) {
  const salons = await Salon.find().sort({ name: 1 });
  res.json(salons.map((s) => ({
    id: s._id.toString(),
    name: s.name,
    district: s.district,
    address: s.address,
    rating: s.rating,
    openHours: s.openHours,
  })));
}

async function listServices(req, res) {
  const services = await Service.find().sort({ category: 1 });
  res.json(services.map((s) => ({
    id: s._id.toString(),
    name: s.name,
    description: s.description,
    priceVnd: s.priceVnd,
    durationMinutes: s.durationMinutes,
    category: s.category,
  })));
}

async function listStylists(req, res) {
  const stylists = await Stylist.find({ salonId: req.params.salonId });
  res.json(stylists.map((s) => ({
    id: s._id.toString(),
    salonId: s.salonId.toString(),
    name: s.name,
    level: s.level,
    rating: s.rating,
  })));
}

module.exports = { listSalons, listServices, listStylists };
