import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, accuracy_score
import joblib

class HRVStressModel:
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        
    def load_data(self, train_path, test_path):
        """Load SWELL HRV dataset"""
        train_df = pd.read_csv(train_path)
        test_df = pd.read_csv(test_path)
        return train_df, test_df
    
    def prepare_features(self, df):
        """Prepare features from HRV data"""
        # Select relevant HRV features
        feature_cols = ['MEAN_RR', 'HR', 'RMSSD', 'SDSD', 'pNN50', 
                       'SD1', 'SD2', 'LF', 'HF', 'LF_HF']
        
        X = df[feature_cols].values
        y = (df['condition'] != 'no stress').astype(int).values
        
        return X, y, feature_cols
    
    def train(self, train_path, test_path):
        """Train the stress detection model"""
        print("Loading data...")
        train_df, test_df = self.load_data(train_path, test_path)
        
        print("Preparing features...")
        X_train, y_train, feature_cols = self.prepare_features(train_df)
        X_test, y_test, _ = self.prepare_features(test_df)
        
        print(f"Training samples: {len(X_train)}, Test samples: {len(X_test)}")
        
        # Scale features
        X_train_scaled = self.scaler.fit_transform(X_train)
        X_test_scaled = self.scaler.transform(X_test)
        
        # Train Random Forest
        print("Training model...")
        self.model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.model.fit(X_train_scaled, y_train)
        
        # Evaluate
        y_pred = self.model.predict(X_test_scaled)
        accuracy = accuracy_score(y_test, y_pred)
        
        print(f"\nModel Accuracy: {accuracy:.4f}")
        print("\nClassification Report:")
        print(classification_report(y_test, y_pred, target_names=['No Stress', 'Stress']))
        
        return accuracy
    
    def predict_stress(self, hrv_features):
        """Predict stress from HRV features"""
        features_scaled = self.scaler.transform([hrv_features])
        stress_prob = self.model.predict_proba(features_scaled)[0][1]
        return stress_prob
    
    def save_model(self, model_path='models/hrv_stress_model.pkl'):
        """Save trained model"""
        joblib.dump({'model': self.model, 'scaler': self.scaler}, model_path)
        print(f"Model saved to {model_path}")
    
    def load_model(self, model_path='models/hrv_stress_model.pkl'):
        """Load trained model"""
        data = joblib.load(model_path)
        self.model = data['model']
        self.scaler = data['scaler']
        print(f"Model loaded from {model_path}")

if __name__ == "__main__":
    # Train the model
    hrv_model = HRVStressModel()
    hrv_model.train('data/train.csv', 'data/test.csv')
    hrv_model.save_model()
