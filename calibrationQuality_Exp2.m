%% Calibration Quality Analysis - Experiment 2 (O vs M vs B)
% Loads pre-computed calibration quality data and displays summary
% O = Other, M = Mannequin, B = Blank Screen
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
%   meanErrMag_O/M/B      - Mean error magnitude BEFORE calibration (mm)
%   meanErrMagFixed_O/M/B - Mean error magnitude AFTER Procrustes correction (mm)
%   Error reduction       - Improvement in accuracy due to calibration

clear; close all;

%% Load pre-computed data
baseDir = fileparts(mfilename('fullpath'));
if isempty(baseDir)
    baseDir = pwd;
end

dataFile = fullfile(baseDir, 'Exp2_calibrationQuality_allParticipants.mat');
load(dataFile);

%% Summary Statistics
fprintf('\n========================================\n');
fprintf('  CALIBRATION QUALITY SUMMARY - EXP 2\n');
fprintf('========================================\n');

nParticipants = length(participantsValid);

% O = Other condition
meanReduction_O = mean(meanErrMag_O - meanErrMagFixed_O);
meanReduction_O_vd = 2 * atand((meanReduction_O / 2) / distFromEye);

fprintf('\nO (Other): N = %d participants\n', sum(~isnan(meanErrMag_O)));
fprintf('  Mean error before calibration: %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_O, 'omitnan'), 2*atand((mean(meanErrMag_O, 'omitnan')/2)/distFromEye));
fprintf('  Mean error after calibration:  %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMagFixed_O, 'omitnan'), 2*atand((mean(meanErrMagFixed_O, 'omitnan')/2)/distFromEye));
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_O - meanErrMagFixed_O, 'omitnan'), 2*atand((mean(meanErrMag_O - meanErrMagFixed_O, 'omitnan')/2)/distFromEye));

% M = Mannequin condition
meanReduction_M = mean(meanErrMag_M - meanErrMagFixed_M);
meanReduction_M_vd = 2 * atand((meanReduction_M / 2) / distFromEye);

fprintf('\nM (Mannequin): N = %d participants\n', sum(~isnan(meanErrMag_M)));
fprintf('  Mean error before calibration: %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_M, 'omitnan'), 2*atand((mean(meanErrMag_M, 'omitnan')/2)/distFromEye));
fprintf('  Mean error after calibration:  %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMagFixed_M, 'omitnan'), 2*atand((mean(meanErrMagFixed_M, 'omitnan')/2)/distFromEye));
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_M - meanErrMagFixed_M, 'omitnan'), 2*atand((mean(meanErrMag_M - meanErrMagFixed_M, 'omitnan')/2)/distFromEye));

% B = Blank Screen condition
meanReduction_B = mean(meanErrMag_B - meanErrMagFixed_B);
meanReduction_B_vd = 2 * atand((meanReduction_B / 2) / distFromEye);

fprintf('\nB (Blank Screen): N = %d participants\n', sum(~isnan(meanErrMag_B)));
fprintf('  Mean error before calibration: %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_B, 'omitnan'), 2*atand((mean(meanErrMag_B, 'omitnan')/2)/distFromEye));
fprintf('  Mean error after calibration:  %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMagFixed_B, 'omitnan'), 2*atand((mean(meanErrMagFixed_B, 'omitnan')/2)/distFromEye));
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', ...
    mean(meanErrMag_B - meanErrMagFixed_B, 'omitnan'), 2*atand((mean(meanErrMag_B - meanErrMagFixed_B, 'omitnan')/2)/distFromEye));

% Overall
fprintf('\nOVERALL:\n');
allBefore = [meanErrMag_O; meanErrMag_M; meanErrMag_B];
allAfter = [meanErrMagFixed_O; meanErrMagFixed_M; meanErrMagFixed_B];
overallReduction = mean(allBefore - allAfter, 'omitnan');
overallReduction_vd = 2 * atand((overallReduction / 2) / distFromEye);
fprintf('  Mean error reduction:          %7.2f mm  (%5.2f vd)\n', overallReduction, overallReduction_vd);

fprintf('\n========================================\n');
