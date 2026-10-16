@echo off
echo ========================================
echo STRESS DETECTION SYSTEM - QUICK START
echo ========================================
echo.

echo Step 1: Training the Model
echo ========================================
echo.
echo Training stress detection model using WESAD dataset...
python train_stress_model.py

echo.
echo.
echo Step 2: Running the Application
echo ========================================
echo.
pause

python stress_detection_app.py

echo.
echo ========================================
echo Session Complete!
echo ========================================
pause
