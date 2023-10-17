

clear
close
%%
% [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues();

%% error for different range
visAngleRange = [10, 15, 20, 25, 30, 35, 40];
numberDots = [3,3; 4,4; 5,5];
noiseScale = tan(deg2rad(1))*85;
% j=1;
for j = 1:size(numberDots,1)
for v = 1:size(visAngleRange,2)
    v
    [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues(visAngleRange(v), numberDots(j,1),numberDots(j,2));

    measured = Display2Cam_simulation(dispDots, referenceOrientation, camAlpha, camBeta, eyeGlobePositionPix, eyeRadiusPix);
    measured_noisy = measured+randn(size(measured))*noiseScale;

    costf = @(params)...
        ( sum(sum((measured_noisy - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2)));
    errorf = @(params)...
        ( sqrt(sum(sum( (measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2 ))) );

    % bootstrap
    e = 0;
    for i = 1:1000
        estparams = fmincon(costf,[-1,0,0,0],[],[],[],[],[-100,0,0,0],[0,1000,1000,1000]);
        estimatedPoints = Display2Cam_simulation(dispDots, referenceOrientation, estparams(1),0,[estparams(2),estparams(3)],estparams(4));
        % error of the estimated
        if i == 1, e = errorf(estparams);
        else, e = (errorf(estparams) + e)./2; 
        end
    end
    err(v,j) = e;
end
end

save("simData")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% init param
function [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues(dispDotAngle, nrows, ncolumns)
%% display dots
distanceDispEye = 85;
d = tan(deg2rad(dispDotAngle)) * distanceDispEye * 2 / ncolumns;
[dots, dots_c] = GenerateDisplayDots(nrows,ncolumns,d,d,10);

dispDots_c = zeros(size(dots_c,1), 3); %3D
dispDots_c(:,1) = ones(1,size(dots_c,1)) * distanceDispEye;
dispDots_c(:,2:3) = dots_c;

dispDots = zeros(size(dots,1), 3); %3D
dispDots(:,1) = ones(1,size(dots,1)) * distanceDispEye;
dispDots(:,2:3) = dots;
%% eye globe
eyeRadiusPix = 150;
eyeGlobePositionPix = [400, 200];
%% Camera orientation
camAlpha = -25;% the angle to positive x direction in degree
camBeta = 0; % the angle of the projection on y-z plane and z in degree
referenceOrientation = [1,0,0];
end
