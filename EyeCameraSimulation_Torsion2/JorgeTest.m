
%Eye coordinates
%Following the right handed convention the direction
% to the right is positive x,
% to the up is positive y, and
% to the direction of coming out of the xy plane is positive z


eyeModelRadiuscm = 2.4;

eyeModelRadiusPx = 100;
eyeModelCenterPx = [100, 100];

cameraTiltAngle  = 25;

% gazeVector = [cosd(30) sind(30) 0];
gazeVector = [1 0 0]; % eye looking straight ahead
 % gazeVector = [cosd(-cameraTiltAngle) 0 sind(-cameraTiltAngle)]; % eye looking at the camera

eyeMarks = SimulatedEyePositions_EyeCoordinates(60, 60, 60, 0, gazeVector, eyeModelRadiuscm);
[camEyeImagePoints qCameraToEye]  = SimulatedEyePositions_CamCoordinates(eyeMarks, 50, -cameraTiltAngle, 0,eyeModelRadiusPx/eyeModelRadiuscm, eyeModelCenterPx);



[Torsion, camEyeImagePointsRotated] = SimulateOpenIrisTorsionCalculation(camEyeImagePoints, eyeModelCenterPx, eyeModelRadiusPx);

% THIS is how we are going to use this with data from open iris
eyeDataH = camEyeImagePoints(1,1); % pupil center X
eyeDataV = camEyeImagePoints(1,2); % pupil center Y
eyeDataT = Torsion; % torsion from open iris
eyeCalibrationModelCenter = eyeModelCenterPx;
eyeCalibrationModelRad = eyeModelRadiusPx;
CalibrationCameraAngle = cameraTiltAngle;
[qEyePosInEyeRef, qEyePosInCameraRef] = CalculateEyePositionQuaternion( eyeDataH, eyeDataV, eyeDataT, eyeCalibrationModelCenter, eyeCalibrationModelRad, CalibrationCameraAngle );

 T = rad2deg(quat2eul(qEyePosInEyeRef,'XYZ')) % TODO: this may be wrong


figure
subplot(1,4,1,'nextplot','add')
set(gca,'PlotBoxAspectRatio',[1 1 1])
theta = 0:1:360;
x = cosd(theta)*eyeModelRadiuscm;
y = sind(theta)*eyeModelRadiuscm;
z = zeros(size(y));
plot3(x,y,z,'k');
plot3(y,z,x,'k');
plot3(z,x,y,'k');

plot3(eyeMarks(:,1),eyeMarks(:,2),eyeMarks(:,3),'o'),set(gca,'xlim',[-3,3],'ylim',[-3,3],'zlim',[-3,3]);
view(45,25)


x = cosd(theta)*eyeModelRadiusPx+eyeModelCenterPx(1);
y = sind(theta)*eyeModelRadiusPx+eyeModelCenterPx(2);
subplot(1,4,2,'nextplot','add')
set(gca,'PlotBoxAspectRatio',[1 1 1])
plot(x,y,'k');
plot(camEyeImagePoints(:,1),camEyeImagePoints(:,2),'o'),set(gca,'xlim',[-250,250],'ylim',[-250,250]);


x = cosd(theta)*eyeModelRadiusPx;
y = sind(theta)*eyeModelRadiusPx;
subplot(1,4,3,'nextplot','add')
set(gca,'PlotBoxAspectRatio',[1 1 1])
plot(x,y,'k');
plot(camEyeImagePointsRotated(:,1),camEyeImagePointsRotated(:,2),'o'),set(gca,'xlim',[-250,250],'ylim',[-250,250]);


x = cosd(theta)*eyeModelRadiusPx;
y = sind(theta)*eyeModelRadiusPx;
subplot(1,4,4,'nextplot','add')
set(gca,'PlotBoxAspectRatio',[1 1 1])
plot(x,y,'k');
plot(camEyeImagePointsRotated2(:,1),camEyeImagePointsRotated2(:,2),'o'),set(gca,'xlim',[-250,250],'ylim',[-250,250]);


function [Torsion, camEyeImagePointsRotated] = SimulateOpenIrisTorsionCalculation(camEyeImagePoints, eyeModelCenterPx, eyeModelRadiusPx)
%%%%%%%%%%%%%%%%%%%
% simulating what open iris does to measure torsion
pupilCenter = camEyeImagePoints(1,:);
  
y = camEyeImagePoints(:,2) - eyeModelCenterPx(2);
x = camEyeImagePoints(:,1) - eyeModelCenterPx(1);
angleAll = atan2(y, x);
% Then, get the eccentricity from the length of the vector in pixels to the angle that moves the eye that far
eccAll = asin(sqrt(y .* y + x .* x) / eyeModelRadiusPx);
z = cos(eccAll)*eyeModelRadiusPx;
     
angle = angleAll(1);
ecc = -eccAll(1); % IMPORTANT THIS IS THE OPOSITE AS OPEN IRIS (MINUS SIGN) because here we are rotating from eye to camera. 
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
t1 = -atan2d(camEyeImagePointsRotated(2,2),camEyeImagePointsRotated(2,1))-90;
t2 = -atan2d(camEyeImagePointsRotated(3,2),camEyeImagePointsRotated(3,1))+90;
t3 = 180-atan2d(camEyeImagePointsRotated(4,2),camEyeImagePointsRotated(4,1));
t4 = -atan2d(camEyeImagePointsRotated(5,2),camEyeImagePointsRotated(5,1));
Torsion =mean([t1,t2,t3,t4]);
end


function [qEyePosInEyeRef, qEyePosInCameraRef] = CalculateEyePositionQuaternion( eyeDataH, eyeDataV, eyeDataT, eyeCalibrationModelCenter, eyeCalibrationModelRad, cameraTiltAngle )


pupilCenter = [eyeDataH eyeDataV];
  
y = pupilCenter(2) - eyeCalibrationModelCenter(2);
x = pupilCenter(1) - eyeCalibrationModelCenter(1);
angleAll = atan2(y, x);
% Then, get the eccentricity from the length of the vector in pixels to the angle that moves the eye that far
eccAll = asin(sqrt(y .* y + x .* x) / eyeCalibrationModelRad);
z = cos(eccAll)*eyeCalibrationModelRad;
     
angle = angleAll(1);
ecc = -eccAll(1); % IMPORTANT THIS IS THE OPOSITE AS OPEN IRIS (MINUS SIGN) because here we are rotating from eye to camera. 
% Open iris rotates from camera to eye to calculate the mappings.
% the image warp uses the mapping to "rotate" or unwarp from eye
% coordinates to camera coordinates (eye looking straight ahead to the
% camera)
q1 = cos(ecc/2);
q2 = -sin(angle) * sin(ecc/2);
q3 = cos(angle) * sin(ecc/2);
q4 = 0;

q = quaternion(q1,q2,q3,q4);




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
qEyePosInCameraRef = qt*q;

% LAST STEP IS TO CONVERT full quaternion from camera to reference position
% reference frame
% TODO REVIEW THIS!!!
rotAxis = [0, 0, 1];
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(cameraTiltAngle);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qCameraToEye = quaternion(q1,q2,q3,q4);


qEyePosInEyeRef = qCameraToEye*qEyePosInCameraRef;
end