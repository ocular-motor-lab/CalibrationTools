function [camEyeImage qCameraToEye] = SimulatedEyePositions_CamCoordinates(eyeMarks, cam_x, camAlpha, camBeta, pixPerCm, eyeGlobeCenterPx)
%inputs:
% eyeMarks: nx3 matrix, output of SimulatedEyePositions_EyeCoordinates
% cam_x: scalar, distance of camera in x direction in eye coordinates
% camAlpha: scalar, the angle (degree) between the camera direction and x axis of eye coordinates
% camBeta: scalar, the angle (degree) between the projection of camera
% direction in yz plane and z direction in eye coordinates
% eyeGlobeCenter: 1x2 array, the pixel offset in the image of the eye 

% cam location in eye coordinates
cam_yz = tand(camAlpha)*cam_x;
cam_z = cosd(camBeta)*cam_yz;
cam_y = sind(camBeta)*cam_yz;

camPosition = [cam_x, cam_y, cam_z];

% camera x axis positive direction will be camPosition 
% to the zero position of eye-coordinates
norm_xcamcor = -camPosition./sqrt(sum(camPosition.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor and norm_xeyecor
angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );

% axis of rotation
rotAxis = cross(norm_xeyecor,norm_xcamcor);

% apply the rotation, inverse the y and z
for i = 1:size(eyeMarks,1)
    % change of ref frame frome eye to camera (still in 3D space)
    [camEyeMarks(i,:), qCameraToEye] = RotateFrameAlongAxis(eyeMarks(i,:), angleDeg, rotAxis);

    % projection to the camera image (from cm to pix)
    camEyeMarks(i,2:3) = -camEyeMarks(i,2:3)*pixPerCm;
end

%apply center of the eye globe offset
camEyeImage = camEyeMarks(:,2:3) + eyeGlobeCenterPx;  

end


function [rotatedPoint q] = RotateFrameAlongAxis(input, angleDeg, rotAxis)
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



