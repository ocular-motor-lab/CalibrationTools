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

