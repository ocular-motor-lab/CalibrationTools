function torsion = SimulateOpenIrisTorsionCalculation(camEyeImagePoints, eyeModelCenterPx, eyeModelRadiusPx)
% Simulating open iris torsion measurment from camera image  
%inputs: 
% camEyeImagePoints is nx2 matrix, output of the
%SimulatedEyePositions_CamCoordinates function
% eyeModelCenterPx 
x = camEyeImagePoints(:,1) - eyeModelCenterPx(1);
y = camEyeImagePoints(:,2) - eyeModelCenterPx(2);

angle_allPoints = atan2(y, x);

% Then, get the eccentricity from the length of the vector in pixels to 
% the angle that moves the eye that far
ecc_allPoints = asin(sqrt(y .* y + x .* x) / eyeModelRadiusPx);
z = cos(ecc_allPoints)*eyeModelRadiusPx;
     
angle = angle_allPoints(1);
ecc = -ecc_allPoints(1); % IMPORTANT THIS IS THE OPOSITE AS OPEN IRIS (MINUS SIGN) 
% because here we are rotating from eye to camera. 
% Open iris rotates from camera to eye to calculate the mappings.
% the image warp uses the mapping to "rotate" or unwarp from eye
% coordinates to camera coordinates (eye looking straight ahead to the
% camera)
q1 = cos(ecc/2);
q2 = -sin(angle) * sin(ecc/2);
q3 = cos(angle) * sin(ecc/2);
q4 = 0;

q = quaternion(q1,q2,q3,q4);

% Rotation in with an axis in plane of the camera that rotates the pupil
% center to the current gaze direction. (no torsion rotation in camera
% reference frame)
camEyeImagePoints3D = [x,y,z];
camEyeImagePointsRotated = rotatepoint(q,camEyeImagePoints3D);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate torsion with 4 points % LEFT RIGHT UP DOWN
t1 = 90-atan2d(camEyeImagePointsRotated(2,2),camEyeImagePointsRotated(2,1));
t2 = -atan2d(camEyeImagePointsRotated(3,2),camEyeImagePointsRotated(3,1))-90;
t3 = -atan2d(camEyeImagePointsRotated(4,2),camEyeImagePointsRotated(4,1));
t4 = 180-atan2d(camEyeImagePointsRotated(5,2),camEyeImagePointsRotated(5,1));

torsion = mean([t1,t2,t3,t4]);

end