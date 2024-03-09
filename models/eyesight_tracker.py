import cv2
import dlib

class EyesightTracker:
    def __init__(self, shape_predictor_path='shape_predictor_68_face_landmarks.dat'):
        self.detector = dlib.get_frontal_face_detector()
        self.predictor = dlib.shape_predictor(shape_predictor_path)

    def track(self, frame):
        # Convert the frame to grayscale
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Detect faces in the frame
        faces = self.detector(gray_frame)

        for face in faces:
            # Predict facial landmarks
            landmarks = self.predictor(gray_frame, face)

            # Extract left and right eye landmarks
            left_eye_landmarks = [(landmarks.part(i).x, landmarks.part(i).y) for i in range(36, 42)]
            right_eye_landmarks = [(landmarks.part(i).x, landmarks.part(i).y) for i in range(42, 48)]

            # Calculate eye center
            left_eye_center = (sum([x for x, y in left_eye_landmarks]) // 6, sum([y for x, y in left_eye_landmarks]) // 6)
            right_eye_center = (sum([x for x, y in right_eye_landmarks]) // 6, sum([y for x, y in right_eye_landmarks]) // 6)

            # Draw circles around the eye centers
            cv2.circle(frame, left_eye_center, 2, (0, 255, 0), -1)
            cv2.circle(frame, right_eye_center, 2, (0, 255, 0), -1)

            # Calculate angle based on eye centers
            angle = self.calculate_angle(left_eye_center, right_eye_center)
            if -360 < angle < 0 or angle == -0.0 :
                return 0
            else:
                return 1

        # Display the frame with eye detection


    @staticmethod
    def calculate_angle(left_eye_center, right_eye_center):
        dx = right_eye_center[0] - left_eye_center[0]
        dy = right_eye_center[1] - left_eye_center[1]
        return -cv2.fastAtan2(dy, dx)

#
eyesight_tracker = EyesightTracker()
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()


    if not ret:
        break
    cv2.imshow("video",frame)
    result = eyesight_tracker.track(frame)
    print(result)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()