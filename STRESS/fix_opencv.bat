@echo off
echo ========================================
echo Fixing OpenCV GUI Support
echo ========================================
echo.

echo Uninstalling opencv-python...
pip uninstall -y opencv-python opencv-contrib-python

echo.
echo Installing opencv-contrib-python (with GUI support)...
pip install opencv-contrib-python==4.8.1.78

echo.
echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo You can now run: python src\professional_analyzer.py
echo Video window will display properly.
echo.
pause
