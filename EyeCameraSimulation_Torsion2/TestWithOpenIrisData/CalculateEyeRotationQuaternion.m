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

angle = atan2(z, y);

if sqrt(z .* z + y .* y) > eyeCalibrationModelRad, qCamRefToEyeCoordinates = quaternion(nan,nan,nan,nan); return;end
ecc = -( asin( sqrt(z .* z + y .* y)  / eyeCalibrationModelRad) );
      
q1 = cos(ecc/2);
q2 = 0;
q3 = -sin(angle)* sin(ecc/2);
q4 = cos(angle) * sin(ecc/2);

q = quaternion(q1,q2,q3,q4);
 
% quaterion for just the torsional component. With the eye rotating around an
% axis perpendicular to the camera (in camera coordinates is x)
torsion = eyeDataT;
ecc = deg2rad(torsion); 
q1 = cos(ecc/2);
q2 = 1* sin(ecc/2);
q3 = 0;
q4 = 0;
qt = quaternion(q1,q2,q3,q4);

% full rotation is q and qt in sequence, still in camera reference frame
qEyePosInCamera2Ref = qt*q;
qEyePosInRef2Camera = conj(qEyePosInCamera2Ref);
% Last step is to calculate the full quaternion from camera reference position to
% global coordinates where the center of the coordinates is at center of
% eye globe
%% from camera coordinates to global eye coordinates
% calculate the quaternion to rotate eye positions from camera coordinates 
% to global eye coordinates  
% cam location in eye coordinates
cam_z = tand(camAlpha)*cam_x;
cam_y = tand(camBeta)*cam_x;

camPosition = [cam_x, cam_y, cam_z];

% camera x axis positive direction will be camPosition 
% to the zero position of eye-coordinates
norm_xcamcor = -camPosition./sqrt(sum(camPosition.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor and norm_xeyecor
% angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );
% angleDeg = asind( sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)) );
angleDeg = atan2d(sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)),dot(norm_xeyecor,norm_xcamcor));

% axis of rotation
if angleDeg == 180
    rotAxis = [0 1 0];
else
    rotAxis = cross(norm_xeyecor,norm_xcamcor);
end

w = rotAxis./sqrt(sum(rotAxis.^2));
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qEye2Camera = quaternion(q1,q2,q3,q4);
qCamera2Eye = conj(qEye2Camera);
%% Combining all three
qCamRefToEyeCoordinates = qCamera2Eye*qEyePosInRef2Camera;
end