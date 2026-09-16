const { Schema, model } = require('mongoose');

const salonSchema = new Schema({
  name: { type: String, required: true },
  district: { type: String, required: true },
  address: { type: String, required: true },
  rating: { type: Number, default: 4.5 },
  openHours: { type: String, default: '08:00 - 21:00' },
});

module.exports = model('Salon', salonSchema);
