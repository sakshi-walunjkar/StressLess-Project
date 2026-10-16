# QUICK REFERENCE GUIDE

## 🚀 Start Here

### First Time Setup
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Fix OpenCV (if video window doesn't show)
.\fix_opencv.bat

# 3. Train the model (one-time, takes 1-2 minutes)
python train_stress_model.py
```

### Run the Application
```bash
python stress_detection_app.py
```

---

## 📋 What the App Does

### 1️⃣ Login Screen
- Enter your name
- Read instructions

### 2️⃣ Webcam Analysis (15 seconds)
- **Automatic capture** - Just sit still
- **Auto-calculates:**
  - Blink rate (blinks per minute)
  - Facial stress score
- Video window shows progress

### 3️⃣ Health Input Form
- Enter 6 parameters:
  1. Heart Rate (bpm)
  2. SpO₂ (%)
  3. Body Temperature (°C)
  4. Systolic BP (mmHg)
  5. Diastolic BP (mmHg)
  6. Sleep Hours
- Blink rate & facial stress are **pre-filled**

### 4️⃣ Results
- Stress Level: **Low / Medium / High**
- Personalized recommendations
- Results saved automatically

---

## 📊 Normal Ranges (Reference)

| Parameter | Normal Range |
|-----------|-------------|
| Heart Rate | 60-100 bpm |
| SpO₂ | 95-100% |
| Body Temp | 36.5-37.5°C |
| Systolic BP | 90-120 mmHg |
| Diastolic BP | 60-80 mmHg |
| Sleep | 7-9 hours |
| Blink Rate | 15-20 per min |

---

## 🎯 Stress Levels Explained

### 🟢 LOW STRESS
- All parameters normal
- Relaxed state
- **Action:** Maintain lifestyle

### 🟡 MEDIUM STRESS
- Some parameters elevated
- Moderate stress
- **Action:** Take breaks, breathe

### 🔴 HIGH STRESS
- Multiple parameters abnormal
- Significant stress
- **Action:** Rest immediately, seek help

---

## 🔧 Troubleshooting

### Problem: Webcam not opening
**Solution:**
- Check camera permissions
- Close other apps using camera
- Restart application

### Problem: Video window not showing
**Solution:**
```bash
.\fix_opencv.bat
```

### Problem: Model not found
**Solution:**
```bash
python train_stress_model.py
```

### Problem: Import errors
**Solution:**
```bash
pip install -r requirements.txt
```

---

## 📁 Files You Need

### Essential Files:
- `stress_detection_app.py` - Main application
- `train_stress_model.py` - Model trainer
- `src/facial_detector.py` - Facial analysis
- `data/WESAD_Stress_Dataset_Final.xlsx` - Dataset
- `models/stress_model.pkl` - Trained model (created after training)

### Helper Files:
- `run_app.bat` - Quick launcher
- `fix_opencv.bat` - Fix video display
- `requirements.txt` - Dependencies

---

## 💾 Where Results Are Saved

```
results/stress_detection_results.csv
```

Contains:
- Timestamp
- User name
- All input parameters
- Stress level
- Stress code

---

## ⚡ Quick Commands

```bash
# Train model
python train_stress_model.py

# Run app
python stress_detection_app.py

# Quick start (train + run)
.\run_app.bat

# Fix OpenCV
.\fix_opencv.bat

# Check dataset
python analyze_wesad.py
```

---

## 🎓 Model Info

- **Algorithm:** Random Forest
- **Accuracy:** 99.65%
- **Features:** 8 parameters
- **Classes:** 3 (Low/Medium/High)
- **Training Data:** 15,500 samples

---

## 📞 Need Help?

1. Check `README.md` for detailed docs
2. Check `PROJECT_TRANSFORMATION.md` for system overview
3. Verify all files are present
4. Ensure model is trained
5. Check webcam is working

---

## ✅ Checklist Before Running

- [ ] Dependencies installed (`pip install -r requirements.txt`)
- [ ] OpenCV working (video window shows)
- [ ] Model trained (`models/stress_model.pkl` exists)
- [ ] Webcam connected and working
- [ ] Good lighting for facial capture

---

## 🎉 You're Ready!

```bash
python stress_detection_app.py
```

**Enjoy stress-free living! 💚**
