function eyeDispDots = Cam2Display_simulation(inputPosition, primaryPosition, camPosition, eyeRadius )

q = CalculateQuaternion(camPosition, primaryPosition);
camEyeDispDots(:,2:3) = inputPosition(:,1:2);
camEyeDispDots(:,1) = sqrt(eyeRadius^2 - camEyeDispDots(:,2).^2 - camEyeDispDots(:,3).^2 );
eyeDispDots = rotateframe(q,camEyeDispDots);

end