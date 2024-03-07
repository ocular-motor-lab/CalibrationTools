function [qCamRefToEyeCoordinates, qEyePosInRef2Camera, qCamera2Eye] = CalculateEyeRotationQuaternion( eyeDataH, eyeDataV, eyeDataT, eyeCalibrationModelCenter, eyeCalibrationModelRad, camAlpha, camBeta, cam_x )
% combining three quaternions:
% 1- reference position to measure torsion
% 2- referecen position with torsion to gaze direction in camera image
% 3- from camera coordinates to global eye coordinates
%inputs:
% eyeDataH is the horizontal position of the center of pupil from the camera image
% eyeDataV is the vertical position of the center of pupil from the camera image
% torsion is the calculated torsion in the camera image
%% 1- reference position to measure torsion
pupilCenter = [eyeDataH eyeDataV];
  
x = pupilCenter(1) - eyeCalibrationModelCenter(1);
y = pupilCenter(2) - eyeCalibrationModelCenter(2);

angle = atan2(y, x);
ecc = -( asin( sqrt(y .* y + x .* x)  / eyeCalibrationModelRad) );
      
q1 = cos(ecc/2);
q2 = -sin(angle) * sin(ecc/2);
q3 = cos(angle) * sin(ecc/2);
q4 = 0;

q = quaternion(q1,q2,q3,q4);
%% 2- referecen position with torsion to gaze direction in camera image
% quaterion for just the torsional component. With the eye rotating around an
% axis perpendicular to the camera
torsion = eyeDataT;
ecc = deg2rad(torsion); 
q1 = cos(ecc/2);
q2 = 0;
q3 = 0;
q4 = 1* sin(ecc/2);
qt = quaternion(q1,q2,q3,q4);

% full rotation is q and qt in sequence still in camera reference frame
qEyePosInCamera2Ref = qt*q;
qEyePosInRef2Camera = quatinv(qEyePosInCamera2Ref);
% Last step is to calculate the full quaternion from camera reference position to
% global coordinates where the center of the coordinates is at center of
% eye globe
%% from camera coordinates to global eye coordinates
% calculate the quaternion to rotate eye positions from camera coordinates 
% to global eye coordinates  
% cam location in eye coordinates
cam_yz = tand(camAlpha)*cam_x;
cam_z = cosd(camBeta)*cam_yz;
cam_y = sind(camBeta)*cam_yz;

camPosition = [cam_x, cam_y, cam_z];

% camera x axis positive direction will be camPosition 
% to the zero position of eye-coordinates
norm_xcamcor = -camPosition./sqrt(sum(camPosition.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor and norm_xeyecor
angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );

% axis of rotation
rotAxis = cross(norm_xeyecor,norm_xcamcor);

w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qEye2Camera = quaternion(q1,q2,q3,q4);
qCamera2Eye = quatinv(qEye2Camera);
%% Combining all three
qCamRefToEyeCoordinates = qCamera2Eye*qEyePosInRef2Camera;
end