function [CR_H_cm, CR_V_cm] = CornealReflection(illuminatorPosition_cm, eyeModelRadius_cm,...
    gazeDirection_unitVector)

rotatedGazeDir = GazeDirBasedOnIlluminatorPosition...
    (illuminatorPosition_cm,gazeDirection_unitVector);

h = atan2(rotatedGazeDir(2),rotatedGazeDir(1));
v = atan2(rotatedGazeDir(3),rotatedGazeDir(1));

%calculate the distance between the eye/cornea and the illuminator at the gaze
%direction
d = sqrt(sum(illuminatorPosition_cm.^2));
d_h = eyeModelRadius_cm^2 + (eyeModelRadius_cm + d).^2 -2*eyeModelRadius_cm*(eyeModelRadius_cm + d)*cos(h);
d_v = eyeModelRadius_cm^2 + (eyeModelRadius_cm + d).^2 -2*eyeModelRadius_cm*(eyeModelRadius_cm + d)*cos(v);

d_illuminator = sqrt(d_h^2 + d_v^2);

% calculate the distance of the image
f = - eyeModelRadius_cm/2;%convex mirror
d_imageCR = 1/ (1/f - 1/d_illuminator);

% calculate the h and v of the cr
CR_H_cm = -(illuminatorPosition_cm(2)/d_illuminator ) * d_imageCR;
CR_V_cm = -(illuminatorPosition_cm(3)/d_illuminator ) * d_imageCR;


end

function rotatedGazeDir = GazeDirBasedOnIlluminatorPosition(illuminatorPosition_cm,gazeDirection_unitVector)

norm_x = illuminatorPosition_cm./sqrt(sum(illuminatorPosition_cm.^2)); 
norm_xeyecor = [1,0,0];

% calculate the angle between norm_xcamcor to norm_xeyecor
% angleDeg = acosd( dot(norm_xeyecor,norm_xcamcor) );
% angleDeg = asind( sqrt(sum(cross(norm_xeyecor,norm_xcamcor).^2)) );
% the acos and asin doesn't work for all test cases and it is better to use
% the atan
angleDeg = atan2d( sqrt(sum(cross(norm_x,norm_xeyecor).^2)),dot(norm_x,norm_xeyecor) );

% axis of rotation
if angleDeg == 180 || angleDeg == 0 
    rotAxis = [0 1 0];
else
    rotAxis = cross(norm_x,norm_xeyecor);
end

w = rotAxis./sqrt(sum(rotAxis.^2));
% this is negative to have the gaze direction in the eye looking at the
% center of the display.
alpha = - deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qIlluminator2Eye = quaternion(q1,q2,q3,q4);

rotatedGazeDir = rotatepoint(qIlluminator2Eye,gazeDirection_unitVector);

end