const { Schema, model } = require('mongoose');

// 1:1 conversations only (2 participants) — keeps the "user trao đổi với
// nhau" bonus feature simple. participantIds is always stored sorted so a
// conversation between A and B is found the same way regardless of who
// started it.
const conversationSchema = new Schema(
  {
    participantIds: {
      type: [{ type: Schema.Types.ObjectId, ref: 'User' }],
      validate: (v) => v.length === 2,
      required: true,
    },
    lastMessageText: { type: String, default: null },
    lastMessageAt: { type: Date, default: null },
  },
  { timestamps: true },
);

conversationSchema.index({ participantIds: 1 });

module.exports = model('Conversation', conversationSchema);
