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
TrialDataFile{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031-events';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031.txt';

i=4;
EyeDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946.txt';
TrialDataFile{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152.txt';

dataTable = table(EyeDataFileName',TrialDataFile',OriginalRawDataFileName','VariableNames',{'EyeDataFileName','TrialDataFile','OriginalRawDataFileName'});
%%

for session = 1:1%size(dataTable,1)
    eventTable = CreateEventTable(dataTable.TrialDataFile{i}, dataTable.OriginalRawDataFileName{i},...
        dataTable.EyeDataFileName{i}, targets, d);


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
%     eyeCalibrationModelCenter = dataTable.EyeCenter{i};
%     eyeCalibrationModelRad = dataTable.EyeRadius(i);
%
%     camposition = dataTable.EyeRightCameraPosition{i};
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
%position
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

    eventTable.RightPupilX_mean(i) = mean(eyeData.LeftPupilX(indx));
    eventTable.RightPupilX_median(i) = median(eyeData.LeftPupilX(indx));
    eventTable.RightPupilX_std(i) = std(eyeData.LeftPupilX(indx));

    eventTable.RightPupilY_mean(i) = mean(eyeData.LeftPupilY(indx));
    eventTable.RightPupilY_median(i) = median(eyeData.LeftPupilY(indx));
    eventTable.RightPupilY_std(i) = std(eyeData.LeftPupilY(indx));

    eventTable.RightTorsion_mean(i) = mean(eyeData.RightTorsion(indx));
    eventTable.RightTorsion_median(i) = median(eyeData.RightTorsion(indx));
    eventTable.RightTorsion_std(i) = std(eyeData.RightTorsion(indx));

end


end


function trueGazeDirection = TrueGazeDirection(dotDegreeH,dotDegreeV, display2EyeDistance)
x = display2EyeDistance;
y = display2EyeDistance*tand(dotDegreeH);
z = display2EyeDistance*tand(dotDegreeV);

d = sqrt(x^2 + y^2 + z^2);%make it unit vector

trueGazeDirection = [x,y,z]./d;

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








