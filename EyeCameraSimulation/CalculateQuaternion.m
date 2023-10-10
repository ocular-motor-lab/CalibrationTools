function q = CalculateQuaternion(a, b)
% generate the quaternion for rotation from 3d vector "a" to "b"
% make unit vectors
a1 = a./sqrt(sum(a.^2));
b1 = b./sqrt(sum(b.^2));

% calculate the angle between a and b
alpha = acos( dot(a1,b1) );

% calculate the rotation axis which is perpendicular to the plane of two
% vectors
w = cross(a1,b1);
w1 = w./sqrt(sum(w.^2));

%generate the quaternion
q1 = cos(alpha/2);
q2 = w1(1) * sin(alpha/2);
q3 = w1(2) * sin(alpha/2);
q4 = w1(3) * sin(alpha/2);

q = quaternion(q1,q2,q3,q4);

end