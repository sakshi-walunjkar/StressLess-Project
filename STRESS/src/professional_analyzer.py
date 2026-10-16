"""
Professional Stress Analyzer
- 10-second analysis window
- Statistical aggregation
- Clean terminal UI
- User-controlled analysis
"""

import cv2
import numpy as np
import time
from collections import deque
from facial_detector import FacialLandmarkDetector
import os
import sys

class ProfessionalStressAnalyzer:
    def __init__(self):
        self.facial_detector = FacialLandmarkDetector()
        
        # Load emotion model
        self.emotion_model = None
        self.load_emotion_model()
        
        # Analysis parameters
        self.analysis_duration = 10  # seconds
        self.frame_buffer = deque(maxlen=300)  # Store 10 seconds at 30fps
        
        # Data collectors
        self.emotion_data = []
        self.blink_data = []
        self.ear_data = []
        
        # Emotion labels
        self.emotions = ['angry', 'disgust', 'fear', 'happy', 'sad', 'surprise', 'neutral']
        
        # Stress weights
        self.stress_weights = {
            'angry': 1.0,
            'fear': 0.95,
            'disgust': 0.85,
            'sad': 0.75,
            'surprise': 0.45,
            'neutral': 0.15,
            'happy': 0.05
        }
        
        # Face cascade
        self.face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
        )
    
    def load_emotion_model(self):
        """Load trained emotion model"""
        model_path = 'models/emotion_model_professional.h5'
        
        if os.path.exists(model_path):
            try:
                from tensorflow import keras
                self.emotion_model = keras.models.load_model(model_path)
                print("✓ Professional emotion model loaded")
            except Exception as e:
                print(f"⚠ Could not load model: {e}")
                print("  Using basic detection")
        else:
            print("⚠ Professional model not found")
            print("  Train model first: python train_professional_model.py")
            print("  Using basic detection for now")
    
    def detect_emotion(self, frame):
        """Detect emotion from frame"""
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = self.face_cascade.detectMultiScale(gray, 1.05, 3, minSize=(48, 48))
        
        if len(faces) == 0:
            return None, 0.5
        
        # Get largest face
        (x, y, w, h) = max(faces, key=lambda f: f[2] * f[3])
        
        face_roi = gray[y:y+h, x:x+w]
        
        if self.emotion_model is not None:
            # Use trained model
            face_resized = cv2.resize(face_roi, (48, 48))
            face_normalized = face_resized / 255.0
            face_reshaped = face_normalized.reshape(1, 48, 48, 1)
            
            predictions = self.emotion_model.predict(face_reshaped, verbose=0)[0]
            emotion_idx = np.argmax(predictions)
            emotion = self.emotions[emotion_idx]
            confidence = predictions[emotion_idx]
        else:
            # Use basic detection
            emotion, confidence = self.basic_emotion_detection(face_roi)
        
        stress_score = self.stress_weights.get(emotion, 0.5) * confidence
        
        return emotion, stress_score
    
    def basic_emotion_detection(self, face_roi):
        """Basic emotion detection fallback"""
        mean_val = np.mean(face_roi)
        std_val = np.std(face_roi)
        
        if std_val > 50:
            if mean_val < 100:
                return 'angry', 0.7
            else:
                return 'surprise', 0.6
        elif mean_val < 90:
            return 'sad', 0.6
        else:
            return 'neutral', 0.5
    
    def collect_data(self, cap, duration):
        """
        Collect data for specified duration
        Returns: emotion_list, blink_list, ear_list
        """
        
        print(f"\n{'='*70}")
        print(f"COLLECTING DATA FOR {duration} SECONDS")
        print(f"{'='*70}")
        print("\nPlease:")
        print("  - Stay in front of camera")
        print("  - Maintain natural expression")
        print("  - Look at the camera")
        print(f"\nAnalyzing", end="", flush=True)
        
        emotion_list = []
        blink_list = []
        ear_list = []
        
        start_time = time.time()
        frame_count = 0
        blink_start_count = self.facial_detector.total_blinks
        
        while time.time() - start_time < duration:
            ret, frame = cap.read()
            if not ret:
                break
            
            frame_count += 1
            
            # Show progress
            if frame_count % 30 == 0:
                elapsed = int(time.time() - start_time)
                remaining = duration - elapsed
                print(f".", end="", flush=True)
            
            # Detect emotion
            emotion, emotion_stress = self.detect_emotion(frame)
            if emotion:
                emotion_list.append({
                    'emotion': emotion,
                    'stress': emotion_stress
                })
            
            # Detect blinks and EAR
            avg_ear, total_blinks, _ = self.facial_detector.detect_blink(frame)
            if avg_ear > 0:
                ear_list.append(avg_ear)
            
            # Display frame
            cv2.imshow('Analyzing... (Press Q to stop early)', frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
        
        cv2.destroyAllWindows()
        
        # Calculate blinks during this period
        total_blinks_period = self.facial_detector.total_blinks - blink_start_count
        elapsed_time = time.time() - start_time
        blink_rate = (total_blinks_period / elapsed_time) * 60 if elapsed_time > 0 else 0
        
        print(f" Done!\n")
        print(f"✓ Collected {len(emotion_list)} emotion samples")
        print(f"✓ Collected {len(ear_list)} EAR samples")
        print(f"✓ Detected {total_blinks_period} blinks ({blink_rate:.1f}/min)")
        
        return emotion_list, blink_rate, ear_list
    
    def analyze_data(self, emotion_list, blink_rate, ear_list):
        """
        Analyze collected data using statistical methods
        """
        
        print(f"\n{'='*70}")
        print("STATISTICAL ANALYSIS")
        print(f"{'='*70}\n")
        
        # Emotion analysis
        if len(emotion_list) > 0:
            emotions_detected = [e['emotion'] for e in emotion_list]
            emotion_counts = {}
            for emotion in emotions_detected:
                emotion_counts[emotion] = emotion_counts.get(emotion, 0) + 1
            
            # Get dominant emotion
            dominant_emotion = max(emotion_counts, key=emotion_counts.get)
            emotion_percentage = (emotion_counts[dominant_emotion] / len(emotions_detected)) * 100
            
            # Calculate average emotion stress
            emotion_stress_values = [e['stress'] for e in emotion_list]
            avg_emotion_stress = np.mean(emotion_stress_values)
            std_emotion_stress = np.std(emotion_stress_values)
            
            print("EMOTION ANALYSIS:")
            print(f"  Dominant Emotion: {dominant_emotion.capitalize()} ({emotion_percentage:.1f}% of time)")
            print(f"  Emotion Distribution:")
            for emotion, count in sorted(emotion_counts.items(), key=lambda x: x[1], reverse=True):
                pct = (count / len(emotions_detected)) * 100
                print(f"    - {emotion.capitalize()}: {pct:.1f}%")
            print(f"  Average Emotion Stress: {avg_emotion_stress:.3f} ± {std_emotion_stress:.3f}")
        else:
            dominant_emotion = 'neutral'
            avg_emotion_stress = 0.5
            print("EMOTION ANALYSIS:")
            print("  ⚠ No face detected consistently")
        
        # Blink analysis
        print(f"\nBLINK ANALYSIS:")
        print(f"  Blink Rate: {blink_rate:.1f} blinks/minute")
        baseline_blink = 20
        if blink_rate < 10:
            blink_status = "Very Low (possible fatigue)"
            blink_stress = 0.3
        elif blink_rate < baseline_blink:
            blink_status = "Low (relaxed)"
            blink_stress = 0.1
        elif blink_rate < 30:
            blink_status = "Normal"
            blink_stress = 0.2
        elif blink_rate < 40:
            blink_status = "Elevated (mild stress)"
            blink_stress = 0.6
        else:
            blink_status = "High (significant stress)"
            blink_stress = 0.9
        print(f"  Status: {blink_status}")
        print(f"  Stress Contribution: {blink_stress:.3f}")
        
        # EAR analysis
        if len(ear_list) > 0:
            avg_ear = np.mean(ear_list)
            std_ear = np.std(ear_list)
            min_ear = np.min(ear_list)
            max_ear = np.max(ear_list)
            
            print(f"\nEYE ASPECT RATIO (EAR) ANALYSIS:")
            print(f"  Average EAR: {avg_ear:.3f} ± {std_ear:.3f}")
            print(f"  Range: {min_ear:.3f} - {max_ear:.3f}")
            
            baseline_ear = 0.28
            if avg_ear < 0.20:
                ear_status = "Very Low (fatigue/drowsiness)"
                ear_stress = 0.8
            elif avg_ear < baseline_ear:
                ear_status = "Low (mild fatigue)"
                ear_stress = 0.5
            else:
                ear_status = "Normal (alert)"
                ear_stress = 0.1
            print(f"  Status: {ear_status}")
            print(f"  Stress Contribution: {ear_stress:.3f}")
        else:
            avg_ear = 0.3
            ear_stress = 0.2
            print(f"\nEYE ASPECT RATIO (EAR) ANALYSIS:")
            print("  ⚠ Insufficient data")
        
        # Combined stress calculation
        weights = {
            'emotion': 0.70,
            'blink': 0.20,
            'ear': 0.10
        }
        
        combined_stress = (
            weights['emotion'] * avg_emotion_stress +
            weights['blink'] * blink_stress +
            weights['ear'] * ear_stress
        )
        
        # Determine stress level
        if combined_stress < 0.25:
            stress_level = "LOW"
            stress_color = "GREEN"
            recommendation = "You appear relaxed and calm."
        elif combined_stress < 0.55:
            stress_level = "MEDIUM"
            stress_color = "YELLOW"
            recommendation = "Moderate stress detected. Consider taking a short break."
        else:
            stress_level = "HIGH"
            stress_color = "RED"
            recommendation = "High stress detected. Please take a break and practice relaxation."
        
        print(f"\n{'='*70}")
        print("FINAL STRESS ASSESSMENT")
        print(f"{'='*70}\n")
        print(f"  Combined Stress Score: {combined_stress:.3f}")
        print(f"  Stress Level: {stress_level} ({stress_color})")
        print(f"\n  Breakdown:")
        print(f"    - Emotion (70%): {avg_emotion_stress:.3f}")
        print(f"    - Blink Rate (20%): {blink_stress:.3f}")
        print(f"    - Eye Fatigue (10%): {ear_stress:.3f}")
        print(f"\n  Recommendation: {recommendation}")
        print(f"\n{'='*70}\n")
        
        return {
            'stress_score': combined_stress,
            'stress_level': stress_level,
            'dominant_emotion': dominant_emotion,
            'emotion_stress': avg_emotion_stress,
            'blink_rate': blink_rate,
            'blink_stress': blink_stress,
            'avg_ear': avg_ear if len(ear_list) > 0 else 0,
            'ear_stress': ear_stress
        }
    
    def run_interactive(self):
        """
        Run interactive stress analysis session
        """
        
        print("\n" + "="*70)
        print(" "*15 + "PROFESSIONAL STRESS ANALYZER")
        print("="*70)
        print("\nFeatures:")
        print("  ✓ 10-second analysis window")
        print("  ✓ Statistical aggregation")
        print("  ✓ Emotion detection")
        print("  ✓ Blink rate monitoring")
        print("  ✓ Eye fatigue detection")
        print("  ✓ Comprehensive stress assessment")
        print("="*70)
        
        # Open camera
        print("\nInitializing camera...")
        cap = cv2.VideoCapture(0)
        
        if not cap.isOpened():
            print("✗ Error: Could not open camera")
            return
        
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        
        print("✓ Camera initialized")
        
        try:
            while True:
                print("\n" + "="*70)
                print("MAIN MENU")
                print("="*70)
                print("\n1. Start Analysis (10 seconds)")
                print("2. Quick Analysis (5 seconds)")
                print("3. Extended Analysis (20 seconds)")
                print("4. Exit")
                print("\nEnter your choice: ", end="")
                
                choice = input().strip()
                
                if choice == '1':
                    duration = 10
                elif choice == '2':
                    duration = 5
                elif choice == '3':
                    duration = 20
                elif choice == '4':
                    print("\nExiting... Goodbye!")
                    break
                else:
                    print("\n✗ Invalid choice. Please try again.")
                    continue
                
                # Reset blink counter
                self.facial_detector.reset_blink_counter()
                
                # Collect data
                emotion_list, blink_rate, ear_list = self.collect_data(cap, duration)
                
                # Analyze data
                results = self.analyze_data(emotion_list, blink_rate, ear_list)
                
                # Ask for next action
                print("\nWhat would you like to do?")
                print("1. Analyze again")
                print("2. Return to main menu")
                print("3. Exit")
                print("\nEnter your choice: ", end="")
                
                next_choice = input().strip()
                
                if next_choice == '3':
                    print("\nExiting... Goodbye!")
                    break
                elif next_choice == '1':
                    continue
                else:
                    continue
        
        except KeyboardInterrupt:
            print("\n\nInterrupted by user")
        except Exception as e:
            print(f"\n✗ Error: {e}")
        finally:
            cap.release()
            cv2.destroyAllWindows()
            print("\nCamera released. Session ended.")


if __name__ == "__main__":
    analyzer = ProfessionalStressAnalyzer()
    analyzer.run_interactive()
