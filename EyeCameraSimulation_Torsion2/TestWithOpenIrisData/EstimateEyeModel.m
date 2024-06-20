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

function [eventTable] = ReadEventFile(eventFilename,originalRawDataFileName)
% reading event file and put it in to a table
text = fileread(eventFilename);

pat = 'Time\=(?<Time>[\w\.\-\:]+)\s+FrameNumber\=(?<FrameNumber>\w+)\s+Message\=(?<Message>.+?)\sData=(?<Data>\w*)';
r=regexp(text, pat, 'names');
t = struct2table(r);
t.FrameNumber = str2double(t.FrameNumber);

tt = table();
c=1;
for i=1:height(t)
    m = t.Message{i};
    %r=regexp(m, '(?<TimeStamp>[\w\.]+)\s(?<Event>\w+)\s(?<TrialNumber>\w+)\s(?<ConditionNumber>\w+)', 'names');
    r = regexp(m,'(?<TimeStamp>[\w\.])+\s(?<Event>[\w+])+\s*[trial=(?<TrialNumber>[\w+])+,\s*condition=(?<ConditionNumber>[\w+])','names');
    if(~isempty(r))
        r.TimeStamp = str2double(r.TimeStamp);
        r.Event = categorical(cellstr(r.Event));
        r.TrialNumber = str2double(r.TrialNumber);
        r.ConditionNumber = str2double(r.ConditionNumber);
        tt = vertcat(tt, struct2table(r));
        index_(c)=i;c=c+1;
    end
end

eventTable = horzcat(t(index_,:),tt);

% update the frame numbers (the postproc frame numbers starts from 0)
if(exist('originalRawDataFileName','var'))
    o = readtable(originalRawDataFileName);
    eventTable.FrameIndex = eventTable.FrameNumber - o.LeftFrameNumber(1)+1; %plus one to start from one like matlab index
end

end

function eventTable = EyePositionCalDots(eyeDataFileName,eventTable)
%update the event data table, with eye positions in pixels for each
%position ( pupil - CR )
eyeData = readtable(eyeDataFileName);
for i = 1:2:size(eventTable,1)
    indx = eventTable.FrameIndex(i):eventTable.FrameIndex(i+1);
    eventTable.LeftPupilX_mean(i) = mean(eyeData.LeftPupilX(indx));
    eventTable.LeftPupilX_median(i) = median(eyeData.LeftPupilX(indx));
    eventTable.LeftPupilX_std(i) = std(eyeData.LeftPupilX(indx));

    eventTable.LeftPupilY_mean(i) = mean(eyeData.LeftPupilY(indx));
    eventTable.LeftPupilY_median(i) = median(eyeData.LeftPupilY(indx));
    eventTable.LeftPupilY_std(i) = std(eyeData.LeftPupilY(indx));

    eventTable.LeftTorsion_mean(i) = mean(eyeData.LeftTorsion(indx));
    eventTable.LeftTorsion_median(i) = median(eyeData.LeftTorsion(indx));
    eventTable.LeftTorsion_std(i) = std(eyeData.LeftTorsion(indx));

    eventTable.RightPupilX_mean(i) = mean(eyeData.RightPupilX(indx));
    eventTable.RightPupilX_median(i) = median(eyeData.RightPupilX(indx));
    eventTable.RightPupilX_std(i) = std(eyeData.RightPupilX(indx));

    eventTable.RightPupilY_mean(i) = mean(eyeData.RightPupilY(indx));
    eventTable.RightPupilY_median(i) = median(eyeData.RightPupilY(indx));
    eventTable.RightPupilY_std(i) = std(eyeData.RightPupilY(indx));

    eventTable.RightTorsion_mean(i) = mean(eyeData.RightTorsion(indx));
    eventTable.RightTorsion_median(i) = median(eyeData.RightTorsion(indx));
    eventTable.RightTorsion_std(i) = std(eyeData.RightTorsion(indx));
%Pupil-CR (i couldn't make it work)
%     eventTable.LeftPupilX_mean(i) = mean(eyeData.LeftPupilX(indx) - eyeData.LeftCR1X(indx));
%     eventTable.LeftPupilX_median(i) = median(eyeData.LeftPupilX(indx)-eyeData.LeftCR1X(indx));
%     eventTable.LeftPupilX_std(i) = std(eyeData.LeftPupilX(indx)-eyeData.LeftCR1X(indx));
% 
%     eventTable.LeftPupilY_mean(i) = mean(eyeData.LeftPupilY(indx)-eyeData.LeftCR1Y(indx));
%     eventTable.LeftPupilY_median(i) = median(eyeData.LeftPupilY(indx)-eyeData.LeftCR1Y(indx));
%     eventTable.LeftPupilY_std(i) = std(eyeData.LeftPupilY(indx)-eyeData.LeftCR1Y(indx));
% 
%     eventTable.LeftTorsion_mean(i) = mean(eyeData.LeftTorsion(indx));
%     eventTable.LeftTorsion_median(i) = median(eyeData.LeftTorsion(indx));
%     eventTable.LeftTorsion_std(i) = std(eyeData.LeftTorsion(indx));
% 
%     eventTable.RightPupilX_mean(i) = mean(eyeData.RightPupilX(indx)-eyeData.RightCR1X(indx));
%     eventTable.RightPupilX_median(i) = median(eyeData.RightPupilX(indx)-eyeData.RightCR1X(indx));
%     eventTable.RightPupilX_std(i) = std(eyeData.RightPupilX(indx)-eyeData.RightCR1X(indx));
% 
%     eventTable.RightPupilY_mean(i) = mean(eyeData.RightPupilY(indx)-eyeData.RightCR1Y(indx));
%     eventTable.RightPupilY_median(i) = median(eyeData.RightPupilY(indx)-eyeData.RightCR1Y(indx));
%     eventTable.RightPupilY_std(i) = std(eyeData.RightPupilY(indx)-eyeData.RightCR1Y(indx));
% 
%     eventTable.RightTorsion_mean(i) = mean(eyeData.RightTorsion(indx));
%     eventTable.RightTorsion_median(i) = median(eyeData.RightTorsion(indx));
%     eventTable.RightTorsion_std(i) = std(eyeData.RightTorsion(indx));

end


end


function trueGazeDirection = TrueGazeDirection(dotDegreeH,dotDegreeV, display2EyeDistance)
x = display2EyeDistance;
y = display2EyeDistance*tand(dotDegreeH);
z = display2EyeDistance*tand(dotDegreeV);

d = sqrt(x^2 + y^2 + z^2);%make it unit vector

trueGazeDirection = [x,-y,z]./d;

end

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
