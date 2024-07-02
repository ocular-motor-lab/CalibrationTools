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

