const { GoogleGenerativeAI } = require('@google/generative-ai');

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// System prompt for stress management assistant
const SYSTEM_PROMPT = `You are a compassionate AI stress management assistant for the StressLess app. Your role is to:

1. Provide emotional support and stress management advice
2. Suggest evidence-based coping strategies (breathing exercises, mindfulness, physical activity)
3. Be empathetic, warm, and non-judgmental
4. Keep responses concise (2-4 sentences usually)
5. Encourage professional help for severe cases
6. Never diagnose medical conditions

Guidelines:
- Use a friendly, supportive tone
- Provide actionable advice
- Ask follow-up questions to understand better
- Validate the user's feelings
- Suggest specific techniques when appropriate
- Keep responses clear and helpful

Remember: You're here to support, not replace professional mental health care.`;

/**
 * @desc    Send message to AI chatbot
 * @route   POST /api/chat/message
 * @access  Private
 */
const sendMessage = async (req, res, next) => {
  try {
    const { message, history } = req.body;

    if (!message) {
      return res.status(400).json({
        success: false,
        message: 'Message is required',
      });
    }

    // Check if Gemini API key is configured
    if (!process.env.GEMINI_API_KEY) {
      return res.status(500).json({
        success: false,
        message: 'AI service not configured. Please add GEMINI_API_KEY to environment variables.',
      });
    }

    // Initialize Gemini model
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

    // Build conversation history for context
    const chat = model.startChat({
      history: [
        {
          role: 'user',
          parts: [{ text: SYSTEM_PROMPT }],
        },
        {
          role: 'model',
          parts: [{ text: 'I understand. I\'m here as a compassionate stress management assistant to provide support, coping strategies, and encouragement. I\'ll keep my responses helpful and concise while being warm and empathetic.' }],
        },
        // Add conversation history
        ...(history || []).slice(-10).map(msg => ({
          role: msg.role === 'user' ? 'user' : 'model',
          parts: [{ text: msg.content }],
        })),
      ],
      generationConfig: {
        maxOutputTokens: 200,
        temperature: 0.7,
      },
    });

    // Send message and get response
    const result = await chat.sendMessage(message);
    const response = await result.response;
    const aiResponse = response.text();

    res.status(200).json({
      success: true,
      response: aiResponse,
    });
  } catch (error) {
    console.error('Chat error:', error);
    
    const errorResponse = error.message && error.message.includes('API_KEY')
      ? 'AI service configuration error. Please contact support.'
      : 'I\'m having trouble right now. Please try again in a moment.';

    res.status(500).json({
      success: false,
      message: errorResponse,
    });
  }
};

/**
 * @desc    Get chat history for user
 * @route   GET /api/chat/history
 * @access  Private
 */
const getChatHistory = async (req, res, next) => {
  try {
    res.status(200).json({
      success: true,
      messages: [],
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Clear chat history for user
 * @route   DELETE /api/chat/history
 * @access  Private
 */
const clearChatHistory = async (req, res, next) => {
  try {
    res.status(200).json({
      success: true,
      message: 'Chat history cleared',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  sendMessage,
  getChatHistory,
  clearChatHistory,
};