"""
Train Stress Detection Model using WESAD Dataset
Features: HR, SpO2, Body Temp, BP, Sleep, Blink Rate, Facial Stress
Target: Stress Level (Low=0, Medium=1, High=2)
"""

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import joblib
import os

class StressModelTrainer:
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        self.feature_names = [
            'Heart_Rate_bpm',
            'SpO2_percent',
            'Body_Temp_C',
            'Systolic_BP_mmHg',
            'Diastolic_BP_mmHg',
            'Sleep_Hours',
            'Blink_Rate_per_min',
            'Facial_Stress_Score'
        ]
    
    def load_data(self):
        """Load WESAD dataset"""
        print("="*70)
        print("Loading WESAD Dataset")
        print("="*70)
        
        try:
            df = pd.read_excel('data/WESAD_Stress_Dataset_Final.xlsx')
            print(f"\n✓ Dataset loaded successfully")
            print(f"  Total records: {len(df)}")
            print(f"  Features: {len(self.feature_names)}")
            
            return df
        
        except Exception as e:
            print(f"\n✗ Error loading dataset: {e}")
            return None
    
    def prepare_data(self, df):
        """Prepare features and target"""
        print("\n" + "="*70)
        print("Preparing Data")
        print("="*70)
        
        # Select features
        X = df[self.feature_names].values
        
        # Target: Stress_Code (0=Low, 1=Medium, 2=High)
        y = df['Stress_Code'].values
        
        print(f"\n✓ Features shape: {X.shape}")
        print(f"✓ Target shape: {y.shape}")
        
        # Check class distribution
        unique, counts = np.unique(y, return_counts=True)
        print(f"\n  Class Distribution:")
        stress_labels = {0: 'Low', 1: 'Medium', 2: 'High'}
        for label, count in zip(unique, counts):
            print(f"    {stress_labels[label]:8s} ({label}): {count:5d} samples ({count/len(y)*100:.1f}%)")
        
        return X, y
    
    def train_model(self, X_train, y_train):
        """Train Random Forest model"""
        print("\n" + "="*70)
        print("Training Model")
        print("="*70)
        
        print("\nModel: Random Forest Classifier")
        print("Parameters:")
        print("  - n_estimators: 200")
        print("  - max_depth: 15")
        print("  - min_samples_split: 5")
        print("  - min_samples_leaf: 2")
        print("  - class_weight: balanced")
        
        self.model = RandomForestClassifier(
            n_estimators=200,
            max_depth=15,
            min_samples_split=5,
            min_samples_leaf=2,
            class_weight='balanced',
            random_state=42,
            n_jobs=-1
        )
        
        print("\nTraining in progress...")
        self.model.fit(X_train, y_train)
        print("✓ Training complete!")
        
        return self.model
    
    def evaluate_model(self, X_test, y_test):
        """Evaluate model performance"""
        print("\n" + "="*70)
        print("Model Evaluation")
        print("="*70)
        
        # Predictions
        y_pred = self.model.predict(X_test)
        
        # Accuracy
        accuracy = accuracy_score(y_test, y_pred)
        print(f"\n✓ Accuracy: {accuracy*100:.2f}%")
        
        # Classification Report
        print("\n" + "-"*70)
        print("Classification Report:")
        print("-"*70)
        target_names = ['Low (0)', 'Medium (1)', 'High (2)']
        print(classification_report(y_test, y_pred, target_names=target_names))
        
        # Confusion Matrix
        print("-"*70)
        print("Confusion Matrix:")
        print("-"*70)
        cm = confusion_matrix(y_test, y_pred)
        print("\n           Predicted")
        print("           Low  Med  High")
        print("Actual Low  ", cm[0])
        print("       Med  ", cm[1])
        print("       High ", cm[2])
        
        # Feature Importance
        print("\n" + "-"*70)
        print("Feature Importance:")
        print("-"*70)
        importances = self.model.feature_importances_
        indices = np.argsort(importances)[::-1]
        
        for i, idx in enumerate(indices, 1):
            print(f"  {i}. {self.feature_names[idx]:25s}: {importances[idx]:.4f}")
        
        return accuracy
    
    def save_model(self):
        """Save trained model"""
        print("\n" + "="*70)
        print("Saving Model")
        print("="*70)
        
        os.makedirs('models', exist_ok=True)
        
        model_path = 'models/stress_model.pkl'
        scaler_path = 'models/scaler.pkl'
        
        joblib.dump(self.model, model_path)
        joblib.dump(self.scaler, scaler_path)
        
        print(f"\n✓ Model saved to: {model_path}")
        print(f"✓ Scaler saved to: {scaler_path}")
    
    def run(self):
        """Main training pipeline"""
        print("\n")
        print("=" + "="*68 + "=")
        print(" "*15 + "STRESS DETECTION MODEL TRAINER" + " "*23)
        print("=" + "="*68 + "=")
        print()
        
        # Load data
        df = self.load_data()
        if df is None:
            return
        
        # Prepare data
        X, y = self.prepare_data(df)
        
        # Split data
        print("\n" + "="*70)
        print("Splitting Data")
        print("="*70)
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        print(f"\n✓ Training set: {len(X_train)} samples")
        print(f"✓ Test set: {len(X_test)} samples")
        
        # Scale features
        print("\n" + "="*70)
        print("Scaling Features")
        print("="*70)
        X_train = self.scaler.fit_transform(X_train)
        X_test = self.scaler.transform(X_test)
        print("\n✓ Features scaled using StandardScaler")
        
        # Train model
        self.train_model(X_train, y_train)
        
        # Evaluate model
        accuracy = self.evaluate_model(X_test, y_test)
        
        # Save model
        self.save_model()
        
        # Final summary
        print("\n" + "="*70)
        print("TRAINING COMPLETE")
        print("="*70)
        print(f"\n✓ Model Accuracy: {accuracy*100:.2f}%")
        print(f"✓ Model Type: Random Forest")
        print(f"✓ Features: {len(self.feature_names)}")
        print(f"✓ Classes: 3 (Low, Medium, High)")
        
        print("\n" + "="*70)
        print("NEXT STEPS:")
        print("="*70)
        print("\n1. Run the stress detection app:")
        print("   python stress_detection_app.py")
        print("\n2. The app will:")
        print("   - Capture facial data via webcam")
        print("   - Collect health parameters")
        print("   - Predict stress level using this trained model")
        print("\n" + "="*70 + "\n")


if __name__ == "__main__":
    trainer = StressModelTrainer()
    trainer.run()
