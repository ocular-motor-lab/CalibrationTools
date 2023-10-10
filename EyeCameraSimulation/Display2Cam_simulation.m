function camEyeDispDots = Display2Cam_simulation(inputDot, primaryPosition, camPosition, eyeRadius)

% create vectors from eye to the dot with eye radius length
normDispDots = inputDot ./ sqrt(sum(inputDot.^2,2));
eyeDispDots = normDispDots * eyeRadius;

% assuming the camera is outside of the display plane
% camera location relative to eye - cm
% example: camX = 45; camY = 0; camZ = -20; camPosition = [camX,camY,camZ];

% quaternion between x axis from the eye toward display (primary position; for example: [distanceDispEye,0,0])
% and new x' toward camera (reference position)
q = CalculateQuaternion(primaryPosition, camPosition);
camEyeDispDots = rotateframe(q,eyeDispDots);

end
