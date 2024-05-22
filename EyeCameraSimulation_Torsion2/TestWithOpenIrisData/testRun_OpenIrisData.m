clear
%% Data table
% Notes:
%    the right eye frames are from camera looking from the bottom
% to the right eye
%    the left eye frames are from camera looking straight toward the right
% eye (both cameras looking at the same eye from different angle)
%    the stimuli was 9 dots calibration - random order, one dot was not
% visible ([-h,v])
%    note that the frame number in the event file is for the original
% openiris data, and not the post proc frame numbers

h = 15; v = 10; %degree
d = 85; %cm
targets = {[0,0],[h,0],[-h,0],[0,v],[0,-v],[h,v],[h,-v],[-h,v],[-h,-v]};%[-h,v] wasn't visible, condition 8
eyeLeftCameraPosition = [42,0,0];
eyeRightCameraPosition = [42,0,-20];

i=1;
EyeDataFileName{i} = 'Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455\Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455.txt';
TrialDataFile{i} = 'Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455\Calibration__subj2__cal-2024Apr12-104555-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455\Calibration__subj2__cal-2024Apr12-104555.txt';

i=2;
EyeDataFileName{i} = 'Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729\Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729.txt';
TrialDataFile{i} = 'Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729\Calibration__subj2__cal2-2024Apr12-104651-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729\Calibration__subj2__cal2-2024Apr12-104651.txt';

i=3;
EyeDataFileName{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439.txt';
TrialDataFile{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031.txt';

i=4;
EyeDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946.txt';
TrialDataFile{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152.txt';

dataTable = table(EyeDataFileName',TrialDataFile',OriginalRawDataFileName','VariableNames',{'EyeDataFileName','TrialDataFile','OriginalRawDataFileName'});
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