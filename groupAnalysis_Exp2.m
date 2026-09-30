%% Group Analysis - Experiment 2 (O vs M vs B)
% Computes statistics for all participants
% Conditions: O = Other, M = Mannequin, B = Blank

clear; close all;

%% Settings
distFromEye = 1850;           % Distance from eye in mm
baseDir = fileparts(mfilename('fullpath'));
if isempty(baseDir), baseDir = pwd; end

%% Import pre-computed vertical bias arrays (flip to body-face)
vbOther = -importdata(fullfile(baseDir, "Exp2_O_average_vertBiasDiff.mat"));
vbMannequin = -importdata(fullfile(baseDir, "Exp2_M_average_vertBiasDiff.mat"));
vbBlank = -importdata(fullfile(baseDir, "Exp2_B_average_vertBiasDiff.mat"));

%% Import pre-computed accuracy arrays
accOther = importdata(fullfile(baseDir, "Exp2_O_average_accuracy.mat"));
accMannequin = importdata(fullfile(baseDir, "Exp2_M_average_accuracy.mat"));
accBlank = importdata(fullfile(baseDir, "Exp2_B_average_accuracy.mat"));

accFaceOther = importdata(fullfile(baseDir, "Exp2_O_average_accuracyFace.mat"));
accFaceMannequin = importdata(fullfile(baseDir, "Exp2_M_average_accuracyFace.mat"));
accFaceBlank = importdata(fullfile(baseDir, "Exp2_B_average_accuracyFace.mat"));

accBodyOther = importdata(fullfile(baseDir, "Exp2_O_average_accuracyBody.mat"));
accBodyMannequin = importdata(fullfile(baseDir, "Exp2_M_average_accuracyBody.mat"));
accBodyBlank = importdata(fullfile(baseDir, "Exp2_B_average_accuracyBody.mat"));

%% Import pre-computed gaze radius arrays
gazeRadiusOther = importdata(fullfile(baseDir, "Exp2_O_gazeRadius.mat"));
gazeRadiusMannequin = importdata(fullfile(baseDir, "Exp2_M_gazeRadius.mat"));
gazeRadiusBlank = importdata(fullfile(baseDir, "Exp2_B_gazeRadius.mat"));

%% Convert to visual degrees
toVD = @(x) 2 * atand((x / 2) / distFromEye);
vbOther_vd = arrayfun(toVD, vbOther);
vbMannequin_vd = arrayfun(toVD, vbMannequin);
vbBlank_vd = arrayfun(toVD, vbBlank);

accOther_vd = arrayfun(toVD, accOther);
accMannequin_vd = arrayfun(toVD, accMannequin);
accBlank_vd = arrayfun(toVD, accBlank);

accFaceOther_vd = arrayfun(toVD, accFaceOther);
accFaceMannequin_vd = arrayfun(toVD, accFaceMannequin);
accFaceBlank_vd = arrayfun(toVD, accFaceBlank);

accBodyOther_vd = arrayfun(toVD, accBodyOther);
accBodyMannequin_vd = arrayfun(toVD, accBodyMannequin);
accBodyBlank_vd = arrayfun(toVD, accBodyBlank);

gazeRadiusOther_vd = arrayfun(toVD, gazeRadiusOther);
gazeRadiusMannequin_vd = arrayfun(toVD, gazeRadiusMannequin);
gazeRadiusBlank_vd = arrayfun(toVD, gazeRadiusBlank);

N = length(vbOther);

%% ========================================================================
%  VERTICAL BIAS STATISTICS
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 2 - VERTICAL BIAS (Body - Face)\n');
fprintf('============================================================\n');

% Pairwise t-tests
fprintf('\nPairwise t-tests:\n');

[~, p_OM, ~, stats_OM] = ttest(vbOther_vd, vbMannequin_vd);
d_OM = meanEffectSize(vbOther_vd, vbMannequin_vd, Effect="cohen");
fprintf('  Other vs Mannequin: t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_OM.df, stats_OM.tstat, p_OM, d_OM.Effect);

[~, p_OB, ~, stats_OB] = ttest(vbOther_vd, vbBlank_vd);
d_OB = meanEffectSize(vbOther_vd, vbBlank_vd, Effect="cohen");
fprintf('  Other vs Blank:     t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_OB.df, stats_OB.tstat, p_OB, d_OB.Effect);

[~, p_MB, ~, stats_MB] = ttest(vbMannequin_vd, vbBlank_vd);
d_MB = meanEffectSize(vbMannequin_vd, vbBlank_vd, Effect="cohen");
fprintf('  Mannequin vs Blank: t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_MB.df, stats_MB.tstat, p_MB, d_MB.Effect);

% One-sample t-tests vs 0
fprintf('\nOne-sample t-tests vs 0:\n');
[~, p_vb_O, ~, stats_vb_O] = ttest(vbOther_vd, 0);
d_vb_O = mean(vbOther_vd, 'omitnan') / std(vbOther_vd, 'omitnan');
fprintf('  Other:     t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_vb_O.df, stats_vb_O.tstat, p_vb_O, d_vb_O);

[~, p_vb_M, ~, stats_vb_M] = ttest(vbMannequin_vd, 0);
d_vb_M = mean(vbMannequin_vd, 'omitnan') / std(vbMannequin_vd, 'omitnan');
fprintf('  Mannequin: t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_vb_M.df, stats_vb_M.tstat, p_vb_M, d_vb_M);

[~, p_vb_B, ~, stats_vb_B] = ttest(vbBlank_vd, 0);
d_vb_B = mean(vbBlank_vd, 'omitnan') / std(vbBlank_vd, 'omitnan');
fprintf('  Blank:     t(%d) = %.3f, p = %.4f, d = %.3f\n', stats_vb_B.df, stats_vb_B.tstat, p_vb_B, d_vb_B);

% Descriptives
fprintf('\nDescriptives:\n');
fprintf('  Other:     M = %.3f vd, SEM = %.3f\n', mean(vbOther_vd,'omitnan'), std(vbOther_vd,'omitnan')/sqrt(N));
fprintf('  Mannequin: M = %.3f vd, SEM = %.3f\n', mean(vbMannequin_vd,'omitnan'), std(vbMannequin_vd,'omitnan')/sqrt(N));
fprintf('  Blank:     M = %.3f vd, SEM = %.3f\n', mean(vbBlank_vd,'omitnan'), std(vbBlank_vd,'omitnan')/sqrt(N));

%% ========================================================================
%  ACCURACY STATISTICS  
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 2 - ACCURACY (Error Magnitude)\n');
fprintf('============================================================\n');

% 2-way Repeated Measures ANOVA: Region (Face/Body) x Mode (O/M/B)
accTable = table(accFaceOther_vd(:), accFaceMannequin_vd(:), accFaceBlank_vd(:), ...
                 accBodyOther_vd(:), accBodyMannequin_vd(:), accBodyBlank_vd(:), ...
                 'VariableNames', {'FaceOther', 'FaceMannequin', 'FaceBlank', ...
                                   'BodyOther', 'BodyMannequin', 'BodyBlank'});

within = table(categorical({'Face';'Face';'Face';'Body';'Body';'Body'}), ...
               categorical({'Other';'Mannequin';'Blank';'Other';'Mannequin';'Blank'}), ...
               'VariableNames', {'Region', 'Mode'});

rm = fitrm(accTable, 'FaceOther-BodyBlank ~ 1', 'WithinDesign', within);
ranovaResults = ranova(rm, 'WithinModel', 'Region*Mode');

% Compute partial eta squared
eta2_region = ranovaResults.SumSq(3) / (ranovaResults.SumSq(3) + ranovaResults.SumSq(4));
eta2_mode = ranovaResults.SumSq(5) / (ranovaResults.SumSq(5) + ranovaResults.SumSq(6));
eta2_interaction = ranovaResults.SumSq(7) / (ranovaResults.SumSq(7) + ranovaResults.SumSq(8));

fprintf('\n2x3 Repeated Measures ANOVA (Region x Mode):\n');
fprintf('  Region:        F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(3), ranovaResults.DF(4), ranovaResults.F(3), ranovaResults.pValue(3), eta2_region);
fprintf('  Mode:          F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(5), ranovaResults.DF(6), ranovaResults.F(5), ranovaResults.pValue(5), eta2_mode);
fprintf('  Region x Mode: F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(7), ranovaResults.DF(8), ranovaResults.F(7), ranovaResults.pValue(7), eta2_interaction);

% Store ANOVA p-values for plotting
p_region = ranovaResults.pValue(3);
p_mode = ranovaResults.pValue(5);
p_interaction = ranovaResults.pValue(7);

% Post-hoc pairwise t-tests (Overall)
fprintf('\nPost-hoc t-tests (Overall):\n');
[~, p_acc_OM] = ttest(accOther_vd, accMannequin_vd);
[~, p_acc_OB] = ttest(accOther_vd, accBlank_vd);
[~, p_acc_MB] = ttest(accMannequin_vd, accBlank_vd);
fprintf('  O vs M: p = %.4f\n', p_acc_OM);
fprintf('  O vs B: p = %.4f\n', p_acc_OB);
fprintf('  M vs B: p = %.4f\n', p_acc_MB);

% Post-hoc pairwise t-tests (Face)
fprintf('\nPost-hoc t-tests (Face):\n');
[~, p_accFace_OM] = ttest(accFaceOther_vd, accFaceMannequin_vd);
[~, p_accFace_OB] = ttest(accFaceOther_vd, accFaceBlank_vd);
[~, p_accFace_MB] = ttest(accFaceMannequin_vd, accFaceBlank_vd);
fprintf('  O vs M: p = %.4f\n', p_accFace_OM);
fprintf('  O vs B: p = %.4f\n', p_accFace_OB);
fprintf('  M vs B: p = %.4f\n', p_accFace_MB);

% Post-hoc pairwise t-tests (Body)
fprintf('\nPost-hoc t-tests (Body):\n');
[~, p_accBody_OM] = ttest(accBodyOther_vd, accBodyMannequin_vd);
[~, p_accBody_OB] = ttest(accBodyOther_vd, accBodyBlank_vd);
[~, p_accBody_MB] = ttest(accBodyMannequin_vd, accBodyBlank_vd);
fprintf('  O vs M: p = %.4f\n', p_accBody_OM);
fprintf('  O vs B: p = %.4f\n', p_accBody_OB);
fprintf('  M vs B: p = %.4f\n', p_accBody_MB);

% Descriptives
fprintf('\nDescriptives (visual degrees):\n');
fprintf('  Face Other:        M = %.3f, SEM = %.3f\n', mean(accFaceOther_vd,'omitnan'), std(accFaceOther_vd,'omitnan')/sqrt(N));
fprintf('  Face Mannequin:    M = %.3f, SEM = %.3f\n', mean(accFaceMannequin_vd,'omitnan'), std(accFaceMannequin_vd,'omitnan')/sqrt(N));
fprintf('  Face Blank:        M = %.3f, SEM = %.3f\n', mean(accFaceBlank_vd,'omitnan'), std(accFaceBlank_vd,'omitnan')/sqrt(N));
fprintf('  Body Other:        M = %.3f, SEM = %.3f\n', mean(accBodyOther_vd,'omitnan'), std(accBodyOther_vd,'omitnan')/sqrt(N));
fprintf('  Body Mannequin:    M = %.3f, SEM = %.3f\n', mean(accBodyMannequin_vd,'omitnan'), std(accBodyMannequin_vd,'omitnan')/sqrt(N));
fprintf('  Body Blank:        M = %.3f, SEM = %.3f\n', mean(accBodyBlank_vd,'omitnan'), std(accBodyBlank_vd,'omitnan')/sqrt(N));

%% ========================================================================
%  GAZE RADIUS  
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 2 - GAZE RADIUS\n');
fprintf('============================================================\n');

fprintf('\nDescriptives (mm):\n');
fprintf('  Other:     M = %.3f, SEM = %.3f\n', mean(gazeRadiusOther,'omitnan'), std(gazeRadiusOther,'omitnan')/sqrt(N));
fprintf('  Mannequin: M = %.3f, SEM = %.3f\n', mean(gazeRadiusMannequin,'omitnan'), std(gazeRadiusMannequin,'omitnan')/sqrt(N));
fprintf('  Blank:     M = %.3f, SEM = %.3f\n', mean(gazeRadiusBlank,'omitnan'), std(gazeRadiusBlank,'omitnan')/sqrt(N));

%% ========================================================================
%  PLOT: VERTICAL BIAS
%  ========================================================================
figure('Name', 'Exp2 - Vertical Bias', 'Position', [100, 100, 500, 450]);
hold on;

% Colors for 3 conditions
colors = [[202 29 29]; [128 128 128]; [61 177 219]]/255;  % O=red, M=gray, B=blue

% Means and SEMs
vb_means = [mean(vbOther_vd,'omitnan'), mean(vbMannequin_vd,'omitnan'), mean(vbBlank_vd,'omitnan')];
vb_sems = [std(vbOther_vd,'omitnan')/sqrt(N), std(vbMannequin_vd,'omitnan')/sqrt(N), std(vbBlank_vd,'omitnan')/sqrt(N)];

% Bar positions
barPos = [1, 1.6, 2.2];

% Plot bars
b1 = bar(barPos(1), vb_means(1), 0.5, 'FaceColor', colors(1,:));
b2 = bar(barPos(2), vb_means(2), 0.5, 'FaceColor', colors(2,:));
b3 = bar(barPos(3), vb_means(3), 0.5, 'FaceColor', colors(3,:));

% Error bars
errorbar(barPos, vb_means, vb_sems, 'k', 'linestyle', 'none', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Formatting
ylabel('Vertical Bias (visual degrees)', 'FontSize', 11);
xticks([]);
xlim([0.4 2.8]);
legend([b1, b2, b3], {'Other', 'Mannequin', 'Blank'}, 'Location', 'Best');
title('Experiment 2 - Towards-Face Bias (Body - Face)');

% Helper for significance stars
getStars = @(pval) subsref({'n.s.', '*', '**', '***'}, ...
    struct('type', '{}', 'subs', {{(pval < 0.001)*4 + (pval >= 0.001 & pval < 0.01)*3 + ...
    (pval >= 0.01 & pval < 0.05)*2 + (pval >= 0.05)*1}}));

% Add significance markers
yl = ylim;
yRange = yl(2) - yl(1);
bracketOffset = yRange * 0.05;

% Stars for one-sample t-tests vs 0
p_vals_vs0 = [p_vb_O, p_vb_M, p_vb_B];
for i = 1:3
    if p_vals_vs0(i) < 0.05
        starY = vb_means(i) + sign(vb_means(i)) * (vb_sems(i) + bracketOffset);
        text(barPos(i), starY, getStars(p_vals_vs0(i)), 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

% Brackets for pairwise comparisons
bracketTip = yRange * 0.02;
pairwise_p = [p_OM, p_OB, p_MB];
pairwise_idx = {[1,2], [1,3], [2,3]};
bracketHeights = [1, 2, 1.5] * bracketOffset * 3;

for pair = 1:3
    if pairwise_p(pair) < 0.05
        idx = pairwise_idx{pair};
        x1 = barPos(idx(1));
        x2 = barPos(idx(2));
        bracketY = max(abs(vb_means(idx)) + vb_sems(idx)) + bracketHeights(pair);
        if mean(vb_means) < 0
            bracketY = -bracketY;
        end
        plot([x1, x1, x2, x2], ...
            [bracketY - sign(bracketY)*bracketTip, bracketY, bracketY, bracketY - sign(bracketY)*bracketTip], ...
            'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
        text(mean([x1 x2]), bracketY + sign(bracketY)*bracketOffset*0.5, getStars(pairwise_p(pair)), ...
            'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

hold off;

%% ========================================================================
%  PLOT: ACCURACY
%  ========================================================================
figure('Name', 'Exp2 - Accuracy', 'Position', [650, 100, 700, 450]);
hold on;

% Means and SEMs for 3 groups (Overall, Face, Body) x 3 conditions
acc_means = [mean(accOther_vd,'omitnan'), mean(accMannequin_vd,'omitnan'), mean(accBlank_vd,'omitnan');
             mean(accFaceOther_vd,'omitnan'), mean(accFaceMannequin_vd,'omitnan'), mean(accFaceBlank_vd,'omitnan');
             mean(accBodyOther_vd,'omitnan'), mean(accBodyMannequin_vd,'omitnan'), mean(accBodyBlank_vd,'omitnan')];

acc_sems = [std(accOther_vd,'omitnan')/sqrt(N), std(accMannequin_vd,'omitnan')/sqrt(N), std(accBlank_vd,'omitnan')/sqrt(N);
            std(accFaceOther_vd,'omitnan')/sqrt(N), std(accFaceMannequin_vd,'omitnan')/sqrt(N), std(accFaceBlank_vd,'omitnan')/sqrt(N);
            std(accBodyOther_vd,'omitnan')/sqrt(N), std(accBodyMannequin_vd,'omitnan')/sqrt(N), std(accBodyBlank_vd,'omitnan')/sqrt(N)];

% Bar positions
barWidth = 0.25;
intraGroupGap = 0.05;
interGroupGap = 0.4;
groupCenters = [1, 1 + 3*barWidth + 2*intraGroupGap + interGroupGap, ...
                1 + 2*(3*barWidth + 2*intraGroupGap + interGroupGap)];
xPos = zeros(3, 3);
for g = 1:3
    xPos(g, 1) = groupCenters(g) - barWidth - intraGroupGap;
    xPos(g, 2) = groupCenters(g);
    xPos(g, 3) = groupCenters(g) + barWidth + intraGroupGap;
end

% Plot bars
barHandles = gobjects(1, 3);
for g = 1:3
    for c = 1:3
        bh = bar(xPos(g,c), acc_means(g,c), barWidth, 'FaceColor', colors(c,:));
        if g == 1
            barHandles(c) = bh;
        end
    end
end

% Error bars
for c = 1:3
    errorbar(xPos(:,c), acc_means(:,c), acc_sems(:,c), 'k', 'linestyle', 'none', 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

% Formatting
ylabel('Mean Error (visual degrees)', 'FontSize', 11);
xticks(groupCenters);
xticklabels({'Overall', 'Face', 'Body'});
legend(barHandles, {'Other', 'Mannequin', 'Blank'}, 'Location', 'NorthWest');
title('Experiment 2 - Gaze Perception Accuracy');

% Add significance brackets for pairwise comparisons
yl = ylim;
yRange = yl(2) - yl(1);
bracketOffset = yRange * 0.03;
bracketTipLen = yRange * 0.015;

% P-values for each region: [O vs M, O vs B, M vs B]
p_acc_pairwise = {[p_acc_OM, p_acc_OB, p_acc_MB], ...
                  [p_accFace_OM, p_accFace_OB, p_accFace_MB], ...
                  [p_accBody_OM, p_accBody_OB, p_accBody_MB]};
pairwise_idx = {[1,2], [1,3], [2,3]};  % condition indices for each comparison
bracketHeightMultipliers = [1, 2.5, 1.5];  % stagger heights for multiple brackets

for g = 1:3  % for each region (Overall, Face, Body)
    for pair = 1:3  % for each pairwise comparison
        p_val = p_acc_pairwise{g}(pair);
        if p_val < 0.05
            idx = pairwise_idx{pair};
            x1 = xPos(g, idx(1));
            x2 = xPos(g, idx(2));
            maxY = max(acc_means(g, idx) + acc_sems(g, idx));
            bracketY = maxY + bracketOffset * bracketHeightMultipliers(pair) * 2;
            plot([x1, x1, x2, x2], [bracketY - bracketTipLen, bracketY, bracketY, bracketY - bracketTipLen], 'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
            text((x1+x2)/2, bracketY + bracketOffset * 0.5, getStars(p_val), ...
                'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
        end
    end
end

hold off;

fprintf('\n============================================================\n');
