import cv2
import mediapipe as mp
import numpy as np
from scipy.spatial import distance

class FacialLandmarkDetector:
    def __init__(self):
        self.mp_face_mesh = mp.solutions.face_mesh
        self.face_mesh = self.mp_face_mesh.FaceMesh(
            max_num_faces=1,
            refine_landmarks=True,
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )
        
        # Eye landmark indices for MediaPipe
        self.LEFT_EYE = [362, 385, 387, 263, 373, 380]
        self.RIGHT_EYE = [33, 160, 158, 133, 153, 144]
        
        self.blink_counter = 0
        self.total_blinks = 0
        self.EAR_THRESHOLD = 0.25
        
    def calculate_ear(self, eye_landmarks):
        """Calculate Eye Aspect Ratio"""
        # Vertical distances
        A = distance.euclidean(eye_landmarks[1], eye_landmarks[5])
        B = distance.euclidean(eye_landmarks[2], eye_landmarks[4])
        
        # Horizontal distance
        C = distance.euclidean(eye_landmarks[0], eye_landmarks[3])
        
        ear = (A + B) / (2.0 * C)
        return ear
    
    def get_eye_landmarks(self, landmarks, eye_indices, frame_shape):
        """Extract eye landmarks"""
        h, w = frame_shape[:2]
        eye_points = []
        
        for idx in eye_indices:
            landmark = landmarks[idx]
            x = int(landmark.x * w)
            y = int(landmark.y * h)
            eye_points.append((x, y))
        
        return np.array(eye_points)
    
    def detect_blink(self, frame):
        """Detect eye blinks and calculate EAR"""
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.face_mesh.process(rgb_frame)
        
        ear_left = 0
        ear_right = 0
        avg_ear = 0
        
        if results.multi_face_landmarks:
            face_landmarks = results.multi_face_landmarks[0]
            
            # Get eye landmarks
            left_eye = self.get_eye_landmarks(
                face_landmarks.landmark, self.LEFT_EYE, frame.shape
            )
            right_eye = self.get_eye_landmarks(
                face_landmarks.landmark, self.RIGHT_EYE, frame.shape
            )
            
            # Calculate EAR
            ear_left = self.calculate_ear(left_eye)
            ear_right = self.calculate_ear(right_eye)
            avg_ear = (ear_left + ear_right) / 2.0
            
            # Detect blink
            if avg_ear < self.EAR_THRESHOLD:
                self.blink_counter += 1
            else:
                if self.blink_counter >= 2:
                    self.total_blinks += 1
                self.blink_counter = 0
            
            # Draw eye contours
            cv2.polylines(frame, [left_eye], True, (0, 255, 0), 1)
            cv2.polylines(frame, [right_eye], True, (0, 255, 0), 1)
        
        return avg_ear, self.total_blinks, frame
    
    def get_facial_landmarks(self, frame):
        """Get all facial landmarks"""
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.face_mesh.process(rgb_frame)
        
        landmarks = []
        if results.multi_face_landmarks:
            face_landmarks = results.multi_face_landmarks[0]
            h, w = frame.shape[:2]
            
            for landmark in face_landmarks.landmark:
                x = int(landmark.x * w)
                y = int(landmark.y * h)
                landmarks.append((x, y))
        
        return landmarks
    
    def reset_blink_counter(self):
        """Reset blink counter"""
        self.total_blinks = 0
        self.blink_counter = 0
