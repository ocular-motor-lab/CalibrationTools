function err_rmse = CostF_toEstimateEyeModel(measuredEyePositions,trueGazeDirection,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, camposition)

rotatedCamRefGaze = EstimateGazeDirection(measuredEyePositions,...
    eyeCalibrationModelCenter, eyeCalibrationModelRad, camposition );

err = sqrt( sum((rotatedCamRefGaze - trueGazeDirection).^2,2) );
err_rmse = sqrt( mean(err.^2));

end