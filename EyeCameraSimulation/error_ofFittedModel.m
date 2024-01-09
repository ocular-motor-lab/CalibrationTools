

clear
close
%%
% [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues();

%% error for different range
clear
close

visAngleRange = [10, 15, 20, 25, 30, 35, 40];
numberDots = [3,3; 4,4; 5,5];
noiseScale = tan(deg2rad(11))*85;
rep = 1000;
% j=1;
c=1;
for j = 1:size(numberDots,1)
    for v = 1:size(visAngleRange,2)
        v
        [dispDots,eyeRadiusPix,eyeGlobePositionPix,camAlpha,camBeta,referenceOrientation] = InitTrueValues(visAngleRange(v), numberDots(j,1),numberDots(j,2));

        measured = Display2Cam_simulation(dispDots, referenceOrientation, camAlpha, camBeta, eyeGlobePositionPix, eyeRadiusPix);

        % bootstrap
        e = 0;
        for i = 1:rep
            measured_noisy = measured+randn(size(measured))*noiseScale;

            costf = @(params)...
                ( sum(sum((measured_noisy - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2)));
            errorf = @(params)...
                ( sqrt(sum(sum( (measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2 ))) );

            estparams = fmincon(costf,[-1,0,0,0],[],[],[],[],[-100,0,0,0],[0,1000,1000,1000]);
            estimatedPoints = Display2Cam_simulation(dispDots, referenceOrientation, estparams(1),0,[estparams(2),estparams(3)],estparams(4));
            
            estparamsAll(c,:) = [estparams(1),estparams(2),estparams(3),estparams(4),numberDots(j,1)*numberDots(j,2),visAngleRange(v),noiseScale];
            c=c+1;
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

estparamsAllTable = table(estparamsAll(:,1),estparamsAll(:,2),estparamsAll(:,3),estparamsAll(:,4),estparamsAll(:,5),estparamsAll(:,6),estparamsAll(:,7)...
    ,'VariableNames',{'CameraAngle','EyeGlobePosition_X'...
    ,'EyeGlobePosition_Y','EyeGlobeRadius','NumberOfDots','DiplayedVisualAngle','NoiseScale'});


save("simData_noise1_numberOfDots")
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

file_ = {'simData_noise0point25.mat';'simData_noise0point5.mat'; 'simData_noise1.mat';...
    'simData_noise2.mat';'simData_noise4.mat';'simData_noise8.mat';'simData_noise16.mat'};
noise = [tan(deg2rad(0.25)),tan(deg2rad(0.5)),tan(deg2rad(1)),tan(deg2rad(2)),...
    tan(deg2rad(4)),tan(deg2rad(8)),tan(deg2rad(16))].*85;
tbl = [];
for f = 1:size(file_,1)
    load(file_{f})
    if f == 1, tbl = estparamsAllTable;
    else, tbl = [tbl;estparamsAllTable]; 
    end
end

gstat = grpstats(tbl,["NumberOfDots","DiplayedVisualAngle","NoiseScale"],["mean","std"]);

h1 = figure;
h2 = figure;
for i = 1:length(noise)-2
    set(0,'CurrentFigure',h1)
    subplot(3,3,i)
    hist(tbl(tbl.DiplayedVisualAngle == 20 & tbl.NoiseScale == noise(i),: ).CameraAngle)
    title(strcat('Noise = ',num2str(round(noise(i),2)),' cm'))
    

    tmp = gstat(gstat.NoiseScale == noise(i),:);
    set(0,'CurrentFigure',h2)
    %plot(tmp.DiplayedVisualAngle, abs(tmp.mean_CameraAngle + 25),'LineWidth',3)
    %hold on,
    errorbar(tmp.DiplayedVisualAngle, abs(tmp.mean_CameraAngle + 25),(tmp.std_CameraAngle)*0,tmp.std_CameraAngle/2,'LineWidth',3)
    hold on
end
xlabel("Total Visaul Angle of Presented Dots (degree)") 
ylabel("Absolute Error of Estimated Camera Angle (degree)")
legend({'Noise = 0.25 deg','std','0.5','1','2','4','8','16'})

set(0,'CurrentFigure',h1)
sgtitle('3x3 Dots, Visual Degree of 10')
xlabel('Estimated Camera Angle (deg)')
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
