
illuminatorPosition_cm = [200	0	-93.2615316309997];
eyeModelRadius_cm = 1.4;

%simulated gaze directions
hdeg = 10;  vdeg = 10;
gazeDirection_unitVector = SimulatedGazeDirections(hdeg,vdeg);
for i = 1:size(gazeDirection_unitVector,1)
[CR_H_cm(i), CR_V_cm(i)] = CornealReflection(illuminatorPosition_cm, eyeModelRadius_cm,...
    gazeDirection_unitVector(i,:));
end

%plot
figure
plot(gazeDirection_unitVector(:,2),gazeDirection_unitVector(:,3),'ko');
hold on
plot(CR_H_cm, CR_V_cm,'ob')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Functions%%%%%
function simulatedGazeDirections = SimulatedGazeDirections(hdeg,vdeg)

h = tand(hdeg);
v = tand(vdeg);
t(1,:) = [sqrt(1-h^2 - v^2),h,v];
t(2,:) = [sqrt(1-h^2 - v^2),-h,v];
t(3,:) = [sqrt(1-h^2 - v^2),h,-v];
t(4,:) = [sqrt(1-h^2 - v^2),-h,-v];
t(5,:) = [sqrt(1-h^2),h,0];
t(6,:) = [sqrt(1-h^2),-h,0];
t(7,:) = [sqrt(1-v^2),0,v];
t(8,:) = [sqrt(1 - v^2),0,-v];
t(9,:) = [1,0,0];
simulatedGazeDirections = t;
end
