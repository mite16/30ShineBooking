const { Schema, model } = require('mongoose');

const serviceSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, default: '' },
  priceVnd: { type: Number, required: true },
  durationMinutes: { type: Number, required: true },
  category: {
    type: String,
    enum: ['cutWash', 'dyeing', 'perm', 'combo'],
    default: 'cutWash',
  },
});

module.exports = model('Service', serviceSchema);
