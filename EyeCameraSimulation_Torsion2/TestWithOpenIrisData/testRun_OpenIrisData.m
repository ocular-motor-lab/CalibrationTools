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
eyeRightCameraPosition = [42,0,-18];

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
for i = 1:size(dataTable,1)
    
end







% for i = 1:size(dataTable,1)
% 
%     % read data
%     openirisData = readtable(dataTable.EyeDataFileName{i});
% 
%     eyeDataH = openirisData.RightPupilX;
%     eyeDataV = openirisData.RightPupilY;
%     eyeDataT = openirisData.RightTorsion;
% 
%     eyeCalibrationModelCenter = eyeModel.RightCenter{i};
%     eyeCalibrationModelRad = eyeModel.RightRad(i);
% 
%     camposition = eyeRightCameraPosition;
%     calibrationCameraAngle = atand(camposition(3)/camposition(1));
%     calibrationCameraX = camposition(1);
% 
%     eyeDataH_measured = openirisData.LeftPupilX;
%     eyeDataV_measured = openirisData.LeftPupilY;
%     eyeDataT_measured = openirisData.LeftTorsion;
% 
%     for j = 1:size(eyeDataH,1)
%         if eyeDataH(j,:) == 0 && eyeDataV(j,:) == 0, continue, end
%         qCamRefToEyeCoordinates{i}(j,:) = ...
%             CalculateEyeRotationQuaternion(eyeDataH(j,:), eyeDataV(j,:), eyeDataT(j,:),...
%             eyeCalibrationModelCenter, eyeCalibrationModelRad, calibrationCameraAngle, 0, calibrationCameraX );
% 
%         rotatedCamRefGaze{i}(j,:) = rotatepoint(qCamRefToEyeCoordinates{i}(j),[1,0,0]);
% 
%         error_{i}(j,:) =  sqrt((rotatedCamRefGaze{i}(j,2) + eyeCalibrationModelCenter(1) - eyeDataH_measured(j,:) ).^2 ...
%             + (rotatedCamRefGaze{i}(j,3) + eyeCalibrationModelCenter(2) - eyeDataV_measured(j,:) ).^2 );
% 
%     end
% end

