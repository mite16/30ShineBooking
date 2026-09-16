const { Schema, model } = require('mongoose');

// Services are embedded as a snapshot (id/name/price/duration at booking time)
// instead of a join table, per the NoSQL mapping in docs/database-design.md.
const bookedServiceSchema = new Schema(
  {
    serviceId: { type: Schema.Types.ObjectId, ref: 'Service', required: true },
    name: { type: String, required: true },
    priceVnd: { type: Number, required: true },
    durationMinutes: { type: Number, required: true },
  },
  { _id: false },
);

const bookingSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    salonId: { type: Schema.Types.ObjectId, ref: 'Salon', required: true },
    salonName: { type: String, required: true },
    services: { type: [bookedServiceSchema], required: true },
    stylistId: { type: Schema.Types.ObjectId, ref: 'Stylist', default: null },
    stylistName: { type: String, default: 'Bất kỳ' },
    date: { type: Date, required: true },
    timeSlot: { type: String, required: true },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled'],
      default: 'pending',
    },
    note: { type: String, default: null },
  },
  { timestamps: true },
);

bookingSchema.methods.toPublicJSON = function toPublicJSON() {
  return {
    id: this._id.toString(),
    userId: this.userId.toString(),
    salonId: this.salonId.toString(),
    salonName: this.salonName,
    services: this.services.map((s) => ({
      id: s.serviceId.toString(),
      name: s.name,
      priceVnd: s.priceVnd,
      durationMinutes: s.durationMinutes,
    })),
    stylistId: this.stylistId ? this.stylistId.toString() : null,
    stylistName: this.stylistName,
    date: this.date.toISOString(),
    timeSlot: this.timeSlot,
    status: this.status,
    note: this.note,
  };
};

module.exports = model('Booking', bookingSchema);
