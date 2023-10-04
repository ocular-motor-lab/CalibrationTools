%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Goal: estimate the pupil location on the camera image based on the 
% diplayed dot while the camera looking at the eye from down on the table
% at an angle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
%% Parameters and assumptions
% distance between display and eye
distanceDispEye = 85; %cm, arbitrary number

% selected coordinate system: center of the eyeball is 0,0,0, up is positive z, right is
% positive y, toward display is positive x

% the coordinates of the displayed dots
rows = 9;
columns = 9;
[dots, dots_c] = GenerateDisplayDots(rows,columns,20,10); 

dispDots_c = zeros(size(dots_c,1), 3); %3D
dispDots_c(:,1) = ones(1,size(dots_c,1)) * distanceDispEye;
dispDots_c(:,2:3) = dots_c;

dispDots = zeros(size(dots,1), 3); %3D
dispDots(:,1) = ones(1,size(dots,1)) * distanceDispEye;
dispDots(:,2:3) = dots;

% create vectors from eye to the dot with eye radius length
eyeRadius = 1.3; %cm, arbitrary number
normDispDots = dispDots_c ./ sqrt(sum(dispDots_c.^2,2));
eyeDispDots = normDispDots * eyeRadius;

% assuming the camera is outside of the display plane
% camera location relative to eye - cm
camX = 45;
camY = 0;
camZ = -20;
camLocation = [camX,camY,camZ];

% quaternion between x axis from the eye toward display and new x' toward camera
q = CalculateQuaternion([distanceDispEye,0,0], camLocation);
camEyeDispDots = rotateframe(q,eyeDispDots);

% figures
figure
subplot(2,2,1)
plot(dispDots_c(:,2),dispDots_c(:,3),'.','MarkerSize',2)
xlabel('Horizontal (cm)')
ylabel('Vertical (cm)')
title('Displayed Dots Position')
ylim([-82,82])
xlim([-82,82])

subplot(2,2,3)
plot(eyeDispDots(:,2),eyeDispDots(:,3),'.','MarkerSize',2)
xlabel('Horizontal (cm)')
ylabel('Vertical (cm)')
title('Eye Positions Looking at Displayed Dots'),subtitle('Camera at the eye level')
ylim([-1,1])
xlim([-1,1])

subplot(2,2,4)
plot(camEyeDispDots(:,2),camEyeDispDots(:,3),'.','MarkerSize',2)
xlabel('Horizontal (cm)')
ylabel('Vertical (cm)')
%title('Eye Positions Looking at Displayed Dots'),
subtitle('Camera on the table below the eye level')
ylim([-1,1])
xlim([-1,1])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dots, crosses] = GenerateDisplayDots(rows, columns, distRows, distColumns)
n = rows*columns;
dots = zeros(n, 2);
c = 0; 
for i = 1:distRows:rows * distRows
    for j = 1:distColumns:columns * distColumns
        c = c + 1;
        dots(c,:) = [i,j]; 
    end
end
% make the center dot to be 0,0
dots = dots - dots(round(n/2),:);

% draw a cross around each dot to demo the torsion in the camera view
c = 0;
for i = 1:size(dots,1)
    c = c + 1;
    crosses(c,:) = dots(i,:);
    for h = 1:30
        c = c + 1;
        crosses(c,:) = [dots(i,1) dots(i,2)+h/10];
        
        c = c + 1;
        crosses(c,:) = [dots(i,1) dots(i,2)-h/10];
        
        
        
    end

    for h = 1:15
        c = c + 1;
        crosses(c,:) = [dots(i,1)+h/10 dots(i,2)];
        
        c = c + 1;
        crosses(c,:) = [dots(i,1)-h/10 dots(i,2)];
    end


end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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