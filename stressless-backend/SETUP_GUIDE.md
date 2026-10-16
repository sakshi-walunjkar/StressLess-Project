# 🚀 SETUP GUIDE - StressLess Backend

## Step-by-Step Instructions for Getting Backend Running

### Part 1: Install MongoDB

#### Option A: Local MongoDB (Recommended for Development)

**Windows:**
1. Download MongoDB Community Server: https://www.mongodb.com/try/download/community
2. Run the installer
3. Choose "Complete" installation
4. Install MongoDB as a Service (check the box)
5. Install MongoDB Compass (GUI tool - check the box)
6. Click Install

**Verify MongoDB is running:**
```powershell
# Open Command Prompt and type:
mongod --version
```

#### Option B: MongoDB Atlas (Cloud - Free)

1. Go to: https://www.mongodb.com/cloud/atlas/register
2. Create a free account
3. Create a free M0 cluster
4. Click "Connect" → "Connect your application"
5. Copy the connection string (looks like: `mongodb+srv://username:password@cluster.mongodb.net/`)
6. Replace `<password>` with your password
7. Replace `myFirstDatabase` with `stressless`

---

### Part 2: Setup Backend Project

1. **Extract the backend folder to your D: drive:**
```
D:\Projects\stressless-backend\
```

2. **Open Terminal/PowerShell in the backend folder:**
```powershell
cd D:\Projects\stressless-backend
```

3. **Install Node.js dependencies:**
```powershell
npm install
```

Wait for all packages to install (takes 2-3 minutes).

4. **Create .env file:**
```powershell
copy .env.example .env
```

5. **Edit the .env file:**

Open `D:\Projects\stressless-backend\.env` in any text editor and update:

**For Local MongoDB:**
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/stressless
JWT_SECRET=stressless_secret_key_2024_bbefyp
JWT_EXPIRE=7d
CORS_ORIGIN=*
```

**For MongoDB Atlas (Cloud):**
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb+srv://your_username:your_password@cluster.mongodb.net/stressless?retryWrites=true&w=majority
JWT_SECRET=stressless_secret_key_2024_bbefyp
JWT_EXPIRE=7d
CORS_ORIGIN=*
```

---

### Part 3: Start the Backend Server

1. **Run the server:**
```powershell
npm start
```

You should see:
```
✅ MongoDB Connected: localhost
📊 Database: stressless
🚀 Server is running on port 5000
📍 API URL: http://localhost:5000
```

**If you see this, YOUR BACKEND IS RUNNING! 🎉**

---

### Part 4: Test the Backend

#### Test 1: Health Check

Open your browser and go to:
```
http://localhost:5000/health
```

You should see:
```json
{
  "success": true,
  "message": "StressLess API is running!",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### Test 2: Register a User (Using PowerShell)

```powershell
curl -X POST http://localhost:5000/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{\"name\":\"Test User\",\"email\":\"test@example.com\",\"password\":\"test123\",\"age\":25,\"gender\":\"Male\"}'
```

You should get a response with a `token` and user data!

#### Test 3: Login (Using PowerShell)

```powershell
curl -X POST http://localhost:5000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"email\":\"test@example.com\",\"password\":\"test123\"}'
```

---

### Part 5: Connect Flutter App to Backend

Now that backend is running, update your Flutter app:

1. **Open your Flutter project**

2. **Find and update `api_endpoints.dart`:**

Location: `D:\Projects\stressless_app\lib\core\constants\api_endpoints.dart`

Change:
```dart
class ApiEndpoints {
  // Base URL - Update this with your backend URL
  static const String baseUrl = 'http://10.0.2.2:5000/api';  // For Android Emulator
  // static const String baseUrl = 'http://localhost:5000/api';  // For Web
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String getMe = '$baseUrl/auth/me';
}
```

**Important:** 
- For **Android Emulator**: Use `10.0.2.2` (this is the emulator's way to access localhost)
- For **Physical Device**: Use your computer's IP address (e.g., `http://192.168.1.100:5000/api`)
- For **Web**: Use `localhost`

3. **Test Flutter app:**
```powershell
cd D:\Projects\stressless_app
flutter run
```

Now try registering a new user in your Flutter app - it should work!

---

### Part 6: View Database (Optional)

#### Using MongoDB Compass (GUI):

1. Open MongoDB Compass
2. Connection string: `mongodb://localhost:27017`
3. Click Connect
4. You'll see `stressless` database
5. Click on `users` collection to see registered users

---

## 🔧 Troubleshooting

### Problem 1: MongoDB Connection Error
```
❌ MongoDB Connection Error: connect ECONNREFUSED
```

**Solution:**
- Make sure MongoDB is running
- Windows: Check Services → MongoDB should be "Running"
- Or start manually: `net start MongoDB`

### Problem 2: Port 5000 Already in Use
```
Error: listen EADDRINUSE :::5000
```

**Solution:**
Change PORT in .env file to 5001 or 3000

### Problem 3: npm install fails
```
npm ERR! code ENOENT
```

**Solution:**
- Make sure you're in the correct directory
- Make sure Node.js is installed: `node --version`

### Problem 4: Flutter app says "Connection Error"

**Solution:**
1. Make sure backend is running (`npm start`)
2. Check the IP address in `api_endpoints.dart`
3. For emulator, use `10.0.2.2` not `localhost`

---

## 📱 Next Steps After Backend is Working:

1. ✅ Test registration in Flutter app
2. ✅ Test login in Flutter app
3. ✅ Verify token is saved in Flutter
4. ✅ Build Health Metrics Input Screen
5. ✅ Integrate ML models
6. ✅ Add stress tracking

---

## 🎯 Backend is Ready When:

- [ ] Server starts without errors
- [ ] MongoDB connects successfully
- [ ] Health check returns success
- [ ] Can register new user via API
- [ ] Can login with credentials
- [ ] Flutter app can connect and register/login

---

## 📞 Quick Commands Reference:

```powershell
# Start MongoDB (if not running as service)
net start MongoDB

# Stop MongoDB
net stop MongoDB

# Start backend server
cd D:\Projects\stressless-backend
npm start

# Start Flutter app
cd D:\Projects\stressless_app
flutter run

# Check if backend is running
curl http://localhost:5000/health
```

---

**Good luck! You're almost there!** 🚀

If you face any issues, check the error messages carefully and refer to the troubleshooting section.
