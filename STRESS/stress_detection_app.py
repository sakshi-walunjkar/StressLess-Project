"""
Professional Stress Detection System
- User Login
- Webcam Facial Analysis (auto-capture blink rate)
- User Input Form (HR, HRV, SpO2, Temp, Sleep, BP)
- ML-based Stress Prediction
- Recommendations
"""

import cv2
import numpy as np
import time
import pandas as pd
from datetime import datetime
from src.facial_detector import FacialLandmarkDetector
import os

class StressDetectionSystem:
    def __init__(self):
        self.facial_detector = FacialLandmarkDetector()
        self.user_name = ""
        self.blink_rate = 0
        self.facial_stress_score = 0
        self.model = None
        self.load_model()
        
    def load_model(self):
        """Load trained stress detection model"""
        model_path = 'models/stress_model.pkl'
        if os.path.exists(model_path):
            import joblib
            self.model = joblib.load(model_path)
            print("✓ Stress detection model loaded")
        else:
            print("⚠ Model not found. Train model first: python train_stress_model.py")
    
    def clear_screen(self):
        """Clear terminal screen"""
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def print_header(self, title):
        """Print formatted header"""
        print("\n" + "="*70)
        print(f"{title:^70}")
        print("="*70 + "\n")
    
    def user_login(self):
        """User login screen"""
        self.clear_screen()
        self.print_header("STRESS DETECTION SYSTEM - LOGIN")
        
        print("Welcome to the Professional Stress Detection System")
        print("\nThis system will:")
        print("  1. Capture your facial expressions via webcam")
        print("  2. Calculate your eye blink rate automatically")
        print("  3. Collect your health parameters")
        print("  4. Predict your stress level using AI")
        print("  5. Provide personalized recommendations")
        
        print("\n" + "-"*70)
        self.user_name = input("\nEnter your name: ").strip()
        
        if not self.user_name:
            self.user_name = "User"
        
        print(f"\n✓ Welcome, {self.user_name}!")
        input("\nPress Enter to start webcam analysis...")
        
        return True
    
    def webcam_analysis(self):
        """Capture facial data and calculate blink rate"""
        self.clear_screen()
        self.print_header("WEBCAM FACIAL ANALYSIS")
        
        print(f"Hello {self.user_name},")
        print("\nThe webcam will now capture your facial expressions for 15 seconds.")
        print("\nPlease:")
        print("  - Sit comfortably in front of the camera")
        print("  - Maintain natural expression")
        print("  - Look at the camera")
        print("  - Blink naturally")
        
        input("\nPress Enter when ready...")
        
        # Open webcam
        cap = cv2.VideoCapture(0)
        
        if not cap.isOpened():
            print("\n✗ Error: Could not open webcam")
            print("Please check your camera and try again.")
            return False
        
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        
        print("\n" + "="*70)
        print("CAPTURING... Please stay still")
        print("="*70)
        
        duration = 15  # seconds
        start_time = time.time()
        frame_count = 0
        blink_start_count = self.facial_detector.total_blinks
        
        facial_stress_scores = []
        
        print("\nProgress: ", end="", flush=True)
        
        try:
            while time.time() - start_time < duration:
                ret, frame = cap.read()
                if not ret:
                    break
                
                frame_count += 1
                
                # Show progress
                if frame_count % 30 == 0:
                    elapsed = int(time.time() - start_time)
                    remaining = duration - elapsed
                    print(f"█", end="", flush=True)
                
                # Detect blinks and facial features
                avg_ear, total_blinks, frame = self.facial_detector.detect_blink(frame)
                
                # Calculate basic facial stress (based on EAR)
                if avg_ear > 0:
                    # Lower EAR = more stress/fatigue
                    baseline_ear = 0.28
                    if avg_ear < baseline_ear:
                        stress = min((baseline_ear - avg_ear) / 0.15, 1.0)
                    else:
                        stress = 0.1
                    facial_stress_scores.append(stress)
                
                # Display frame
                cv2.putText(frame, f"Analyzing... {duration - int(time.time() - start_time)}s remaining", 
                           (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
                cv2.putText(frame, f"Blinks detected: {self.facial_detector.total_blinks - blink_start_count}", 
                           (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
                
                cv2.imshow('Facial Analysis - Please wait...', frame)
                
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break
            
            cv2.destroyAllWindows()
            cap.release()
            
            # Calculate results
            total_blinks_period = self.facial_detector.total_blinks - blink_start_count
            elapsed_time = time.time() - start_time
            self.blink_rate = (total_blinks_period / elapsed_time) * 60 if elapsed_time > 0 else 0
            self.facial_stress_score = np.mean(facial_stress_scores) if facial_stress_scores else 0.5
            
            print(" Done!\n")
            print("="*70)
            print("ANALYSIS COMPLETE")
            print("="*70)
            print(f"\n✓ Blink Rate: {self.blink_rate:.1f} blinks/minute")
            print(f"✓ Facial Stress Score: {self.facial_stress_score:.3f}")
            print(f"✓ Total Frames Analyzed: {frame_count}")
            
            input("\nPress Enter to continue to health parameters form...")
            return True
            
        except Exception as e:
            print(f"\n✗ Error during analysis: {e}")
            cap.release()
            cv2.destroyAllWindows()
            return False
    
    def user_input_form(self):
        """Collect health parameters from user"""
        self.clear_screen()
        self.print_header("HEALTH PARAMETERS INPUT")
        
        print(f"User: {self.user_name}")
        print(f"Blink Rate: {self.blink_rate:.1f} blinks/min (auto-captured)")
        print(f"Facial Stress Score: {self.facial_stress_score:.3f} (auto-calculated)")
        
        print("\n" + "-"*70)
        print("Please enter your current health parameters:")
        print("-"*70)
        
        try:
            # Heart Rate
            while True:
                try:
                    hr = float(input("\n1. Heart Rate (bpm) [Normal: 60-100]: "))
                    if 40 <= hr <= 200:
                        break
                    print("   ⚠ Please enter a valid heart rate (40-200 bpm)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            # SpO2
            while True:
                try:
                    spo2 = float(input("2. SpO₂ (%) [Normal: 95-100]: "))
                    if 70 <= spo2 <= 100:
                        break
                    print("   ⚠ Please enter a valid SpO₂ (70-100%)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            # Body Temperature
            while True:
                try:
                    temp = float(input("3. Body Temperature (°C) [Normal: 36.5-37.5]: "))
                    if 35 <= temp <= 42:
                        break
                    print("   ⚠ Please enter a valid temperature (35-42°C)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            # Blood Pressure
            while True:
                try:
                    systolic = float(input("4. Systolic Blood Pressure (mmHg) [Normal: 90-120]: "))
                    if 70 <= systolic <= 200:
                        break
                    print("   ⚠ Please enter a valid systolic BP (70-200 mmHg)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            while True:
                try:
                    diastolic = float(input("5. Diastolic Blood Pressure (mmHg) [Normal: 60-80]: "))
                    if 40 <= diastolic <= 130:
                        break
                    print("   ⚠ Please enter a valid diastolic BP (40-130 mmHg)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            # Sleep Hours
            while True:
                try:
                    sleep = float(input("6. Sleep Hours (last night) [Recommended: 7-9]: "))
                    if 0 <= sleep <= 24:
                        break
                    print("   ⚠ Please enter valid sleep hours (0-24)")
                except ValueError:
                    print("   ⚠ Please enter a valid number")
            
            # Store data
            self.health_data = {
                'Heart_Rate_bpm': hr,
                'SpO2_percent': spo2,
                'Body_Temp_C': temp,
                'Systolic_BP_mmHg': systolic,
                'Diastolic_BP_mmHg': diastolic,
                'Sleep_Hours': sleep,
                'Blink_Rate_per_min': self.blink_rate,
                'Facial_Stress_Score': self.facial_stress_score
            }
            
            print("\n" + "="*70)
            print("DATA COLLECTED SUCCESSFULLY")
            print("="*70)
            
            input("\nPress Enter to analyze stress level...")
            return True
            
        except Exception as e:
            print(f"\n✗ Error collecting data: {e}")
            return False
    
    def predict_stress(self):
        """Predict stress level using trained model"""
        self.clear_screen()
        self.print_header("STRESS LEVEL ANALYSIS")
        
        print("Analyzing your data using AI model...")
        print("\nYour Input Data:")
        print("-"*70)
        for key, value in self.health_data.items():
            print(f"  {key:25s}: {value:.2f}")
        print("-"*70)
        
        if self.model is None:
            print("\n⚠ Model not loaded. Using rule-based prediction...")
            stress_level, stress_code = self.rule_based_prediction()
        else:
            # Prepare data for model
            feature_order = [
                'Heart_Rate_bpm', 'SpO2_percent', 'Body_Temp_C',
                'Systolic_BP_mmHg', 'Diastolic_BP_mmHg', 'Sleep_Hours',
                'Blink_Rate_per_min', 'Facial_Stress_Score'
            ]
            
            X = np.array([[self.health_data[f] for f in feature_order]])
            
            try:
                prediction = self.model.predict(X)[0]
                stress_code = int(prediction)
                stress_levels = {0: 'Low', 1: 'Medium', 2: 'High'}
                stress_level = stress_levels.get(stress_code, 'Medium')
            except Exception as e:
                print(f"\n⚠ Model prediction error: {e}")
                stress_level, stress_code = self.rule_based_prediction()
        
        self.display_results(stress_level, stress_code)
        
        return True
    
    def rule_based_prediction(self):
        """Fallback rule-based stress prediction"""
        stress_score = 0
        
        # Heart Rate (high = stress)
        hr = self.health_data['Heart_Rate_bpm']
        if hr > 100:
            stress_score += 2
        elif hr > 85:
            stress_score += 1
        
        # SpO2 (low = stress)
        spo2 = self.health_data['SpO2_percent']
        if spo2 < 95:
            stress_score += 2
        elif spo2 < 97:
            stress_score += 1
        
        # Blood Pressure (high = stress)
        systolic = self.health_data['Systolic_BP_mmHg']
        if systolic > 140:
            stress_score += 2
        elif systolic > 120:
            stress_score += 1
        
        # Sleep (low = stress)
        sleep = self.health_data['Sleep_Hours']
        if sleep < 5:
            stress_score += 2
        elif sleep < 7:
            stress_score += 1
        
        # Blink Rate (high = stress)
        blink = self.health_data['Blink_Rate_per_min']
        if blink > 30:
            stress_score += 2
        elif blink > 20:
            stress_score += 1
        
        # Facial Stress Score
        facial = self.health_data['Facial_Stress_Score']
        if facial > 0.6:
            stress_score += 2
        elif facial > 0.4:
            stress_score += 1
        
        # Determine level
        if stress_score >= 8:
            return 'High', 2
        elif stress_score >= 4:
            return 'Medium', 1
        else:
            return 'Low', 0
    
    def display_results(self, stress_level, stress_code):
        """Display stress results and recommendations"""
        print("\n" + "="*70)
        print("STRESS DETECTION RESULTS")
        print("="*70)
        
        # Color coding
        colors = {
            'Low': '🟢',
            'Medium': '🟡',
            'High': '🔴'
        }
        
        print(f"\n{colors.get(stress_level, '⚪')} STRESS LEVEL: {stress_level.upper()}")
        print(f"   Stress Code: {stress_code}")
        
        print("\n" + "-"*70)
        print("RECOMMENDATIONS:")
        print("-"*70)
        
        if stress_level == 'Low':
            print("\n✓ Your stress level is LOW - Great!")
            print("\nRecommendations:")
            print("  • Maintain your current healthy lifestyle")
            print("  • Continue regular exercise and good sleep habits")
            print("  • Practice mindfulness to stay balanced")
            print("  • Stay hydrated and eat nutritious meals")
            
        elif stress_level == 'Medium':
            print("\n⚠ Your stress level is MEDIUM - Take action")
            print("\nRecommendations:")
            print("  • Take short breaks every hour")
            print("  • Practice deep breathing exercises (5 min)")
            print("  • Ensure 7-8 hours of sleep tonight")
            print("  • Reduce caffeine intake")
            print("  • Go for a 15-minute walk")
            print("  • Talk to someone you trust")
            
        else:  # High
            print("\n⚠ Your stress level is HIGH - Immediate action needed")
            print("\nRecommendations:")
            print("  • STOP current activity and take a break")
            print("  • Practice deep breathing for 10 minutes")
            print("  • Drink water and have a healthy snack")
            print("  • Consider talking to a healthcare professional")
            print("  • Avoid caffeine and alcohol")
            print("  • Try meditation or yoga")
            print("  • Ensure adequate rest tonight (8+ hours)")
            print("  • If symptoms persist, consult a doctor")
        
        print("\n" + "="*70)
        
        # Save results
        self.save_results(stress_level, stress_code)
    
    def save_results(self, stress_level, stress_code):
        """Save results to file"""
        try:
            results = {
                'Timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'User': self.user_name,
                'Stress_Level': stress_level,
                'Stress_Code': stress_code,
                **self.health_data
            }
            
            df = pd.DataFrame([results])
            
            results_file = 'results/stress_detection_results.csv'
            os.makedirs('results', exist_ok=True)
            
            if os.path.exists(results_file):
                df.to_csv(results_file, mode='a', header=False, index=False)
            else:
                df.to_csv(results_file, index=False)
            
            print(f"\n✓ Results saved to: {results_file}")
            
        except Exception as e:
            print(f"\n⚠ Could not save results: {e}")
    
    def run(self):
        """Main application flow"""
        try:
            # Step 1: User Login
            if not self.user_login():
                return
            
            # Step 2: Webcam Analysis
            if not self.webcam_analysis():
                print("\n✗ Webcam analysis failed. Exiting...")
                return
            
            # Step 3: User Input Form
            if not self.user_input_form():
                print("\n✗ Data collection failed. Exiting...")
                return
            
            # Step 4: Predict Stress
            self.predict_stress()
            
            # Ask to continue
            print("\n" + "="*70)
            choice = input("\nWould you like to analyze another user? (y/n): ").strip().lower()
            
            if choice == 'y':
                self.run()
            else:
                print("\n" + "="*70)
                print("Thank you for using the Stress Detection System!")
                print("Stay healthy and manage your stress! 💚")
                print("="*70 + "\n")
        
        except KeyboardInterrupt:
            print("\n\n✗ Program interrupted by user")
        except Exception as e:
            print(f"\n✗ Unexpected error: {e}")
        finally:
            cv2.destroyAllWindows()


if __name__ == "__main__":
    print("\n")
    print("=" + "="*68 + "=")
    print(" "*15 + "PROFESSIONAL STRESS DETECTION SYSTEM" + " "*17)
    print("=" + "="*68 + "=")
    
    system = StressDetectionSystem()
    system.run()
