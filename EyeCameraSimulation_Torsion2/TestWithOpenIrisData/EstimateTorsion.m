function [torsionDeg,gazeDirectionUnitVec] = EstimateTorsion(qCamRefToEyeCoordinates)

% Convert quaternion to rotation matrix
R = quat2rotm(qCamRefToEyeCoordinates);

% Extract the angle of rotation around [1,0,0]
torsion = atan2(R(3,2), R(3,3));

% Convert the angle from radians to degrees (optional)
torsionDeg = rad2deg(torsion);

% find the gaze direction
gazeDirectionUnitVec = rotatepoint(qCamRefToEyeCoordinates,[1,0,0]);

end

