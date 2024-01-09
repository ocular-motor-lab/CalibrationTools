clear
%%
data = readtable("Data\Calibration__TEST__cal_RightEye-2023Sep12-095530-PostProc-2023Oct17-142113\Calibration__TEST__cal_RightEye-2023Sep12-095530-PostProc-2023Oct17-142113.txt");
figure, 
plot(data.RightPupilX,data.RightPupilY,'ro')
hold on
plot(data.LeftPupilX,data.LeftPupilY,'bo')

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
h_angle = 10;
v_angle = 7.5;
 
distanceDispEye = 82;

h_dis = tan(deg2rad(h_angle)) * distanceDispEye;
v_dis = tan(deg2rad(v_angle)) * distanceDispEye;

h_dis = - h_dis;
v_dis = - v_dis;

load('M:\Roksana\Micro6D\Calibration__TEST__cal_RightEye\trialDataTable.mat','trialDataTable');
dots = [[0,0];[h_dis,0];[-h_dis,0];[0,v_dis];[0,-v_dis];[h_dis,v_dis];[h_dis,-v_dis];[-h_dis,v_dis];[-h_dis,-v_dis]];
dots = dots(trialDataTable.TargetPosition(1:end-1),:);
dispDots(:,1) = ones(1,size(dots,1)) * distanceDispEye;
dispDots(:,2:3) = dots;

referenceOrientation = [1,0,0];
%%
measured = [measuredData.RightPupilX(:) measuredData.RightPupilY(:)];
% measured = [measuredData.LeftPupilX(:) measuredData.LeftPupilY(:)];
costf = @(params)...
    ( sum(sum((measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2)));
errorf = @(params)...
    ( sqrt(sum(sum( (measured - Display2Cam_simulation(dispDots,referenceOrientation,params(1),0,[params(2),params(3)],params(4))).^2 ))) );

estparams = fmincon(costf,[1,0,0,300],[],[],[],[],[-180,0,0,0],[0,1000,1000,500])
estimatedPoints = Display2Cam_simulation(dispDots, referenceOrientation, estparams(1),0,[estparams(2),estparams(3)],estparams(4));

figure
plot(measured(:,1),measured(:,2),'b+')
hold on

plot(estimatedPoints(:,1),estimatedPoints(:,2),'ro')
hold on

ylim([0,400])
xlim([0,700])
set(gca, 'YDir','reverse')

plot(cos(0:0.1:(2*pi))*estparams(4)+estparams(2),sin(0:0.1:(2*pi))*estparams(4)+estparams(3))

legend('measured','estimated','estimated eye globe')
xlabel('Pixel'),ylabel('Pixel')
axis equal

%%
figure
plot(dots(:,1))
hold
plot(measured(:,1))

figure
plot(dots(:,2))
hold
plot(measured(:,2))


