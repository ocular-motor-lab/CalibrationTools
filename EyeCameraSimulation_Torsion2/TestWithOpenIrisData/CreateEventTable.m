function eventTable = CreateEventTable(trialDataFile, originalRawDataFileName, eyeDataFileName, targets, display2EyeDistance)
% read the event table
eventTable = ReadEventFile(trialDataFile, originalRawDataFileName);

% add the eye data to the table
eventTable = EyePositionCalDots(eyeDataFileName, eventTable);

% estimate the true gaze direction
for i = 1:length(targets)
    trueGazeDirection{i} = TrueGazeDirection(targets{i}(1),targets{i}(2),display2EyeDistance);
end

% add the gaze direction to the event table
for i = 1:2:size(eventTable,1)
    eventTable.TrueGazeDirection{i} = trueGazeDirection{eventTable.ConditionNumber(i)};
end


end
