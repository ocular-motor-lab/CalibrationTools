clear
%%
data = readtable("Data\Calibration__TEST__cal_RightEye-2023Sep12-095530-PostProc-2023Oct17-142113\Calibration__TEST__cal_RightEye-2023Sep12-095530-PostProc-2023Oct17-142113.txt");
% figure, 
% plot(data.RightPupilX,data.RightPupilY,'o')
% hold on
% plot(data.LeftPupilX,data.LeftPupilY,'o')

c=1;
for i = 3:3:30
    tmp = data(data.LeftSeconds>i & data.LeftSeconds<i+1,:);

    segData.LeftPupilX(c,1) =  mean(tmp.LeftPupilX);
    segData.LeftPupilY(c,1) =  mean(tmp.LeftPupilY);
    segData.LeftTorsion(c,1) =  mean(tmp.LeftTorsion);

    segData.RightPupilX(c,1) =  mean(tmp.RightPupilX);
    segData.RightPupilY(c,1) =  mean(tmp.RightPupilY);
    segData.RightTorsion(c,1) =  mean(tmp.RightTorsion);
    
    c = c+1;
end
measuredData = struct2table(segData);
measuredData = measuredData(1:9,:);
%%
h = 20;
v = 15;
distanceDispEye = 82;

dots = [[0,0];[h,0];[-h,0];[0,v];[0,-v];[h,v];[h,-v];[-h,v];[-h,-v]];
dispDots(:,1) = ones(1,size(dots,1)) * distanceDispEye;
dispDots(:,2:3) = dots;

referenceOrientation = [1,0,0];
%%
measured = [measuredData.RightPupilX(:) measuredData.RightPupilY(:)];
costf = @(params)...
    ( sum(sum((measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2)));
errorf = @(params)...
    ( sqrt(sum(sum( (measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2 ))) );

estparams = fmincon(costf,[-1,0,0,280],[],[],[],[],[-100,0,0,280],[0,1000,1000,500])
estimatedPoints = Display2Cam_simulation(dispDots, referenceOrientation, estparams(1),0,[estparams(2),estparams(3)],estparams(4));

figure
plot(measured(:,1),measured(:,2),'b+')
hold
plot(estimatedPoints(:,1),estimatedPoints(:,2),'ro')


