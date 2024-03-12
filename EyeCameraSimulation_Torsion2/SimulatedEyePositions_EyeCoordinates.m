function eyeMarks = SimulatedEyePositions_EyeCoordinates(numDots, hdeg, vdeg, torsion, gazeDirection, eyeRadius)
%inputs:
% numDots: scalar, number of dots in hor and ver directions
% hdeg: scalar, total degree in horizontal direction
% vdeg: scalar, total degree in vertical direction
% torsion: scalar, degree of torsion
% gazeDirection: unit vector direction (3d) toward the gaze direction
% eyeRadius: scalar, eye globe radius 

% mark a cross on the eye
if ~exist("torsion"),torsion = 0; end
if ~exist("eyeRadius"),eyeRadius = 1;end
if ~exist("gazeDirection"),gazeDirection = [1,0,0]; end

% make the numDots odds so that the cross will be symmetric relative to
% center
if mod(numDots,2) ~= 1, numDots = numDots + 1;end

%Eye coordinates
%Following the right handed convention the direction
% to the right is positive x,
% to the up is positive z, and
% to the direction of coming out of the xy plane is positive z
c = 1;

%starting with center of the cross pointing to 1,0,0, all the dots will be
% then rotated so the center will be the specified ref direction at the end
eyeMarks(c,:) = [eyeRadius,0,0];
c = c + 1;

h_rotationAngle = hdeg / numDots;
v_rotationAngle = vdeg / numDots;

for i = 1:(numDots-1)/2
    %rotation along y axis 
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), h_rotationAngle*i, [0,1,0]);
    c = c + 1;
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), h_rotationAngle*i, [0,-1,0]);
    c = c + 1;
    %rotation along z axis 
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), v_rotationAngle*i, [0,0,1]);
    c = c + 1;
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), v_rotationAngle*i, [0,0,-1]);
    c = c + 1;
end



%rotating the dots so the center is toward the specified ref direction
if sum( gazeDirection ~= [1,0,0] ) >= 1
    q = CombineGazeDirectionAndTorsionQuaternion(torsion, gazeDirection);
    % apply the rotation
    for i = 1:(c-1)
        eyeMarks(i,:) = rotatepoint(q,eyeMarks(i,:));
    end
else
    % just apply torsion
    %rotation along x axis creates torsional movements
    if torsion~=0
        for i = 1:(c-1)
            eyeMarks(i,:) = RotateAlongAxis(eyeMarks(i,:), torsion, [1,0,0]);
        end
    end
end

% Done!
end

function rotatedPoint = RotateAlongAxis(input, angleDeg, rotAxis)
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

function q = CombineGazeDirectionAndTorsionQuaternion(torsion, gazeDirection)
%% torsion
%axis of rotation
rotAxis = [1,0,0];
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(torsion);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qTorsion = quaternion(q1,q2,q3,q4);

%% gaze direction
% find the angle and required rotational axis
% make them unit vector
gazeDirection = gazeDirection./sqrt(sum(gazeDirection.^2));
tempCenter = [1,0,0];

% calculate the angle between tempCenter and referenceDirection
angleDeg = acosd( dot(tempCenter,gazeDirection) );

% axis of rotation
rotAxis = cross(tempCenter,gazeDirection);
w = rotAxis./sqrt(sum(rotAxis.^2));

%anlge of rotaiont
alpha = deg2rad(angleDeg);

%the quaternion
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

qGazeDirection = quaternion(q1,q2,q3,q4);

%% combining two quaternions
q = qGazeDirection*qTorsion;

end