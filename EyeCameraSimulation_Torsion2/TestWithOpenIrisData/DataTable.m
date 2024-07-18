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
eyeLeftCameraPosition = [42,0,-20];
eyeRightCameraPosition = [42,0,0];

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
TrialDataFile{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal-2024Apr12-104031-PostProc-2024Apr12-143439\Calibration__subj1__cal-2024Apr12-104031.txt';

i=4;
EyeDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946.txt';
TrialDataFile{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152-events.txt';
OriginalRawDataFileName{i} = 'Calibration__subj1__cal2-2024Apr12-104152-PostProc-2024Apr12-143946\Calibration__subj1__cal2-2024Apr12-104152.txt';

dataTable = table(EyeDataFileName',TrialDataFile',OriginalRawDataFileName','VariableNames',{'EyeDataFileName','TrialDataFile','OriginalRawDataFileName'});
