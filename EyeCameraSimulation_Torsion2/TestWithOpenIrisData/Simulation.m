%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is to use simulated data (generating the measured data by
% adding a noise to the true data), and using the openiris data (with no 
% torsion; recording with two cameras from one eye)
% The functions used in these two sections are at the end of the scripts,
% and in the directory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%%%% SECTION 1 %%%%%
%%%%%%%%%%%%%%%%%%%%%
%% Simulation 1 - estimate the gaze direction from camera image, 
% two cameras for same targets
clear

noiseSD = 5;
hdeg = 10; vdeg = 10;
% generate the target positions
simulatedTrueGazeDirections = SimulatedGazeDirections(hdeg,vdeg);

% cam 1
eyeRadius = 300;
eyeCenterPix = [150,150];
camParam1.cam_x = 200;
camParam1.camAlpha = -25;
camParam1.camBeta = 0;
camPosition1 = [camParam1.cam_x, 0, camParam1.cam_x*tand(camParam1.camAlpha)];

% simulate the measurements 
[measured_h,measured_v,~,~] = AddingNoise(eyeRadius,eyeCenterPix,camParam1,simulatedTrueGazeDirections,noiseSD);
measured_t = zeros(size(measured_h));
measuredEyePositions1 = table(measured_h',measured_v',measured_t','VariableNames',{'H','V','T'});

minEyeModelCenter = mean([measuredEyePositions1.H, measuredEyePositions1.V]);

costf = @(param) CostF_toEstimateEyeModel(measuredEyePositions1,simulatedTrueGazeDirections,...
    [param(1),param(2)], param(3), camPosition1);

estParam = fmincon( costf,[minEyeModelCenter(1),minEyeModelCenter(2),350],[],[],[],[],[10,10,10],[1000,1000,1000]);

estRad = estParam(3);
estCenter = [estParam(1),estParam(2)];

eyeModel = table(estRad,eyeRadius,estCenter,eyeCenterPix,'VariableNames',{'estRad','trueRad','estCenter','trueCenter'});
clearvars -except eyeModel cam* simulatedTrueGazeDirections *deg measuredEyePositions* noiseSD

%Cam2
eyeRadius = 250;
eyeCenterPix = [120,120];
camParam2.cam_x = 200;
camParam2.camAlpha = 0;
camParam2.camBeta = 0;
camPosition2 = [camParam2.cam_x, 0, camParam2.cam_x*tand(camParam2.camAlpha)];

% simulate the measurements 
[measured_h,measured_v,~,~] = AddingNoise(eyeRadius,eyeCenterPix,camParam2,simulatedTrueGazeDirections,noiseSD);
measured_t = zeros(size(measured_h));
measuredEyePositions2 = table(measured_h',measured_v',measured_t','VariableNames',{'H','V','T'});

minEyeModelCenter = mean([measuredEyePositions2.H, measuredEyePositions2.V]);

costf = @(param) CostF_toEstimateEyeModel(measuredEyePositions2,simulatedTrueGazeDirections,...
    [param(1),param(2)], param(3), camPosition2);

estParam = fmincon( costf,[minEyeModelCenter(1),minEyeModelCenter(2),250],[],[],[],[],[10,10,10],[1000,1000,1000]);

eyeModel.estRad(2) = estParam(3);
eyeModel.estCenter(2,:) = [estParam(1),estParam(2)];
eyeModel.trueRad(2) = eyeRadius;
eyeModel.trueCenter(2,:) = [eyeCenterPix(1),eyeCenterPix(2)];

clearvars -except eyeModel cam* simulatedTrueGazeDirections measuredEyePositions*

% Plotting results
% using predicted eye model to estimate the gaze directions and compare it
% with the true gaze directions from target positions
rotatedCamRefGaze1 = EstimateGazeDirection(measuredEyePositions1,...
    eyeModel.estCenter(1,:), eyeModel.estRad(1), camPosition1 );

rotatedCamRefGaze2 = EstimateGazeDirection(measuredEyePositions2,...
    eyeModel.estCenter(2,:), eyeModel.estRad(2), camPosition2 );

figure, 

plot3(simulatedTrueGazeDirections(:,1),simulatedTrueGazeDirections(:,2),simulatedTrueGazeDirections(:,3),'ko')
hold on
plot3(rotatedCamRefGaze1(:,1),rotatedCamRefGaze1(:,2),rotatedCamRefGaze1(:,3),'bo')
hold on
plot3(rotatedCamRefGaze2(:,1),rotatedCamRefGaze2(:,2),rotatedCamRefGaze2(:,3),'ro')

legend({'trueGazeDirection - Using target positions','GazeDirectionCam1','GazeDirectionCam2'})
title('Gaze Directions')
%% Simulation 2 - estimate the camera image from gaze direction
clear

noiseSD = 5;
hdeg = 10; vdeg = 10;

% generate the target positions
simulatedTrueGazeDirections = SimulatedGazeDirections(hdeg,vdeg);

% camera parameters
eyeRadius = 300;
eyeCenterPix = [150,150];
camParam.cam_x = 200;%in cm
camParam.camAlpha = -25;%in deg
camParam.camBeta = 0;%in deg

% simulate the measurements 
[measured_h,measured_v,true_h,true_v] = AddingNoise(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,noiseSD);
c = CostFunctionSimulation(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,[measured_h',measured_v']);

% define the cost function
costf = @(param) CostFunctionSimulation(param(1),[param(2),param(3)],camParam,simulatedTrueGazeDirections,[measured_h',measured_v']);

% estimate the eyeModel parameters
estParam = fmincon( costf,[50,50,50],[],[],[],[],[10,10,10],[1000,1000,1000]);

eyeModel.estRad(1) = estParam(1);
eyeModel.estCenter(1,:) = [estParam(2),estParam(3)];
eyeModel.trueRad(1) = eyeRadius;
eyeModel.trueCenter(1,:) = [eyeCenterPix(1),eyeCenterPix(2)];
eyeModel = struct2table(eyeModel);

% plot the results
plotResults(estParam(1),[estParam(2),estParam(3)],camParam,simulatedTrueGazeDirections,[measured_h',measured_v'],[true_h',true_v'],1);


%%%%%%%%%%%%%%%%%%%%%
%%%%% SECTION 2 %%%%%
%%%%%%%%%%%%%%%%%%%%%
%% OpenIris Data with no Torsion
clear
% read the data
DataTable % outputs dataTable, targets, cameraposition, and displayDistance

% selecting one session
session = 1;
[measuredEyePositionsPix, trueGazeDirectionUnitVec] = PrepareData(dataTable,session,targets,d);

% Left Camera
camposition = eyeLeftCameraPosition;
camParamLeft.camAlpha = atand(camposition(3)/camposition(1));
camParamLeft.cam_x = camposition(1);
camParamLeft.camBeta = 0;

% define the cost function
costf = @(param) CostFunctionSimulation(param(1),[param(2),param(3)],camParamLeft,trueGazeDirectionUnitVec,measuredEyePositionsPix.Left{:,1:2});

% estimate the eyeModel parameters
estParam.Left = fmincon( costf,[50,50,50],[],[],[],[],[10,10,10],[1000,1000,1000]);

% Right Camera
camposition = eyeRightCameraPosition;
camParamRight.camAlpha = atand(camposition(3)/camposition(1));
camParamRight.cam_x = camposition(1);
camParamRight.camBeta = 0;

% define the cost function
costf = @(param) CostFunctionSimulation(param(1),[param(2),param(3)],camParamRight,trueGazeDirectionUnitVec,measuredEyePositionsPix.Right{:,1:2});

% estimate the eyeModel parameters
estParam.Right = fmincon( costf,[50,50,50],[],[],[],[],[10,10,10],[1000,1000,1000]);

eyeModel.estRad(1) = estParam.Left(1);
eyeModel.estCenter(1,:) = [estParam.Left(2),estParam.Left(3)];
eyeModel.estRad(2) = estParam.Right(1);
eyeModel.estCenter(2,:) = [estParam.Right(2),estParam.Right(3)];

% Plotting the results
% camera image
estimatedLeft = plotResults(estParam.Left(1),[estParam.Left(2),estParam.Left(3)],camParamLeft,trueGazeDirectionUnitVec,measuredEyePositionsPix.Left{:,1:2},[nan,nan],1);
estimatedRight = plotResults(estParam.Right(1),[estParam.Right(2),estParam.Right(3)],camParamRight,trueGazeDirectionUnitVec,measuredEyePositionsPix.Right{:,1:2},[nan,nan],1);

% gaze directions
% using predicted eye model to estimate the gaze directions and compare it
% with the true gaze directions from target positions
measuredEyePositionsPixLeft.H = measuredEyePositionsPix.Left{:,1};
measuredEyePositionsPixLeft.V = measuredEyePositionsPix.Left{:,2};
measuredEyePositionsPixLeft.T = measuredEyePositionsPix.Left{:,3};

measuredEyePositionsPixRight.H = measuredEyePositionsPix.Right{:,1};
measuredEyePositionsPixRight.V = measuredEyePositionsPix.Right{:,2};
measuredEyePositionsPixRight.T = measuredEyePositionsPix.Right{:,3};

rotatedCamRefGaze1 = EstimateGazeDirection(struct2table(measuredEyePositionsPixLeft),...
    eyeModel.estCenter(1,:), eyeModel.estRad(1), eyeLeftCameraPosition );

rotatedCamRefGaze2 = EstimateGazeDirection(struct2table(measuredEyePositionsPixRight),...
    eyeModel.estCenter(2,:), eyeModel.estRad(2), eyeRightCameraPosition );

figure, 

plot3(trueGazeDirectionUnitVec(:,1),trueGazeDirectionUnitVec(:,2),trueGazeDirectionUnitVec(:,3),'ko')
hold on
plot3(rotatedCamRefGaze1(:,1),rotatedCamRefGaze1(:,2),rotatedCamRefGaze1(:,3),'bo')
hold on
plot3(rotatedCamRefGaze2(:,1),rotatedCamRefGaze2(:,2),rotatedCamRefGaze2(:,3),'ro')

legend({'trueGazeDirection - Using target positions','GazeDirection from LeftCam','GazeDirection from RightCam'})
title('Gaze Directions')


%%%%%%%%%%%%%%%%%%%%%
%%%%% Functions %%%%%
%%%%%%%%%%%%%%%%%%%%%
%% Functions
function estimated = plotResults(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,measured,truepix,ifplot)

for i = 1:size(simulatedTrueGazeDirections,1)
    [estimated(i,1),estimated(i,2)] = SimulateCameraEyePixels(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections(i,:));
end
if ifplot==1
    figure,
    plot(truepix(:,1),truepix(:,2),'ko')
    hold on
    plot(estimated(:,1),estimated(:,2),'o')
    hold on
    plot(measured(:,1),measured(:,2),'o')
    legend({'truePix','estimatedPix - Using Eye Model','measuredPix - Simulated with added noise'})
    title('Camera Image of Pupil Center (Pix)')
end
end

function err_rmse = CostFunctionSimulation(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,measured)

for i = 1:size(simulatedTrueGazeDirections,1)
    [estimated(i,1),estimated(i,2)] = SimulateCameraEyePixels(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections(i,:));
end
% define the cost function
err = sqrt( sum( (measured-estimated).^2,2) );
err_rmse = sqrt( mean(err.^2));

end


function simulatedGazeDirections = SimulatedGazeDirections(hdeg,vdeg)

h = tand(hdeg);
v = tand(vdeg);
t(1,:) = [sqrt(1-h^2 - v^2),h,v];
t(2,:) = [sqrt(1-h^2 - v^2),-h,v];
t(3,:) = [sqrt(1-h^2 - v^2),h,-v];
t(4,:) = [sqrt(1-h^2 - v^2),-h,-v];
t(5,:) = [sqrt(1-h^2),h,0];
t(6,:) = [sqrt(1-h^2),-h,0];
t(7,:) = [sqrt(1-v^2),0,v];
t(8,:) = [sqrt(1 - v^2),0,-v];
t(9,:) = [1,0,0];
simulatedGazeDirections = t;
end

function [measured_h,measured_v,true_h,true_v] = AddingNoise(eyeRadius,eyeCenterPix,camParam,eyedirections,noiseSD)

for i = 1:size(eyedirections,1)
    [h,v] = SimulateCameraEyePixels(eyeRadius,eyeCenterPix,camParam,eyedirections(i,:));
    measured_h(i) = h + randn*noiseSD;
    measured_v(i) = v + randn*noiseSD;
    true_h(i) = h;
    true_v(i) = v;
end

end

function [h,v] = SimulateCameraEyePixels(eyeRadius,eyeCenterPix,camParam,eyedirections)
% from global eye coordinates to camera coordinates
% calculate the quaternion to rotate eye positions from global eye coordinates 
% to camera coordinates 

% cam location in eye coordinates
cam_z = tand(camParam.camAlpha)*camParam.cam_x;
cam_y = tand(camParam.camBeta)*camParam.cam_x;

camPosition = [camParam.cam_x, cam_y, cam_z];

% reverse(The camera view axis is from center of the eye globe to the camera, we
% want to rotate this axis to one from center of the eye globe to the
% center of the display)
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
% this is negative to have the gaze direction in the eye looking at the
% center of the display.
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qCamera2Eye = quaternion(q1,q2,q3,q4);

% get the h and v
rotatedCamRefGaze = rotatepoint(qCamera2Eye,eyedirections);

h = rotatedCamRefGaze(2);
v = rotatedCamRefGaze(3);

h = h*eyeRadius + eyeCenterPix(1);
v = v*eyeRadius + eyeCenterPix(2);


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% FUNCTIONS FOR SECTION 2 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [measuredEyePositionsPix, trueGazeDirectionUnitVec] = PrepareData(dataTable,session,targets,d)

eventTable = CreateEventTable(dataTable.TrialDataFile{session}, dataTable.OriginalRawDataFileName{session},...
    dataTable.EyeDataFileName{session}, targets, d);
eventTable = eventTable(eventTable.LeftPupilX_mean~=0,:);
%LefttEye
trueGazeDirectionUnitVec = cell2mat(eventTable.TrueGazeDirection);

H = eventTable.LeftPupilX_mean;
V = eventTable.LeftPupilY_mean;
T = eventTable.LeftTorsion_mean;
measuredEyePositionsPix.Left = table(H,V,T,'VariableNames',{'H','V','T'});

H = eventTable.RightPupilX_mean;
V = eventTable.RightPupilY_mean;
T = eventTable.RightTorsion_mean;
measuredEyePositionsPix.Right = table(H,V,T,'VariableNames',{'H','V','T'});

% remove condition 8 - because the target wasn't visible
measuredEyePositionsPix.Left = measuredEyePositionsPix.Left(eventTable.ConditionNumber~=8,:);
measuredEyePositionsPix.Right = measuredEyePositionsPix.Right(eventTable.ConditionNumber~=8,:);
trueGazeDirectionUnitVec = trueGazeDirectionUnitVec(eventTable.ConditionNumber~=8,:);

end


