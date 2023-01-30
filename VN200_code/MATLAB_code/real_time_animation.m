% EE 440 Modern Nav
% Script to plot VN200 IMU gyro data
% Author: S. Bruder

clear;                  % Clear all variables from the workspace
close all;              % Close all windows
clc;                    % "Clean" the command window

%% Connect to the VN200 IMU via USB to serial cable
Fs = 20;                        % Default Sample frequency <= 200 (Hz)
dT = 1/Fs;                      % Sample interval (sec)
nSec = 10;                      % Duration of data collection (sec)
nSamples = Fs*nSec;             % Number of samples to collect (dimless)

% Step 1: Initialize C
C = eye(3);     % Identity matrix

%% Setup graphics
figure('Position', [100, 100, 800, 800]);
      plot_frame(C, [0;0;0], '0', 'k', 'k', 'k');    % Plot the starting frame
hg1 = plot_frame(C, [0;0;0], '1', 'r', 'g', 'b');    % Plot the rotating frame
title('Real-Time Plot of the VN200 Coordinate Frame', 'FontSize', 14)
axis([-1.2 1.2 -1.2 1.2 -1.2 1.2]);
grid
view(137, 36);          % Set azimuth and elevation of view
ht = hgtransform;       % Handle to a Homogenous transform object
set(hg1, 'Parent', ht); % Assign the Homo transform to be the parent of rotating frame

%% Collect IMU data
[s, SN] = Initialize_VN200_IMU(Fs); % Initialize the VN200
for n = 1:nSec*Fs                   % Retrieve IMU data from VN200
    
% Step 1:  Read gyro data
    [compass, accel, w, temp, baro] = Read_VN200_IMU(s);

% Step 2: Compute the angle and axis of rotation:
    theta_dot = ??;            % Theta Dot = Speed of Rotation
    theta = ??;         % Theta = Angle of Rotation
    k = ??;              % k = Normalized Axis of rotation

% Step 3: Compute the "small" change of attitude over time dT
    K = [ ?? ];
 
    Delta_C = eye(3) + sin(theta) * K + (1-cos(theta)) * K^2; % Rodrigues Formula

% Step 4: Update the attitude: C(k-1) -> C(k)
    C = ? * C * ?;  % Fixed or relative axis rotation?
    
    % Apply rotational transform on render side (faster)
   set(ht,'Matrix',[C, [0;0;0]; [0,0,0,1]]);
   drawnow;
end
clear s;                        % Clear the serial port object <=> Close serial port