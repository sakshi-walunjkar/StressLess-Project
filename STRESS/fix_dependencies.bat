@echo off
echo ========================================
echo Fixing Dependencies
echo ========================================
echo.

echo Uninstalling problematic packages...
pip uninstall -y deepface tf-keras protobuf

echo.
echo Installing compatible protobuf...
pip install protobuf==3.20.3

echo.
echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo You can now run: python src\professional_analyzer.py
pause
