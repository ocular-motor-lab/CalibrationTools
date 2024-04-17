clear
%% Data table
% Notes: 
%    the right eye frames are from camera looking from the bottom 
% to the right eye
%    the left eye frames are from camera looking straight toward the right 
% eye (both cameras looking at the same eye from different angle)

i=1;
EyeDataFileName{i} = 'Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455\Calibration__subj2__cal-2024Apr12-104555-PostProc-2024Apr12-144455.txt';
EyeRadius(i) = 286;
EyeCenter{i} = [315,235];
EyeLeftCameraPosition{i} = [42,0,0];
EyeRightCameraPosition{i} = [42,0,-18];

i=2;
EyeDataFileName{i} = 'Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729\Calibration__subj2__cal2-2024Apr12-104651-PostProc-2024Apr12-144729.txt';
EyeRadius(i) = 286;
EyeCenter{i} = [313,234];
EyeLeftCameraPosition{i} = [42,0,0];
EyeRightCameraPosition{i} = [42,0,-18];

i=3;
EyeDataFileName{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439.txt';
EyeRadius(i) = 257;
EyeCenter{i} = [364,227];
EyeLeftCameraPosition{i} = [42,0,0];
EyeRightCameraPosition{i} = [42,0,-18];

i=4;
EyeDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946.txt';
EyeRadius(i) = 286;
EyeCenter{i} = [352,209];
EyeLeftCameraPosition{i} = [42,0,0];
EyeRightCameraPosition{i} = [42,0,-18];

dataTable = table(EyeDataFileName',EyeRadius',EyeCenter',EyeLeftCameraPosition',EyeRightCameraPosition','VariableNames',{'EyeDataFileName','EyeRadius','EyeCenter','EyeLeftCameraPosition','EyeRightCameraPosition'});
%% 
for i = 1:size(dataTable,1)

    % read data
    openirisData = readtable(dataTable.EyeDataFileName{i});
    
    eyeDataH = openirisData.RightPupilX;
    eyeDataV = openirisData.RightPupilY;
    eyeDataT = openirisData.RightTorsion;
    
    eyeCalibrationModelCenter = dataTable.EyeCenter{i};
    eyeCalibrationModelRad = dataTable.EyeRadius(i);
    
    camposition = dataTable.EyeRightCameraPosition{i};
    calibrationCameraAngle = atand(camposition(3)/camposition(1));
    calibrationCameraX = camposition(1);

    eyeDataH_measured = openirisData.LeftPupilX;
    eyeDataV_measured = openirisData.LeftPupilY;
    eyeDataT_measured = openirisData.LeftTorsion;

    for j = 1:size(eyeDataH,1)
        if eyeDataH(j,:) == 0 && eyeDataV(j,:) == 0, continue, end 
        qCamRefToEyeCoordinates{i}(j,:) = ...
            CalculateEyeRotationQuaternion(eyeDataH(j,:), eyeDataV(j,:), eyeDataT(j,:),...
            eyeCalibrationModelCenter, eyeCalibrationModelRad, calibrationCameraAngle, 0, calibrationCameraX );
        
        rotatedCamRefGaze{i}(j,:) = rotatepoint(qCamRefToEyeCoordinates{i}(j),[1,0,0]);
                
        error_{i}(j,:) =  sqrt((rotatedCamRefGaze{i}(j,2) + eyeCalibrationModelCenter(1) - eyeDataH_measured(j,:) ).^2 ...
            + (rotatedCamRefGaze{i}(j,3) + eyeCalibrationModelCenter(2) - eyeDataV_measured(j,:) ).^2 );

    end
end

















