function qCamRefToEyeCoordinates = CalculateEyeRotationQuaternion(eyeDataH, eyeDataV, eyeDataT, eyeCalibrationModelCenter, eyeCalibrationModelRad, camAlpha, camBeta, cam_x, debug_ )
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
if angleDeg == 180 || angleDeg == 0 
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

%% visualizing quaternion for debugging
if ~exist('debug_','var'), debug_ = 0;
elseif debug_ == 1
    QuatPlot(eyeCalibrationModelRad,qt,q,qCamera2Eye,qCamRefToEyeCoordinates )
end

end

%% visualizing quaternion for debugging
function QuatPlot(eyeCalibrationModelRad,qt,q,qCamera2Eye,qCamRefToEyeCoordinates )
% plotting the eye coordinates
sin_ = sin(0:0.01:2*pi).*eyeCalibrationModelRad;
cos_ = cos(0:0.01:2*pi).*eyeCalibrationModelRad;

cameraCor.x = [zeros(size(sin_))',sin_',cos_'];
cameraCor.y = [sin_',zeros(size(sin_))',cos_'];
cameraCor.z = [sin_',cos_',zeros(size(sin_))'];

eyeCor.x = rotatepoint(qCamera2Eye,cameraCor.x);
eyeCor.y = rotatepoint(qCamera2Eye,cameraCor.y);
eyeCor.z = rotatepoint(qCamera2Eye,cameraCor.z);

figure,
% plotting camera cordinates
plot3(cameraCor.x(:,1),cameraCor.x(:,2),cameraCor.x(:,3),'--k')
hold on
plot3(cameraCor.y(:,1),cameraCor.y(:,2),cameraCor.y(:,3),'--k')
hold on
plot3(cameraCor.z(:,1),cameraCor.z(:,2),cameraCor.z(:,3),'--k')

% plotting eye cordinates
hold on
plot3(eyeCor.x(:,1),eyeCor.x(:,2),eyeCor.x(:,3),':b')
hold on
plot3(eyeCor.y(:,1),eyeCor.y(:,2),eyeCor.y(:,3),':b')
hold on
plot3(eyeCor.z(:,1),eyeCor.z(:,2),eyeCor.z(:,3),':b')


% plotting the camera reference position (eye looking at the camera)
eyeLookingAtCamera = EyeLookingAtCamera(eyeCalibrationModelRad,[1,0,0]);
hold on
plot3(eyeLookingAtCamera(:,1),eyeLookingAtCamera(:,2),eyeLookingAtCamera(:,3),'ko')

% plotting the eye rotation with recorded torsion t
eyeLookingAtCamera_torsion = rotatepoint(qt,eyeLookingAtCamera);

hold on
plot3(eyeLookingAtCamera_torsion(:,1),eyeLookingAtCamera_torsion(:,2),eyeLookingAtCamera_torsion(:,3),'ro')

% plotting the eye rotation with recorded position h, v and t
eyePositionInCameraCor = rotatepoint(q,eyeLookingAtCamera_torsion);
hold on
plot3(eyePositionInCameraCor(:,1),eyePositionInCameraCor(:,2),eyePositionInCameraCor(:,3),'mo')

% plotting the eye rotation in the eye coordinates
eyeDirection = rotatepoint(qCamera2Eye,eyePositionInCameraCor);
hold on
plot3(eyeDirection(:,1),eyeDirection(:,2),eyeDirection(:,3),'bo')

% plotting the eye rotation in the eye coordinates using one quaternion
eyeDirection2 = rotatepoint(qCamRefToEyeCoordinates,eyeLookingAtCamera);
hold on
plot3(eyeDirection2(:,1),eyeDirection2(:,2),eyeDirection2(:,3),'go')

legend({'CameraCordinates','','','EyeCordinates','','','Cam Ref - Eye looking at the camera','Rotation by t','Rotation by h,v and t','Eye rotation in eye cordinates','using one quaternion' })
xlim([-300,300])
ylim([-300,300])
zlim([-300,300])
daspect([1,1,1])
view(70,25)
end

function eyeLookingAtCamera = EyeLookingAtCamera(eyeCalibrationModelRad,norm_xcamcor)
% simulate an eye looking toward the camera (camera reference position)
% with markers on the surface of the eye
eyeLookingAtCamera(1,:) = norm_xcamcor*eyeCalibrationModelRad;
angleDeg = 2;
rotAxisV = [0,1,0];%vertical rotation
rotAxisH = [0,0,1];%horizontal rotation
c = 2;
for n = 1:10
    eyeLookingAtCamera(c,:) = RotateAlongAxis(eyeLookingAtCamera(1,:), angleDeg*n, rotAxisV);
    c=c+1;
    eyeLookingAtCamera(c,:) = RotateAlongAxis(eyeLookingAtCamera(1,:), angleDeg*n, rotAxisH);
    c=c+1;
end

for n = 1:5
    eyeLookingAtCamera(c,:) = RotateAlongAxis(eyeLookingAtCamera(1,:), -angleDeg*n, rotAxisV);
    c=c+1;
    eyeLookingAtCamera(c,:) = RotateAlongAxis(eyeLookingAtCamera(1,:), -angleDeg*n, rotAxisH);
    c=c+1;
end

end

function rotatedPoint = RotateAlongAxis(input, angleDeg, rotAxis)
%axis of rotation
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

q = quaternion(q1,q2,q3,q4);

%apply the quaternion
rotatedPoint = rotatepoint(q,input);

end
