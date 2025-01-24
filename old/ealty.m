% Homework: Image Analysis and 3D Reconstruction
% Author: Paolo Riva
% Academic Year: 2024-2025

clc; clear; close all;

%% Load Image
% Load the scene image for analysis
scene_img = imread('scene.jpg'); % Replace with the exact path to your image
figure;
imshow(scene_img);
title('Scene Image');

%% PART 1: Theory Implementation

% Input: l_i (X-parallel), m_j (Y-parallel), h_i (Z-parallel), image of C (circumference), S (curve)

% Step 1: Compute Vanishing Line of Horizontal Plane
% Extract vanishing points for X and Y directions
disp('Extracting vanishing points and computing vanishing line...');

% Assuming we have manually extracted or used MATLAB tools to obtain line equations
l1 = [1, -2, 3]; l2 = [2, -1, -3]; % Replace with your actual data
m1 = [1, 3, -4]; m2 = [3, 1, -5]; % Replace with your actual data

% Compute vanishing points
v1 = cross(l1, l2); v1 = v1 / v1(3); % X-parallel
v2 = cross(m1, m2); v2 = v2 / v2(3); % Y-parallel

% Compute vanishing line
vanishing_line = cross(v1, v2);
vanishing_line = vanishing_line / vanishing_line(3);
fprintf('Vanishing Line: [%f, %f, %f]\n', vanishing_line);

% Step 2: Rectify Horizontal Plane and Compute Depth
disp('Rectifying horizontal plane...');
syms x y;
C = [1, 0, 1, -4, 2, -3]; % Replace with coefficients of the conic
[solx, soly] = solve(C(1)*x^2 + C(2)*x*y + C(3)*y^2 + C(4)*x + C(5)*y + C(6) == 0, ...
    vanishing_line(1)*x + vanishing_line(2)*y + vanishing_line(3) == 0);

% Circular points of the plane
circular_points = [double(solx(1)), double(soly(1)), 1; 
                   double(solx(2)), double(soly(2)), 1];

% Rectification matrix
dual_conic = circular_points(1,:)' * circular_points(2,:) + ...
             circular_points(2,:)' * circular_points(1,:);
[U, D, ~] = svd(dual_conic);
HR = diag([1/sqrt(D(1,1)), 1/sqrt(D(2,2)), 1]) * U';

% Compute depth
% Define the points in homogeneous coordinates
A = [100, 200, 1]; % Replace with actual pixel coordinates of A
B = [150, 200, 1]; % Replace with actual pixel coordinates of B
D = [100, 250, 1]; % Replace with actual pixel coordinates of D
E = [150, 250, 1]; % Replace with actual pixel coordinates of E

% Combine points into a matrix
points = [A; B; D; E]'; % 3xN matrix (N = number of points)

% Rectify the points using the rectification matrix HR
rectified_points = HR * points; % HR is a 3x3 matrix

% Normalize to convert back from homogeneous coordinates
rectified_points = rectified_points ./ rectified_points(3, :); % Divide each column by the third row

AB_px = norm(rectified_points(1,:) - rectified_points(2,:));
AD_px = norm(rectified_points(1,:) - rectified_points(3,:));
depth_m = AD_px / AB_px;
fprintf('Depth: %f meters\n', depth_m);

% Step 3: Compute Calibration Matrix
disp('Computing calibration matrix...');
h1 = [1, -1, 0]; h2 = [1, 1, -1]; % Replace with actual vertical line equations
K = computeCalibrationMatrix(v1, v2, h1, h2); % You need to implement this function

% Step 4: Compute Height of Parallelepiped
disp('Computing height...');
h_px = rectified_points(4,2) - rectified_points(3,2); % Adjust for pixel measurements
height = h_px * scale_ratio;
fprintf('Height: %f meters\n', height);

% Step 5: Rectify Curve S
disp('Rectifying curve...');
load('curve_data.mat'); % Replace with your curve data file
rectified_curve = HR * [S'; ones(1, size(S, 1))];
rectified_curve = rectified_curve ./ rectified_curve(3,:);

% Display rectified curve
figure;
plot(rectified_curve(1,:), rectified_curve(2,:), 'o');
title('Rectified Curve');
xlabel('X'); ylabel('Y');

% Step 6: Camera Localization
disp('Localizing camera...');
camera_pose = localizeCamera(K, HR); % You need to implement this function

%% PART 2: MATLAB IMPLEMENTATION
% Step 1: Feature Extraction (manual or automated with MATLAB)

% Use built-in MATLAB functions such as detectSURFFeatures, edge detection
% Extract points, lines (l_i, m_j, h_i), and conics (C, S).

% Step 2: 3D Reconstruction and Visualization
disp('Visualizing 3D reconstruction...');
figure;
% Use MATLAB's 3D plotting functions
plot3DModel(rectified_curve, depth_m, height); % You need to implement this function
title('3D Model Reconstruction');
xlabel('X'); ylabel('Y'); zlabel('Z');
grid on;

disp('All tasks completed!');
