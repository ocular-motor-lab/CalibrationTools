function camEyeImage = SimulatedEyePositions_CamCoordinates(eyeMarks, cam_x, camAlpha, camBeta, pixPerCm, eyeGlobeCenterPx)
%inputs:
% eyeMarks: nx3 matrix, output of SimulatedEyePositions_EyeCoordinates
% cam_x: scalar, distance of camera in x direction in eye coordinates
% camAlpha: scalar, the angle (degree) between the camera direction and x axis of eye coordinates
% camBeta: scalar, the angle (degree) between the projection of camera
% direction in yz plane and z direction in eye coordinates
% eyeGlobeCenter: 1x2 array, the pixel offset in the image of the eye 

% cam location in eye coordinates
cam_z = tand(camAlpha)*cam_x;
cam_y = tand(camBeta)*cam_x;

camPosition = [cam_x, cam_y, cam_z];

% camera x axis positive direction will be camPosition 
% to the zero position of eye-coordinates
norm_xcamcor = -camPosition./sqrt(sum(camPosition.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor and norm_xeyecor
% angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );%CHANGE TO ATAN2 
% angleDeg = asind( sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)) );
angleDeg = atan2d(sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)),dot(norm_xeyecor,norm_xcamcor));

% axis of rotation
rotAxis = cross(norm_xeyecor,norm_xcamcor);

% demo
plotRotatedCoordinates_Demo(angleDeg, rotAxis,camPosition,eyeMarks)

% apply the rotation, inverse the y and z
for i = 1:size(eyeMarks,1)
    % change of ref frame frome eye to camera (still in 3D space)
    camEyeMarks(i,:) = RotateFrameAlongAxis(eyeMarks(i,:), angleDeg, rotAxis);

    % projection to the camera image (from cm to pix)
    camEyeMarks(i,2:3) = camEyeMarks(i,2:3)*pixPerCm;
end

%apply center of the eye globe offset
camEyeImage = camEyeMarks(:,2:3) + eyeGlobeCenterPx;  

end


function rotatedPoint = RotateFrameAlongAxis(input, angleDeg, rotAxis)
%axis of rotation
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

q = quaternion(q1,q2,q3,q4);

%apply the quaternion
rotatedPoint = rotateframe(q,input);

end

function rotatedPoint = RotatePointsAlongAxis(input, angleDeg, rotAxis)
%axis of rotation
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

q = quaternion(q1,q2,q3,q4);

%apply the quaternion
rotatedPoint = rotatepoint(q,input);

end

function plotRotatedCoordinates_Demo(angleDeg, rotAxis, camPosition, eyeMarks)
eyeCoor = [1,0,0;0,1,0;0,0,1];
camPosition = [0,0,0];
camCoor(1,:) = camPosition + RotatePointsAlongAxis(eyeCoor(1,:), angleDeg, rotAxis);
camCoor(2,:) = camPosition + RotatePointsAlongAxis(eyeCoor(2,:), angleDeg, rotAxis);
camCoor(3,:) = camPosition + RotatePointsAlongAxis(eyeCoor(3,:), angleDeg, rotAxis);

figure,
plot3([0,eyeCoor(1,1)],[0,eyeCoor(1,2)],[0,eyeCoor(1,3)],'-k'),hold on
plot3([0,eyeCoor(2,1)],[0,eyeCoor(2,2)],[0,eyeCoor(2,3)],'-k'),hold on
plot3([0,eyeCoor(3,1)],[0,eyeCoor(3,2)],[0,eyeCoor(3,3)],'-k'),hold on

text(eyeCoor(1,1),eyeCoor(1,2),eyeCoor(1,3),['   ' 'eye x'],'HorizontalAlignment','left','FontSize',8);
text(eyeCoor(2,1),eyeCoor(2,2),eyeCoor(2,3),['   ' 'eye y'],'HorizontalAlignment','left','FontSize',8);
text(eyeCoor(3,1),eyeCoor(3,2),eyeCoor(3,3),['   ' 'eye z'],'HorizontalAlignment','left','FontSize',8);

plot3([camPosition(1),camCoor(1,1)],[camPosition(2),camCoor(1,2)],[camPosition(3),camCoor(1,3)],'-b'),hold on
plot3([camPosition(1),camCoor(2,1)],[camPosition(2),camCoor(2,2)],[camPosition(3),camCoor(2,3)],'-b'),hold on
plot3([camPosition(1),camCoor(3,1)],[camPosition(2),camCoor(3,2)],[camPosition(3),camCoor(3,3)],'-b'),hold on

text(camCoor(1,1),camCoor(1,2),camCoor(1,3),['   ' 'cam x'],'HorizontalAlignment','left','FontSize',8,'Color','b');
text(camCoor(2,1),camCoor(2,2),camCoor(2,3),['   ' 'cam y'],'HorizontalAlignment','left','FontSize',8,'Color','b');
text(camCoor(3,1),camCoor(3,2),camCoor(3,3),['   ' 'cam z'],'HorizontalAlignment','left','FontSize',8,'Color','b');

hold on

plot3(eyeMarks(:,1),eyeMarks(:,2),eyeMarks(:,3),'o')

axis equal

end

