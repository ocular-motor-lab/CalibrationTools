function eyeDispDots_ = Cam2Display_simulation(inputPosition, referenceOrientation, camAlpha, camBeta, eyeGlobePositionPix, eyeRadiusPixel )

camAlphaRad = deg2rad(camAlpha);
camBetaRad = deg2rad(camBeta);
camX = cos(camAlphaRad);
camY = sin(camAlphaRad) * sin(camBetaRad);
camZ = sin(camAlphaRad) * cos(camBetaRad); 
cameraOrientation = [camX,camY,camZ];

q = CalculateQuaternion(cameraOrientation, referenceOrientation);
camEyeDispDots(:,2) = inputPosition(:,1) - eyeGlobePositionPix(1);
camEyeDispDots(:,3) = -(inputPosition(:,2) - eyeGlobePositionPix(2));

camEyeDispDots(:,1) = real(sqrt(eyeRadiusPixel^2 - camEyeDispDots(:,2).^2 - camEyeDispDots(:,3).^2 ));
eyeDispDots = rotateframe(q,camEyeDispDots);

eyeDispDots_(:,1) = eyeDispDots(:,2) + eyeGlobePositionPix(1);
eyeDispDots_(:,2) = -eyeDispDots(:,3) + eyeGlobePositionPix(2);

end