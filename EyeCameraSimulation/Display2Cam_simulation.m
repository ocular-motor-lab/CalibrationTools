function camEyeDispDotsPix = Display2Cam_simulation(inputDot, primaryPosition, camPosition, eyeGlobePosition, eyeRadius)

% create vectors from eye to the dot with eye radius length
% vectors point to the center of the pupil when looking at the points in
% the display
normDispDots = inputDot ./ sqrt(sum(inputDot.^2,2));
eyeDispDots = normDispDots;

% assuming the camera is outside of the display plane
% camera location relative to eye - cm
% example: camX = 45; camY = 0; camZ = -20; camPosition = [camX,camY,camZ];

% quaternion between x axis from the eye toward display (primary position; for example: [distanceDispEye,0,0])
% and new x' toward camera (reference position)
q = CalculateQuaternion(primaryPosition, camPosition);
camEyeDispDots = rotateframe(q,eyeDispDots);

% projecting the unitary globe into the camera to get the points in pixels 
% in image coordinates

camEyeDispDotsPix(:,1) = camEyeDispDots(:,2)*eyeRadius + eyeGlobePosition(1);
camEyeDispDotsPix(:,2) = camEyeDispDots(:,3)*eyeRadius + eyeGlobePosition(2);

end
