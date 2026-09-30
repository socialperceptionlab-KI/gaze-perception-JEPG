%% Calibration Quality Analysis - Experiment 1 (S vs O)
% Loads pre-computed calibration quality data and displays summary
% S = Self, O = Other
%
% CALIBRATION METHOD:
% A 21-point calibration grid was used. Participants fixated each point
% while gaze was recorded. Calibration error was corrected using Procrustes
% analysis, which finds the optimal transformation (translation, rotation,
% and uniform scaling) to align the measured gaze points with the true
% fixation targets. This transformation was then applied to correct gaze
% data in the main experiment.
%
% POINT EXCLUSION (for Procrustes fit):
% 1. Points with missing gaze or target data (NaN) were excluded
% 2. Points with gaze cluster radius > 50 mm were excluded, as large radius
%    indicates unreliable gaze data during fixation (e.g., blinks, lost
%    tracking, saccades)
%
% VARIABLES:
%   meanErrMag_S/O      - Mean error magnitude BEFORE calibration (mm)
%   meanErrMagFixed_S/O - Mean error magnitude AFTER Procrustes correction (mm)
%   Error reduction     - Improvement in accuracy due to calibration

clear; close all;

%% Load pre-computed data
baseDir = fileparts(mfilename('fullpath'));
if isempty(baseDir)
    baseDir = pwd;
end

dataFile = fullfile(baseDir, 'Exp1_calibrationQuality_allParticipants.mat');
load(dataFile);

%% Summary Statistics
fprintf('\n========================================\n');
fprintf('  CALIBRATION QUALITY SUMMARY - EXP 1\n');
fprintf('========================================\n');

nParticipants = length(participantsValid);

% S = Self condition
meanReduction_S = mean(meanErrMag_S - meanErrMagFixed_S);
meanReduction_S_vd = 2 * atand((meanReduction_S / 2) / distFromEye);

fprintf('\nS (Self): N = %d participants\n', nParticipants);
fprintf('  Mean error before calibration: %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_S), 2*atand((mean(meanErrMag_S)/2)/distFromEye));
fprintf('  Mean error after calibration:  %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMagFixed_S), 2*atand((mean(meanErrMagFixed_S)/2)/distFromEye));
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', meanReduction_S, meanReduction_S_vd);

% O = Other condition
meanReduction_O = mean(meanErrMag_O - meanErrMagFixed_O);
meanReduction_O_vd = 2 * atand((meanReduction_O / 2) / distFromEye);

fprintf('\nO (Other): N = %d participants\n', nParticipants);
fprintf('  Mean error before calibration: %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_O), 2*atand((mean(meanErrMag_O)/2)/distFromEye));
fprintf('  Mean error after calibration:  %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMagFixed_O), 2*atand((mean(meanErrMagFixed_O)/2)/distFromEye));
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', meanReduction_O, meanReduction_O_vd);

% Overall
fprintf('\nOVERALL:\n');
allBefore = [meanErrMag_S; meanErrMag_O];
allAfter = [meanErrMagFixed_S; meanErrMagFixed_O];
overallReduction = mean(allBefore - allAfter);
overallReduction_vd = 2 * atand((overallReduction / 2) / distFromEye);
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', overallReduction, overallReduction_vd);

fprintf('\n========================================\n');
