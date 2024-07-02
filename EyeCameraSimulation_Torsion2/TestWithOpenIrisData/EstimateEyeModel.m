function eyeModel = EstimateEyeModel(dataTable,targets,d,eyeLeftCameraPosition,eyeRightCameraPosition)

for session = 1:size(dataTable,1)
    eventTable = CreateEventTable(dataTable.TrialDataFile{session}, dataTable.OriginalRawDataFileName{session},...
        dataTable.EyeDataFileName{session}, targets, d);
    eventTable = eventTable(eventTable.LeftPupilX_mean~=0,:);
    %LefttEye
    trueGazeDirection = cell2mat(eventTable.TrueGazeDirection);

    H = eventTable.LeftPupilX_mean;
    V = eventTable.LeftPupilY_mean;
    T = eventTable.LeftTorsion_mean;
    measuredEyePositions = table(H,V,T,'VariableNames',{'H','V','T'});

    % remove condition 8 - because the target wasn't visible
    measuredEyePositions = measuredEyePositions(eventTable.ConditionNumber~=8,:);
    trueGazeDirection = trueGazeDirection(eventTable.ConditionNumber~=8,:);
    eventTable = eventTable(eventTable.ConditionNumber~=8,:);


    minEyeModelCenter = mean([measuredEyePositions.H, measuredEyePositions.V]);
    minEyeModelRad = max([measuredEyePositions.H; measuredEyePositions.V]) - mean([measuredEyePositions.H; measuredEyePositions.V]);

    costf = @(param) CostF_toEstimateEyeModel(measuredEyePositions,trueGazeDirection,...
        [param(1),param(2)], param(3), eyeLeftCameraPosition);
    %estParam{session}.LeftEye = fmincon( costf,[250,250,300],[],[],[],[],[minEyeModelCenter(1),minEyeModelCenter(2),minEyeModelRad],[1000,1000,1000]);
    estParam{session}.LeftEye = fmincon( costf,[minEyeModelCenter(1),minEyeModelCenter(2),250],[],[],[],[],[10,10,10],[1000,1000,1000]);

    LeftEyeCalibrationModelCenter{session} = [estParam{session}.LeftEye(1),estParam{session}.LeftEye(2)];
    LeftEyeCalibrationModelRad(session) = estParam{session}.LeftEye(3);

    %RightEye
    trueGazeDirection = cell2mat(eventTable.TrueGazeDirection);

    H = eventTable.RightPupilX_mean;
    V = eventTable.RightPupilY_mean;
    T = eventTable.RightTorsion_mean;
    measuredEyePositions = table(H,V,T,'VariableNames',{'H','V','T'});

    minEyeModelCenter = mean([measuredEyePositions.H, measuredEyePositions.V]);
    minEyeModelRad = max([measuredEyePositions.H; measuredEyePositions.V]) - mean([measuredEyePositions.H; measuredEyePositions.V]);

    costf = @(param) CostF_toEstimateEyeModel(measuredEyePositions,trueGazeDirection,...
        [param(1),param(2)], param(3), eyeRightCameraPosition);
    %estParam{session}.RightEye = fmincon( costf,[250,250,300],[],[],[],[],[minEyeModelCenter(1),minEyeModelCenter(2),minEyeModelRad],[1000,1000,1000]);
    estParam{session}.RightEye = fmincon( costf,[minEyeModelCenter(1),minEyeModelCenter(2),250],[],[],[],[],[10,10,10],[1000,1000,1000]);

    RightEyeCalibrationModelCenter{session} = [estParam{session}.RightEye(1),estParam{session}.RightEye(2)];
    RightEyeCalibrationModelRad(session) = estParam{session}.RightEye(3);

end

eyeModel = table(LeftEyeCalibrationModelRad',LeftEyeCalibrationModelCenter',...
    RightEyeCalibrationModelRad',RightEyeCalibrationModelCenter',...
    'VariableNames',{'LeftRad','LeftCenter','RightRad','RightCenter'});

end
