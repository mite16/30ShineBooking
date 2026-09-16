const { Router } = require('express');
const {
  listConversations,
  startConversation,
  listMessages,
  sendMessage,
} = require('../controllers/chatController');
const { requireAuth } = require('../middleware/auth');
const { asyncHandler } = require('../utils/asyncHandler');

const router = Router();

router.use(requireAuth);

router.get('/conversations', asyncHandler(listConversations));
router.post('/conversations', asyncHandler(startConversation));
router.get('/conversations/:id/messages', asyncHandler(listMessages));
router.post('/conversations/:id/messages', asyncHandler(sendMessage));

module.exports = router;
