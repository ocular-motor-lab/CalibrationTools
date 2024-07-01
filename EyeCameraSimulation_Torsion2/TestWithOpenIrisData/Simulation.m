
eyeRadius = 300;
eyeCenterPix = [150,150];
eyedirections = [1,0,0];
noiseSD = 50;
camParam.cam_x = 200;
camParam.camAlpha = -25;
camParam.camBeta = 0;
hdeg = 10; vdeg = 10;

% generate the target positions
simulatedTrueGazeDirections = SimulatedGazeDirections(hdeg,vdeg);

% simulate the measurements 
[measured_h,measured_v,true_h,true_v] = AddingNoise(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,noiseSD);
c = CostFunctionSimulation(eyeRadius,eyeCenterPix,camParam,simulatedTrueGazeDirections,[measured_h',measured_v']);

% define the cost function
costf = @(param) CostFunctionSimulation(param(1),[param(2),param(3)],camParam,simulatedTrueGazeDirections,[measured_h',measured_v']);

% estimate the eyeModel parameters
estParam = fmincon( costf,[50,50,50],[],[],[],[],[10,10,10],[1000,1000,1000]);

% plot the results


%% Functions
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