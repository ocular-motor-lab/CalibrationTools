clear
%% Init Param
eyeModelRadiuscm = 2.4;

eyeModelRadiusPx = 100;
eyeModelCenterPx = [100, 100];

cameraTiltAngle  = -25;
cameraPositionXcm = 50;

% gazeVector = [cosd(30) sind(30) 0];
 gazeVector = [1 0 0]; % eye looking straight ahead
% gazeVector = [cosd(cameraTiltAngle) 0 sind(cameraTiltAngle)]; % eye looking at the camera

%% Simulation 
eyeMarks = SimulatedEyePositions_EyeCoordinates(60, 60, 60, 0, gazeVector, eyeModelRadiuscm);
camEyeImagePoints = SimulatedEyePositions_CamCoordinates(eyeMarks, cameraPositionXcm, cameraTiltAngle, 0,eyeModelRadiusPx/eyeModelRadiuscm, eyeModelCenterPx);
[torsion,testRotatedcamEye] = SimulateOpenIrisTorsionCalculation(camEyeImagePoints, eyeModelCenterPx, eyeModelRadiusPx);

% OpenIris Data
eyeDataH = camEyeImagePoints(1,1); % pupil center X
eyeDataV = camEyeImagePoints(1,2); % pupil center Y
eyeDataT = torsion; % torsion from open iris
eyeCalibrationModelCenter = eyeModelCenterPx;
eyeCalibrationModelRad = eyeModelRadiusPx;
calibrationCameraAngle = cameraTiltAngle;
calibrationCameraX = cameraPositionXcm;

%% Extracting Eye Movement Form OpenIris Measurements
[qCamRefToEyeCoordinates, qEyePosInRef2Camera, qCamera2Eye] = ...
    CalculateEyeRotationQuaternion( camEyeImagePoints,eyeDataH, eyeDataV, eyeDataT,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, calibrationCameraAngle, 0, calibrationCameraX );

T = rad2deg(quat2eul(qCamRefToEyeCoordinates,'XYZ'))

%%
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





