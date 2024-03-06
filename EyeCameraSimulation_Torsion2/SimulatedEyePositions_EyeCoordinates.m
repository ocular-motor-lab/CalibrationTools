function eyeMarks = SimulatedEyePositions_EyeCoordinates(numDots, hdeg, vdeg, torsion, referenceDirection, eyeRadius)
%inputs:
% numDots: scalar, number of dots in hor and ver directions
% hdeg: scalar, total degree in horizontal direction
% vdeg: scalar, total degree in vertical direction
% torsion: scalar, degree of torsion
% referenceDirection: unit vector direction (3d) that the center is pointing at
% eyeRadius: scalar, eye globe radius 

% mark a cross on the eye
if ~exist("torsion"),torsion = 0; end
if ~exist("eyeRadius"),eyeRadius = 1;end
if ~exist("referenceDirection"),referenceDirection = [1,0,0]; end

% make the numDots odds so that the cross will be symmetric relative to
% center
if mod(numDots,2) ~= 1, numDots = numDots + 1;end

%Eye coordinates
%Following the right handed convention the direction
% to the right is positive x,
% to the up is positive y, and
% to the direction of coming out of the xy plane is positive z
c = 1;

%starting with center of the cross pointing to 1,0,0, all the dots will be
% then rotated so the center will be the specified ref direction at the end
eyeMarks(c,:) = [eyeRadius,0,0];
c = c + 1;

h_rotationAngle = hdeg / numDots;
v_rotationAngle = vdeg / numDots;

for i = 1:(numDots-1)/2
    %rotation along y axis creates horizontal movements
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), h_rotationAngle*i, [0,1,0]);
    c = c + 1;
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), h_rotationAngle*i, [0,-1,0]);
    c = c + 1;
    %rotation along z axis creates vertical movements
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), v_rotationAngle*i, [0,0,1]);
    c = c + 1;
    eyeMarks(c,:) = RotateAlongAxis(eyeMarks(1,:), v_rotationAngle*i, [0,0,-1]);
    c = c + 1;
end

%rotation along x axis creates torsional movements
if torsion~=0
    for i = 1:(c-1)
        eyeMarks(i,:) = RotateAlongAxis(eyeMarks(i,:), torsion, [1,0,0]);
    end
end

%rotating the dots so the center is toward the specified ref direction
if sum( referenceDirection ~= [1,0,0] ) >= 1
    % find the angle and required rotational axis
    % make them unit vector
    referenceDirection = referenceDirection./sqrt(sum(referenceDirection.^2));
    tempCenter = eyeMarks(1,:)./sqrt(sum(eyeMarks(1,:).^2));

    % calculate the angle between tempCenter and referenceDirection
    angleDeg = acosd( dot(tempCenter,referenceDirection) );

    % axis of rotation
    rotAxis = cross(tempCenter,referenceDirection);

    % apply the rotation
    for i = 1:(c-1)
        eyeMarks(i,:) = RotateAlongAxis(eyeMarks(i,:), angleDeg, rotAxis);

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