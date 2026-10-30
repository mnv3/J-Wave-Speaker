%% Ultrasonic Beamforming Simulation
clear; close all; clc;

%% Physical parameters
c = 343;            % Speed of sound [m/s]
f0 = 40e3;          % Ultrasonic carrier [Hz]
lambda = c/f0;      % Wavelength [m]
k = 2*pi/lambda;    % Wavenumber [rad/m]

fprintf('Wavelength at 40 kHz = %.2f mm\n', lambda*1000);

%% Array parameters
N = 8;              % Number of independently controlled columns
d = 9.2e-3;         % Column spacing [m]

% Center the array at x = 0
x = ((0:N-1) - (N-1)/2)*d;

%% Desired steering angle
theta0_deg = 0;
theta0 = deg2rad(theta0_deg);

%% Phase required for each column
phi = -k*x*sin(theta0);

fprintf('\nColumn phases for steering to %.1f degrees:\n',theta0_deg);
disp(rad2deg(phi));

%% Observation angles
theta_deg = -90:0.05:90;
theta = deg2rad(theta_deg);

%% Calculate array factor
AF = zeros(size(theta));

for ii = 1:length(theta)

    AF(ii) = sum(exp(1j*( ...
        k*x*sin(theta(ii)) + phi)));

end

%% Normalize
AF_mag = abs(AF);
AF_mag = AF_mag/max(AF_mag);

AF_dB = 20*log10(AF_mag + eps);

%% Plot
figure;
plot(theta_deg,AF_dB,'LineWidth',1.5);

xlabel('Angle from Broadside (degrees)');
ylabel('Normalized Array Response (dB)');
title(sprintf('%d-Column 40 kHz Array, Steered to %d°', ...
    N,theta0_deg));

grid on;
ylim([-40 0]);
xlim([-90 90]);

yline(-6,'--','-6 dB Beam Boundary');
xline(theta0_deg,'--','Desired Steering Angle');
