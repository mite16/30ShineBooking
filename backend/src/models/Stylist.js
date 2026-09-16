const { Schema, model } = require('mongoose');

const stylistSchema = new Schema({
  salonId: { type: Schema.Types.ObjectId, ref: 'Salon', required: true },
  name: { type: String, required: true },
  level: { type: String, default: 'Thợ chính' },
  rating: { type: Number, default: 4.5 },
});

module.exports = model('Stylist', stylistSchema);
