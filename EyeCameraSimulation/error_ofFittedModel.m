

clear
close
%%
% [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues();

%% error for different range
clear
close

visAngleRange = [10, 15, 20, 25, 30, 35, 40];
numberDots = [3,3]%; 4,4; 5,5];
noiseScale = tan(deg2rad(5))*85;
rep = 1000;
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
    for i = 1:rep
        estparams = fmincon(costf,[-1,0,0,0],[],[],[],[],[-100,0,0,0],[0,1000,1000,1000]);
        estimatedPoints = Display2Cam_simulation(dispDots, referenceOrientation, estparams(1),0,[estparams(2),estparams(3)],estparams(4));
        estparamsAll{i,j,v} = estparams; 
        % error of the estimated
        tmp = errorf(estparams);
        if i == 1, e = tmp;
        else, e = (tmp + e)./2; 
        end
        errorAll{i,j,v} = tmp;
    end
    err(v,j) = e;
end
end

save("simData_noise5")
%%
figure,
for i = 1:size(numberDots,1)
    plot(visAngleRange,err(:,i)./(numberDots(i,1)*numberDots(i,2)),'.-','MarkerSize',10)
    hold on
end
xlabel("Total Visaul Angle of Presented Dots (degree)")
ylabel("Mean Variance")
legend(["3x3","4x4","5x5"])

%% 

file_ = {'simData.mat';'simData_noise5.mat'; 'simData_noise10.mat'};
for f = 1:size(file_,1)
    load(file_{f})
    for v = 1:size(visAngleRange,2)
        estparam_average(f,v,:) = sum(cell2mat(estparamsAll(:,1,v)),1)./size(estparamsAll,1);
    end
    plot(visAngleRange,estparam_average(f,:,1),'.-','MarkerSize',10)
    hold on

end

plot(visAngleRange,ones(size(visAngleRange))*(-25),'--','MarkerSize',10)
hold on

xlabel("Total Visaul Angle of Presented Dots (degree)")
ylabel("Est. Camera Angle (degree)")
legend(["Noise - 3 deg","5 deg","10 deg","Actual Camera Angle"])

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
