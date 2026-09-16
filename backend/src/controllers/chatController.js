const Conversation = require('../models/Conversation');
const Message = require('../models/Message');
const User = require('../models/User');

function sortedPair(a, b) {
  return [a.toString(), b.toString()].sort();
}

async function conversationToJson(conversation, myUserId) {
  const otherId = conversation.participantIds.find((id) => id.toString() !== myUserId);
  const peer = await User.findById(otherId);
  return {
    id: conversation._id.toString(),
    peer: peer ? peer.toPublicJSON() : { id: otherId?.toString(), fullName: 'Người dùng đã xoá', phone: '', email: '' },
    lastMessageText: conversation.lastMessageText,
    lastMessageAt: conversation.lastMessageAt ? conversation.lastMessageAt.toISOString() : null,
  };
}

async function listConversations(req, res) {
  const conversations = await Conversation.find({ participantIds: req.userId })
    .sort({ lastMessageAt: -1, updatedAt: -1 });

  const json = await Promise.all(conversations.map((c) => conversationToJson(c, req.userId)));
  res.json(json);
}

async function startConversation(req, res) {
  const { phoneOrEmail } = req.body;
  if (!phoneOrEmail) {
    return res.status(400).json({ message: 'Thiếu số điện thoại hoặc email' });
  }

  const peer = await User.findOne({
    $or: [{ email: phoneOrEmail.toLowerCase() }, { phone: phoneOrEmail }],
  });
  if (!peer) {
    return res.status(404).json({ message: 'Không tìm thấy người dùng với thông tin này' });
  }
  if (peer._id.toString() === req.userId) {
    return res.status(400).json({ message: 'Không thể tự nhắn tin cho chính mình' });
  }

  const participantIds = sortedPair(req.userId, peer._id);
  let conversation = await Conversation.findOne({ participantIds });
  if (!conversation) {
    conversation = await Conversation.create({ participantIds });
  }

  res.status(201).json(await conversationToJson(conversation, req.userId));
}

async function requireParticipant(conversationId, userId) {
  const conversation = await Conversation.findById(conversationId);
  if (!conversation) return null;
  if (!conversation.participantIds.some((id) => id.toString() === userId)) return null;
  return conversation;
}

async function listMessages(req, res) {
  const conversation = await requireParticipant(req.params.id, req.userId);
  if (!conversation) return res.status(404).json({ message: 'Không tìm thấy cuộc trò chuyện' });

  const messages = await Message.find({ conversationId: conversation._id }).sort({ createdAt: 1 });
  res.json(messages.map((m) => ({
    id: m._id.toString(),
    conversationId: m.conversationId.toString(),
    senderId: m.senderId.toString(),
    text: m.text,
    createdAt: m.createdAt.toISOString(),
  })));
}

async function sendMessage(req, res) {
  const { text } = req.body;
  if (!text || !text.trim()) {
    return res.status(400).json({ message: 'Tin nhắn không được để trống' });
  }

  const conversation = await requireParticipant(req.params.id, req.userId);
  if (!conversation) return res.status(404).json({ message: 'Không tìm thấy cuộc trò chuyện' });

  const message = await Message.create({
    conversationId: conversation._id,
    senderId: req.userId,
    text: text.trim(),
  });

  conversation.lastMessageText = message.text;
  conversation.lastMessageAt = message.createdAt;
  await conversation.save();

  res.status(201).json({
    id: message._id.toString(),
    conversationId: message.conversationId.toString(),
    senderId: message.senderId.toString(),
    text: message.text,
    createdAt: message.createdAt.toISOString(),
  });
}

module.exports = { listConversations, startConversation, listMessages, sendMessage };
