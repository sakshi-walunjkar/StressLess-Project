# StressLess Backend API

Complete authentication backend for the StressLess mobile application.

## 🏗️ Tech Stack

- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB ODM
- **JWT** - Authentication tokens
- **Bcrypt** - Password hashing

## 📋 Features

- ✅ User Registration (with age and gender)
- ✅ User Login
- ✅ JWT Authentication
- ✅ Password Encryption
- ✅ Protected Routes
- ✅ Error Handling
- ✅ Input Validation

## 🚀 Quick Start

### Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or Atlas cloud)
- npm or yarn

### Installation

1. **Navigate to backend folder:**
```bash
cd stressless-backend
```

2. **Install dependencies:**
```bash
npm install
```

3. **Create .env file:**
```bash
cp .env.example .env
```

4. **Edit .env file with your settings:**
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/stressless
JWT_SECRET=your_secret_key_change_this
JWT_EXPIRE=7d
CORS_ORIGIN=*
```

### Running the Server

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

Server will run on: `http://localhost:5000`

## 📡 API Endpoints

### Authentication Routes

#### 1. Register User
```http
POST /api/auth/register
Content-Type: application/json

Request Body:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "age": 25,
  "gender": "Male"
}

Response (201 Created):
{
  "success": true,
  "message": "Registration successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "65abc123...",
    "name": "John Doe",
    "email": "john@example.com",
    "age": 25,
    "gender": "Male",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}

Error Response (400):
{
  "success": false,
  "message": "Email already registered. Please login."
}
```

#### 2. Login User
```http
POST /api/auth/login
Content-Type: application/json

Request Body:
{
  "email": "john@example.com",
  "password": "password123"
}

Response (200 OK):
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "65abc123...",
    "name": "John Doe",
    "email": "john@example.com",
    "age": 25,
    "gender": "Male",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}

Error Response (401):
{
  "success": false,
  "message": "Invalid email or password"
}
```

#### 3. Get Current User (Protected)
```http
GET /api/auth/me
Authorization: Bearer <token>

Response (200 OK):
{
  "success": true,
  "user": {
    "id": "65abc123...",
    "name": "John Doe",
    "email": "john@example.com",
    "age": 25,
    "gender": "Male",
    "created_at": "2024-01-15T10:30:00.000Z",
    "updated_at": "2024-01-15T10:30:00.000Z"
  }
}
```

#### 4. Logout (Protected)
```http
POST /api/auth/logout
Authorization: Bearer <token>

Response (200 OK):
{
  "success": true,
  "message": "Logout successful"
}
```

### Utility Routes

#### Health Check
```http
GET /health

Response:
{
  "success": true,
  "message": "StressLess API is running!",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### API Documentation
```http
GET /

Response:
{
  "success": true,
  "message": "Welcome to StressLess API",
  "version": "1.0.0",
  "endpoints": {
    "auth": {
      "register": "POST /api/auth/register",
      "login": "POST /api/auth/login",
      "getMe": "GET /api/auth/me",
      "logout": "POST /api/auth/logout"
    }
  }
}
```

## 🗄️ Database Schema

### User Model
```javascript
{
  name: String (required, 2-50 chars),
  email: String (required, unique, lowercase),
  password: String (required, hashed, min 6 chars),
  age: Number (required, 13-120),
  gender: String (required, enum: ['Male', 'Female', 'Other', 'Prefer not to say']),
  profileImage: String (optional),
  isActive: Boolean (default: true),
  createdAt: Date (auto),
  updatedAt: Date (auto)
}
```

## 🔐 Authentication Flow

1. User registers → Password is hashed → User saved to DB → JWT token generated
2. User logs in → Password verified → JWT token generated
3. Protected routes → JWT token verified → User data attached to request
4. User logs out → Token deleted on client side

## 📁 Project Structure

```
stressless-backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/
│   └── authController.js    # Auth logic
├── middleware/
│   ├── auth.js              # JWT verification
│   └── errorHandler.js      # Error handling
├── models/
│   └── User.js              # User schema
├── routes/
│   └── auth.js              # Auth routes
├── utils/
│   └── jwt.js               # JWT utilities
├── .env.example             # Environment variables template
├── .gitignore               # Git ignore file
├── package.json             # Dependencies
├── README.md                # Documentation
└── server.js                # Main server file
```

## 🧪 Testing with Postman

### Import this collection:

1. **Register User:**
   - Method: POST
   - URL: `http://localhost:5000/api/auth/register`
   - Body (JSON):
   ```json
   {
     "name": "Test User",
     "email": "test@example.com",
     "password": "test123",
     "age": 25,
     "gender": "Male"
   }
   ```

2. **Login User:**
   - Method: POST
   - URL: `http://localhost:5000/api/auth/login`
   - Body (JSON):
   ```json
   {
     "email": "test@example.com",
     "password": "test123"
   }
   ```
   - Copy the `token` from response

3. **Get Current User:**
   - Method: GET
   - URL: `http://localhost:5000/api/auth/me`
   - Headers:
     - Key: `Authorization`
     - Value: `Bearer <paste_token_here>`

## 🌐 Deployment Options

### 1. Render (Recommended - Free)
1. Push code to GitHub
2. Go to [render.com](https://render.com)
3. Create new Web Service
4. Connect GitHub repo
5. Add environment variables
6. Deploy!

### 2. Railway (Free tier)
1. Go to [railway.app](https://railway.app)
2. Create new project
3. Deploy from GitHub
4. Add environment variables

### 3. Heroku
1. Install Heroku CLI
2. `heroku login`
3. `heroku create stressless-api`
4. `git push heroku main`

## 🔒 Security Features

- ✅ Password hashing with bcrypt (10 rounds)
- ✅ JWT token authentication
- ✅ Protected routes middleware
- ✅ Input validation
- ✅ CORS enabled
- ✅ No sensitive data in responses
- ✅ Error messages don't expose system info

## 📝 Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `PORT` | Server port | `5000` |
| `MONGODB_URI` | MongoDB connection string | `mongodb://localhost:27017/stressless` |
| `JWT_SECRET` | Secret key for JWT | `your_secret_key` |
| `JWT_EXPIRE` | Token expiration time | `7d` |
| `CORS_ORIGIN` | Allowed CORS origins | `*` or `http://localhost:3000` |

## 🐛 Common Issues

### MongoDB Connection Error
```bash
Error: connect ECONNREFUSED 127.0.0.1:27017
```
**Solution:** Make sure MongoDB is running:
```bash
# Windows
net start MongoDB

# Mac/Linux
sudo systemctl start mongod
```

### Port Already in Use
```bash
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution:** Change PORT in .env file or kill the process:
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:5000 | xargs kill -9
```

## 📞 Support

For issues or questions:
- Check the documentation
- Review error messages
- Test with Postman
- Check MongoDB connection

## 🎓 For Academic Project

**Project Report Sections:**
1. ✅ System Architecture
2. ✅ Database Design (ER Diagram)
3. ✅ API Documentation
4. ✅ Security Implementation
5. ✅ Authentication Flow Diagram
6. ✅ Testing Results

**Viva Questions to Prepare:**
- How does JWT authentication work?
- Why use bcrypt for password hashing?
- What is middleware in Express?
- How do you secure API routes?
- What is the difference between authentication and authorization?

## 📄 License

MIT License - Feel free to use for your academic project!

---

**Built for StressLess Final Year Project** 🎓
