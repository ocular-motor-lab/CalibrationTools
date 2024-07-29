function [HVT,gazeDirectionUnitVec,rv] = Quaternion2HVT(qCamRefToEyeCoordinates)

M = quat2rotm(qCamRefToEyeCoordinates);
rv = rotvec(qCamRefToEyeCoordinates);
HVT = RotMat2Fick(M);

% find the gaze direction
gazeDirectionUnitVec = rotatepoint(qCamRefToEyeCoordinates,[1,0,0]);

end

function HVT = RotMat2Fick(M)
% from Geometry3D.m
r31 = M(3,1);
r21 = M(2,1);
r32 = M(3,2);
r11 = M(1,1);
r33 = M(3,3);
% HVT(2) = - asin(r31);
% HVT(1) = asin(r21/cos(HVT(2)));
% HVT(3) = asin(r32/cos(HVT(2)));

HVT(1) = atan2(r21,r11);
HVT(2) = asin(-r31);
HVT(3) = atan2(r32,r33);

HVT = rad2deg(HVT);

if abs(HVT(1)-360)<abs(HVT(1))
    HVT(1) = 360 - HVT(1);
end
if abs(HVT(2)-360)<abs(HVT(2))
    HVT(2) = 360 - HVT(2);
end
if abs(HVT(3)-360)<abs(HVT(3))
    HVT(3) = 360 - HVT(3);
end

end


function HVT = RotMat2Helm(M)
% from Geometry3D.m
r21 = M(2,1);
r31 = M(3,1);
r23 = M(2,3);

HVT(1) =  asin(r21);
HVT(2) =  -asin(r31/cos(HVT(1)));
HVT(3) = -asin(r23/cos(HVT(1)));

HVT = rad2deg(HVT);

if abs(HVT(1)-360)<abs(HVT(1))
    HVT(1) = 360 - HVT(1);
end
if abs(HVT(2)-360)<abs(HVT(2))
    HVT(2) = 360 - HVT(2);
end
if abs(HVT(3)-360)<abs(HVT(3))
    HVT(3) = 360 - HVT(3);
end
end