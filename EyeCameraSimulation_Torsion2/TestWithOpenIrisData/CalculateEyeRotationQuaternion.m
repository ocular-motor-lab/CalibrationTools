function qCamRefToEyeCoordinates = CalculateEyeRotationQuaternion(eyeDataH, eyeDataV, eyeDataT, eyeCalibrationModelCenter, eyeCalibrationModelRad, camAlpha, camBeta, cam_x )
% combining three quaternions:
% 1- reference position to measure torsion
% 2- referecen position with torsion to gaze direction in camera image
% 3- from camera coordinates to global eye coordinates
%inputs:
% eyeDataH is the horizontal position of the center of pupil from the camera image
% eyeDataV is the vertical position of the center of pupil from the camera image
% torsion is the calculated torsion in the camera image

%% 1 and 2
pupilCenter = [eyeDataH eyeDataV];
  
y = pupilCenter(1) - eyeCalibrationModelCenter(1);
z = ( pupilCenter(2) - eyeCalibrationModelCenter(2) );

%if the gaze position is outside of the eye model returns nan
if sqrt(z .* z + y .* y) > eyeCalibrationModelRad, qCamRefToEyeCoordinates = quaternion(nan,nan,nan,nan); return;end

% 1. quaterion for the torsional component, eye rotating around an axis 
% perpendicular to the camera, [1,0,0].
torsion = eyeDataT;
ecc = deg2rad(torsion); 
q1 = cos(ecc/2);
q2 = 1* sin(ecc/2);
q3 = 0;
q4 = 0;
qt = quaternion(q1,q2,q3,q4);

% 2. following the similar approach to openiris method to rotate camera 
% reference axis [1,0,0] to the gaze direction ignoring the torsion
angle = atan2(z, y);
ecc = asin( sqrt(z .* z + y .* y)  / eyeCalibrationModelRad); 

q1 = cos(ecc/2);
q2 = 0;
q3 = -sin(angle)* sin(ecc/2);
q4 = cos(angle) * sin(ecc/2);

q = quaternion(q1,q2,q3,q4);
 
% full rotation from [1,0,0] to the gaze direction with torsion is 
% (first torsion and then rotation toward gaze direction):
qEyePosInRef2Camera = q*qt;

% Last step is to calculate the full quaternion from camera reference position to
% global coordinates where the center of the coordinates is at center of
% eye globe and the x direction is toward the center of the display
%% from camera coordinates to global eye coordinates
% calculate the quaternion to rotate eye positions from camera coordinates 
% to global eye coordinates  
% cam location in eye coordinates
cam_z = tand(camAlpha)*cam_x;
cam_y = tand(camBeta)*cam_x;

camPosition = [cam_x, cam_y, cam_z];

% The camera view axis is from center of the eye globe to the camera, we
% want to rotate this axis to one from center of the eye globe to the
% center of the display
norm_xcamcor = camPosition./sqrt(sum(camPosition.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor to norm_xeyecor
% angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );
% angleDeg = asind( sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)) );
% the acos and asin doesn't work for all test cases and it is better to use
% the atan
angleDeg = atan2d( sqrt(sum(cross(norm_xcamcor,norm_xeyecor).^2)),dot(norm_xcamcor,norm_xeyecor) );

% axis of rotation
if angleDeg == 180
    rotAxis = [0 1 0];
else
    rotAxis = cross(norm_xcamcor,norm_xeyecor);
end

w = rotAxis./sqrt(sum(rotAxis.^2));
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qCamera2Eye = quaternion(q1,q2,q3,q4);

%% Combining all three
qCamRefToEyeCoordinates = qCamera2Eye*qEyePosInRef2Camera;
end