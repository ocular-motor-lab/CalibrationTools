%%
distanceDispEye = 85;
rows = 9;
columns = 9;
[dots, dots_c] = GenerateDisplayDots(rows,columns,10,10,0); 

dispDots_c = zeros(size(dots_c,1), 3); %3D
dispDots_c(:,1) = ones(1,size(dots_c,1)) * distanceDispEye;
dispDots_c(:,2:3) = dots_c;

dispDots = zeros(size(dots,1), 3); %3D
dispDots(:,1) = ones(1,size(dots,1)) * distanceDispEye;
dispDots(:,2:3) = dots;

% create vectors from eye to the dot with eye radius length
eyeRadiusPix = 160; %cm, arbitrary number
eyeGlobePositionPix = [400, 200];

camZ = -20;
camY = 0;

referenceOrientation = [1,0,0];
%% simulation of gaze positions during calibration
measured = Display2Cam_simulation(dispDots_c, referenceOrientation, camZ, camY, eyeGlobePositionPix, eyeRadiusPix);
measured_noisy = measured+randn(size(measured))*10;
%% end of simulation
costf = @(params)( sum(sum((measured_noisy - Display2Cam_simulation(dispDots_c,referenceOrientation,params(4),params(5), params(1:2),params(3))).^2)));

estparams = fmincon(costf,[0,0,0,-1,-1],[],[],[],[],[0,0,0,-100,-100],[1000,1000,1000,100,100])

estimatedPoints = Display2Cam_simulation(dispDots_c, referenceOrientation, estparams(4), estparams(5), estparams(1:2), estparams(3));

figure
plot(measured(:,1),measured(:,2),'+')
hold
plot(estimatedPoints(:,1),estimatedPoints(:,2),'r+')
%% error of the estimated 
errorf = @(params)( sum(sum((measured - Display2Cam_simulation(dispDots_c,referenceOrientation,params(4),params(5), params(1:2),params(3))).^2)));
errorf(estparams)

