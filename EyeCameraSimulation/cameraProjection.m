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
eyeRadiusPix = 150; %cm, arbitrary number
eyeGlobePositionPix = [400, 200];

% assuming the camera is outside of the display plane
% camera location relative to eye - cm
camX = 45;
camY = 0;
camZ = -20;
camPosition = [camX,camY,camZ]; % eye centered reference frame (head)
camOrientation = camPosition/sqrt(sum(camPosition.^2));

referencePosition = [distanceDispEye,0,0]; % eye centered reference frame (head)
referenceOrientation = [1,0,0];
camEyeDispDots = Display2Cam_simulation(dispDots_c, referenceOrientation, camZ, eyeGlobePositionPix, eyeRadiusPix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figures
figure
subplot(1,2,1)
plot(dispDots_c(:,2),dispDots_c(:,3),'.','MarkerSize',2)
xlabel('Horizontal (cm)')
ylabel('Vertical (cm)')
title('Displayed Dots Position')
axis equal
ylim([-82,82])
xlim([-82,82])


subplot(1,2,2)
plot(camEyeDispDots(:,1),camEyeDispDots(:,2),'.','MarkerSize',2)
xlabel('Horizontal (px)')
ylabel('Vertical (px)')
title('Eye Positions Looking at Displayed Dots')
subtitle('Camera on the table below the eye level')
axis equal
ylim([0,400])
xlim([0,700])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eyeDispDots = Cam2Display_simulation(camEyeDispDots, referenceOrientation, camOrientation, eyeRadiusPix);

% figures
figure

subplot(1,2,1)
plot(camEyeDispDots(:,1),camEyeDispDots(:,2),'.','MarkerSize',2)
xlabel('Horizontal (px)')
ylabel('Vertical (px)')
sgtitle('Eye Positions Looking at Displayed Dots')
subtitle('Camera on the table below the eye level')
axis equal
ylim([0,400])
xlim([0,700])

subplot(1,2,2)
plot(eyeDispDots(:,2),eyeDispDots(:,3),'.','MarkerSize',2)
xlabel('Horizontal (px)')
ylabel('Vertical (px)')
subtitle('Camera infront of the eye while at the primary position')
axis equal
ylim([0,400])
xlim([0,700])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


