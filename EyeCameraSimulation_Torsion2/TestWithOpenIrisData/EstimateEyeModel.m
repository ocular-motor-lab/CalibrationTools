function EstimateEyeModel(estimatedPositions, truePositions)
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