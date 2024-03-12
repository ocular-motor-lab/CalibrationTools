eyeCoor = [1,0,0;0,1,0;0,0,1];

figure,
plot3([0,eyeCoor(1,1)],[0,eyeCoor(1,2)],[0,eyeCoor(1,3)],'-k'),hold on
plot3([0,eyeCoor(2,1)],[0,eyeCoor(2,2)],[0,eyeCoor(2,3)],'-k'),hold on
plot3([0,eyeCoor(3,1)],[0,eyeCoor(3,2)],[0,eyeCoor(3,3)],'-k'),hold on
text(eyeCoor(1,1),eyeCoor(1,2),eyeCoor(1,3),['   ' 'eye x'],'HorizontalAlignment','left','FontSize',8);
text(eyeCoor(2,1),eyeCoor(2,2),eyeCoor(2,3),['   ' 'eye y'],'HorizontalAlignment','left','FontSize',8);
text(eyeCoor(3,1),eyeCoor(3,2),eyeCoor(3,3),['   ' 'eye z'],'HorizontalAlignment','left','FontSize',8);
hold on, plot3(eyeMarks(:,1),eyeMarks(:,2),eyeMarks(:,3),'o')