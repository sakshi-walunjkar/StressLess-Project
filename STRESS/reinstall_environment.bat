@echo off
echo ========================================
echo Reinstalling Virtual Environment
echo ========================================
echo.

echo Step 1: Deactivating current environment...
call deactivate 2>nul

echo.
echo Step 2: Removing old virtual environment...
if exist venv (
    rmdir /s /q venv
    echo ✓ Old venv removed
) else (
    echo ✓ No old venv found
)

echo.
echo Step 3: Creating fresh virtual environment...
python -m venv venv
echo ✓ Virtual environment created

echo.
echo Step 4: Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Step 5: Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Step 6: Installing dependencies...
pip install -r requirements.txt

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Virtual environment is now active.
echo.
echo Next steps:
echo   cd src
echo   python professional_analyzer.py
echo.
pause
