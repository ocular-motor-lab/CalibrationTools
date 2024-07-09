clear
DataTable
%% estimate the eye model radius and center in pixel
eyeModel = EstimateEyeModel(dataTable,targets,d,eyeLeftCameraPosition,eyeRightCameraPosition);

%% compare the left and right camera data
for session = 1:size(dataTable,1)
    openirisData = readtable(dataTable.EyeDataFileName{session});

    %LeftEye
    H = openirisData.LeftPupilX;
    V = openirisData.LeftPupilY;
    T = openirisData.LeftTorsion;
    measuredEyePositions = table(H,V,T,'VariableNames',{'H','V','T'});
    measuredEyeData{session}.Left = measuredEyePositions;
    rotatedCamRefGaze{session}.Left = EstimateGazeDirection(measuredEyePositions,...
        eyeModel.LeftCenter{session}, eyeModel.LeftRad(session), eyeLeftCameraPosition );

    %RightEye
    H = openirisData.RightPupilX;
    V = openirisData.RightPupilY;
    T = openirisData.RightTorsion;
    measuredEyePositions = table(H,V,T,'VariableNames',{'H','V','T'});
    measuredEyeData{session}.Right = measuredEyePositions;
    rotatedCamRefGaze{session}.Right = EstimateGazeDirection(measuredEyePositions,...
        eyeModel.RightCenter{session}, eyeModel.RightRad(session), eyeRightCameraPosition );

end

%%
session =1;
figure,
plot3(rotatedCamRefGaze{session}.Left(:,1),rotatedCamRefGaze{session}.Left(:,2),rotatedCamRefGaze{session}.Left(:,3),'o')
hold on
plot3(rotatedCamRefGaze{session}.Right(:,1),rotatedCamRefGaze{session}.Right(:,2),rotatedCamRefGaze{session}.Right(:,3),'o')

legend({'Left','Right'})
daspect([1,1,1])
view(70,25)

figure,
subplot(1,2,1)
% plot(rotatedCamRefGaze{session}.Left(:,1))
% hold on 
plot(rotatedCamRefGaze{session}.Left(:,2))
hold on 
plot(rotatedCamRefGaze{session}.Right(:,2))
title('Horizontal')
ylim([-0.8,0.6])

subplot(1,2,2)
% plot(rotatedCamRefGaze{session}.Right(:,1))
% hold on 
plot(rotatedCamRefGaze{session}.Left(:,3))
hold on 
plot(rotatedCamRefGaze{session}.Right(:,3))
title('Vertical')
legend({'Left','Right'})
ylim([-0.8,0.6])

% figure,
% subplot(1,2,1)
% % plot(rotatedCamRefGaze{session}.Left(:,1))
% % hold on 
% plot(rotatedCamRefGaze{session}.Left(:,2))
% hold on 
% plot(rotatedCamRefGaze{session}.Left(:,3))
% title('LeftEye')
% 
% subplot(1,2,2)
% % plot(rotatedCamRefGaze{session}.Right(:,1))
% % hold on 
% plot(rotatedCamRefGaze{session}.Right(:,2))
% hold on 
% plot(rotatedCamRefGaze{session}.Right(:,3))
% title('RightEye')