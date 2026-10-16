const express = require('express');
const router = express.Router();
const {
  sendMessage,
  getChatHistory,
  clearChatHistory,
} = require('../controllers/chatController');
const { protect } = require('../middleware/auth');

// All chat routes require authentication
router.use(protect);

// Chat routes
router.post('/message', sendMessage);
router.get('/history', getChatHistory);
router.delete('/history', clearChatHistory);

module.exports = router;