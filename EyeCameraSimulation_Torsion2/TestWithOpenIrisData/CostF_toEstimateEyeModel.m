function err_ = CostF_toEstimateEyeModel(measuredEyePositions,trueGazeDirection,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, camposition)

rotatedCamRefGaze = EstimateGazeDirection(measuredEyePositions,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, camposition );

err = sqrt( sum((rotatedCamRefGaze - trueGazeDirection).^2,2) );
err_ = sqrt( sum (err));

end