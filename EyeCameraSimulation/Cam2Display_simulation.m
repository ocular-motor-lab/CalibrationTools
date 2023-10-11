function eyeDispDots = Cam2Display_simulation(inputPosition, referenceOrientation, camearOrientation, eyeRadiusPixel )

q = CalculateQuaternion(camearOrientation, referenceOrientation);
camEyeDispDots(:,2:3) = inputPosition(:,1:2);
camEyeDispDots(:,1) = real(sqrt(eyeRadiusPixel^2 - camEyeDispDots(:,2).^2 - camEyeDispDots(:,3).^2 ));
eyeDispDots = rotateframe(q,camEyeDispDots);

end