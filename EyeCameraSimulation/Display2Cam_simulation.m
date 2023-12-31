function camEyeDispDotsPix = Display2Cam_simulation(inputDot, referenceOrientation, camAlpha, camBeta, eyeGlobePosition, eyeRadius)

% assuming the camera is outside of the display plane
% camera location relative to eye - cm
% camX = 45;
% %camY = 0;
% %camZ = -20;
% camPosition = [camX,camY,camZ]; % eye centered reference frame (head)
% cameraOrientation = camPosition/sqrt(sum(camPosition.^2));

% assuming the camera is outside of the display plane
% finding the camera orientation vector based on elevation camAlpha and azimuth camBeta
% camAlpha and camBeta inputs in degree
camAlphaRad = deg2rad(camAlpha);
camBetaRad = deg2rad(camBeta);
camX = cos(camAlphaRad);
camY = sin(camAlphaRad) * sin(camBetaRad);
camZ = sin(camAlphaRad) * cos(camBetaRad); 
cameraOrientation = [camX,camY,camZ];
% create vectors from eye to the dot with eye radius length
% vectors point to the center of the pupil when looking at the points in
% the display
normDispDots = inputDot ./ sqrt(sum(inputDot.^2,2));
eyeDispDots = normDispDots;

% assuming the camera is outside of the display plane
% camera orientation is a 3D unit vector perpendicular to the camera
% surface  

% reference orientation is a unit vector direction from the reference
% position on the display to the eye

% quaternion between x axis from the eye toward display (primary position; for example: [distanceDispEye,0,0])
% and new x' toward camera (reference position)
q = CalculateQuaternion( referenceOrientation, cameraOrientation);
camEyeDispDots = rotateframe(q,eyeDispDots);

% projecting the unitary globe into the camera to get the points in pixels 
% in image coordinates

camEyeDispDotsPix(:,1) = camEyeDispDots(:,2)*eyeRadius + eyeGlobePosition(1);
camEyeDispDotsPix(:,2) = -camEyeDispDots(:,3)*eyeRadius + eyeGlobePosition(2);

end
