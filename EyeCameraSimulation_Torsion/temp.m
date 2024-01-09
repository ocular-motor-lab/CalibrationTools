%% init param
% testing adding a rotation around the ref axis
distanceDispEye = 85;
rows = 9;
columns = 9;
dispDots = GenerateDisplayDots(distanceDispEye,rows,columns,10,7.5);

figure,
plot_dispDot(dispDots)

% apply torsion
tor_dispDots = ApplyTorsion(dispDots, 30);
hold on
plot_dispDot(tor_dispDots,'r')
% create vectors from eye to the dot with eye radius length
eyeRadiusPix = 280; %cm, arbitrary number
eyeGlobePositionPix = [350, 350];


camAlpha = -25;%0.00000001;% the angle to positive x direction in degree
camBeta = 0; % the angle of the projection on y-z plane and z in degree
%camZ = -20;
%camY = 0;

referenceOrientation = [1,0,0];

%% camera view
% apply the transformation from display to camera plane to simulate the
% camera view of the eye positions looking at the display dots
for i = 1:length(dispDots)
    cameraDots{i} = Display2Cam_simulation(tor_dispDots{i}, referenceOrientation, camAlpha, camBeta, eyeGlobePositionPix, eyeRadiusPix);
end

figure
plot_dispDot(cameraDots,'g')

%% calculate torsion on camera view
camView_torsion = CamViewTorsion(cameraDots, eyeGlobePositionPix, eyeRadiusPix);

%% 
figure,
for i = 1:length(camView_torsion)
plot(dispDots{i}(1,2),camView_torsion(i,1),'bo')
hold on
plot(dispDots{i}(1,2),camView_torsion(i,2),'ro')
end
legend({'vertical line','horizontal line'})

ylabel('Measured Torsion in Camera View (degree)')
xlabel('Displayed Dot Horizontal Position (cm)')
%% functions
function plot_dispDot(input,color)
if ~exist('color','var'), color = 'b';end

for i = 1:length(input)
    %plot3(input{i}(:,1),input{i}(:,2),input{i}(:,3),'o','Color',color),hold on

    if size(input{1},2) == 3
        plot(input{i}(:,2),input{i}(:,3),'o','Color',color),hold on
    else
        plot(input{i}(:,1),input{i}(:,2),'o','Color',color),hold on
    end
end

end

function torDots = ApplyTorsion(dispDots, torsion_degree)
for i = 1:length(dispDots)
    % the first element is the center dot on the cross
    q = FindQuaternionTorsion(dispDots{i}(1,:), torsion_degree);
    % apply this quaternion to the other member of the cross
    torDots{i}(:,:) = rotatepoint(q,dispDots{i});
end

end

function q = FindQuaternionTorsion(one_dispDot, torsion_degree)
alpha = deg2rad(torsion_degree);
w = one_dispDot;
q1 = cos(alpha/2);
q2 = w(1) * sin(alpha/2);
q3 = w(2) * sin(alpha/2);
q4 = w(3) * sin(alpha/2);

%normalize the quaternion
n = sqrt(q1^2 + q2^2 + q3^2 + q4^2);

q = quaternion(q1/n, q2/n, q3/n, q4/n);
end

function camView_torsion = CamViewTorsion(cameraDots, eyeGlobePositionPix, eyeRadiusPix)

for i = 1:length(cameraDots)
    % quaternion defining the rotation of the eyeball (ignoring torsion) just the center of the pupil
    xC = cameraDots{i}(1,1) - eyeGlobePositionPix(1);
    yC = cameraDots{i}(1,2) - eyeGlobePositionPix(2);

    % First get the polar angle of the rotation. As the direction angle the eye moves from eye model center
    % to iris center.
    angle = atan2(yC, xC);

    % Then, get the eccentricity from the length of the vector in pixels to the angle that moves the eye that far
    ecc = asin(sqrt(yC * yC + xC * xC) / eyeRadiusPix);


    % Finally get the quaternion that defines that rotation. This is a rotation without torsion in a reference frame perpendicular to the camera
    q1 = cos(ecc / 2);
    q2 = -sin(angle) * sin(ecc / 2);
    q3 = cos(angle) * sin(ecc / 2);
    q4 = 0;

    %q{i} = quaternion(q1,q2,q3,q4);
    %centeredDot{i} = rotatepoint(q{i},cameraDots{i});
    x = cameraDots{i}(:,1);
    y = cameraDots{i}(:,2);

    rr = sqrt(x .* x + y .* y) / eyeRadiusPix;

    t2 = q1 * q2;
    t3 = q1 * q3;
    t4 = q1 * q4;
    t5 = -q2 * q2;
    t6 = q2 * q3;
    t7 = q2 * q4;
    t8 = -q3 * q3;
    t9 = q3 * q4;
    t10 = -q4 * q4;
    
    z = sqrt(1-rr.^2).*eyeRadiusPix;
    x = 2.0 * ((t8 + t10) * x + (t6 - t4) * y + (t3 + t7) * z) + x;
    y = 2.0 * ((t4 + t6) * x + (t5 + t10) * y + (t9 - t2) * z) + y;
    
    centeredDot{i}(:,1:2) = [x y];
    
    % vertical line
    n = (size(centeredDot{i},1) - 1)/2; % the first element is center of the cross
    deltaX = real( centeredDot{i}(n+1,1) - centeredDot{i}(2,1) );
    deltaY = real( centeredDot{i}(n+1,1) - centeredDot{i}(2,2) );
    t1 = 90 -  rad2deg( atan2(deltaY,deltaX) );

    % horizontal line
    deltaX = real( centeredDot{i}(n*2+1,1) - centeredDot{i}(n+2,1) );
    deltaY = real( centeredDot{i}(n*2+1,2) - centeredDot{i}(n+2,2) );  
    t2 = rad2deg( atan2(deltaY,deltaX) );


    camView_torsion(i,1) = t1;
    camView_torsion(i,2) = t2;
end

end

