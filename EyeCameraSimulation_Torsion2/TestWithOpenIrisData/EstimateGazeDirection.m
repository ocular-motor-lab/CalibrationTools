function rotatedCamRefGaze = EstimateGazeDirection(measuredEyePositions,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, camposition )
% calculate the quaternions from camera reference to the gaze direction in
% the fixed eye coordinates, and rotate camera reference to get the
% estimate/measured gaze direction vector

    calibrationCameraAngle = atand(camposition(3)/camposition(1));
    calibrationCameraX = camposition(1);

    eyeDataH = measuredEyePositions.H;
    eyeDataV = measuredEyePositions.V;
    eyeDataT = measuredEyePositions.T;

    for i = 1:size(measuredEyePositions,1)
        if eyeDataH(i,:) == 0 && eyeDataV(i,:) == 0, continue, end
        qCamRefToEyeCoordinates(i,:) = ...
            CalculateEyeRotationQuaternion(eyeDataH(i,:), eyeDataV(i,:), eyeDataT(i,:),...
            eyeCalibrationModelCenter, eyeCalibrationModelRad, calibrationCameraAngle, 0, calibrationCameraX );

        rotatedCamRefGaze(i,:) = rotatepoint(qCamRefToEyeCoordinates(i),[1,0,0]);
    end
end