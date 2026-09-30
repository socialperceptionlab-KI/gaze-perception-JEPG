%% Group Analysis - Experiment 1 (S vs O)
% Computes statistics for all participants
% Conditions: S = Self, O = Other

clear; close all;

%% Settings
distFromEye = 1850;           % Distance from eye in mm

%% Import pre-computed vertical bias arrays (flip to body-face)
vbS = -importdata("Exp1_S_average_vertBiasDiff.mat");
vbO = -importdata("Exp1_O_average_vertBiasDiff.mat");

%% Import pre-computed accuracy arrays
accS = importdata("Exp1_S_average_accuracy.mat");
accO = importdata("Exp1_O_average_accuracy.mat");
accFaceS = importdata("Exp1_S_average_accuracyFace.mat");
accFaceO = importdata("Exp1_O_average_accuracyFace.mat");
accBodyS = importdata("Exp1_S_average_accuracyBody.mat");
accBodyO = importdata("Exp1_O_average_accuracyBody.mat");

%% Import pre-computed gaze radius arrays
gazeRadiusS = importdata("Exp1_S_gazeRadius.mat");
gazeRadiusO = importdata("Exp1_O_gazeRadius.mat");

%% Convert to visual degrees
toVD = @(x) 2 * atand((x / 2) / distFromEye);
vbS_vd = arrayfun(toVD, vbS);
vbO_vd = arrayfun(toVD, vbO);
accS_vd = arrayfun(toVD, accS);
accO_vd = arrayfun(toVD, accO);
accFaceS_vd = arrayfun(toVD, accFaceS);
accFaceO_vd = arrayfun(toVD, accFaceO);
accBodyS_vd = arrayfun(toVD, accBodyS);
accBodyO_vd = arrayfun(toVD, accBodyO);
gazeRadiusS_vd = arrayfun(toVD, gazeRadiusS);
gazeRadiusO_vd = arrayfun(toVD, gazeRadiusO);

N = length(vbS);  % Update N based on actual data

%% ========================================================================
%  VERTICAL BIAS STATISTICS
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 1 - VERTICAL BIAS (Body - Face)\n');
fprintf('============================================================\n');

% Paired t-test: S vs O
[~, p_vb, ~, stats_vb] = ttest(vbS_vd, vbO_vd);
cohensD_vb = meanEffectSize(vbS_vd, vbO_vd, Effect="cohen");
fprintf('\nPaired t-test (S vs O):\n');
fprintf('  t(%d) = %.3f, p = %.4f, Cohen''s d = %.3f\n', ...
    stats_vb.df, stats_vb.tstat, p_vb, cohensD_vb.Effect);

% One-sample t-tests vs 0
[~, p_vb_S, ~, stats_vb_S] = ttest(vbS_vd, 0);
d_vb_S = mean(vbS_vd, 'omitnan') / std(vbS_vd, 'omitnan');
fprintf('\nS vs 0: t(%d) = %.3f, p = %.4f, Cohen''s d = %.3f\n', ...
    stats_vb_S.df, stats_vb_S.tstat, p_vb_S, d_vb_S);

[~, p_vb_O, ~, stats_vb_O] = ttest(vbO_vd, 0);
d_vb_O = mean(vbO_vd, 'omitnan') / std(vbO_vd, 'omitnan');
fprintf('O vs 0: t(%d) = %.3f, p = %.4f, Cohen''s d = %.3f\n', ...
    stats_vb_O.df, stats_vb_O.tstat, p_vb_O, d_vb_O);

% Means and SEMs
fprintf('\nDescriptives:\n');
fprintf('  S: M = %.3f vd, SEM = %.3f\n', mean(vbS_vd,'omitnan'), std(vbS_vd,'omitnan')/sqrt(N));
fprintf('  O: M = %.3f vd, SEM = %.3f\n', mean(vbO_vd,'omitnan'), std(vbO_vd,'omitnan')/sqrt(N));

%% ========================================================================
%  ACCURACY STATISTICS  
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 1 - ACCURACY (Error Magnitude)\n');
fprintf('============================================================\n');

% 2-way Repeated Measures ANOVA: Region (Face/Body) x Mode (Self/Other)
accTable = table(accFaceS_vd(:), accFaceO_vd(:), accBodyS_vd(:), accBodyO_vd(:), ...
                 'VariableNames', {'FaceSelf', 'FaceOther', 'BodySelf', 'BodyOther'});

within = table(categorical({'Face';'Face';'Body';'Body'}), ...
               categorical({'Self';'Other';'Self';'Other'}), ...
               'VariableNames', {'Region', 'Mode'});

rm = fitrm(accTable, 'FaceSelf-BodyOther ~ 1', 'WithinDesign', within);
ranovaResults = ranova(rm, 'WithinModel', 'Region*Mode');

% Compute partial eta squared
eta2_region = ranovaResults.SumSq(3) / (ranovaResults.SumSq(3) + ranovaResults.SumSq(4));
eta2_mode = ranovaResults.SumSq(5) / (ranovaResults.SumSq(5) + ranovaResults.SumSq(6));
eta2_interaction = ranovaResults.SumSq(7) / (ranovaResults.SumSq(7) + ranovaResults.SumSq(8));

fprintf('\n2x2 Repeated Measures ANOVA (Region x Mode):\n');
fprintf('  Region:         F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(3), ranovaResults.DF(4), ranovaResults.F(3), ranovaResults.pValue(3), eta2_region);
fprintf('  Mode:           F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(5), ranovaResults.DF(6), ranovaResults.F(5), ranovaResults.pValue(5), eta2_mode);
fprintf('  Region x Mode:  F(%.0f,%.0f) = %.3f, p = %.4f, η²p = %.3f\n', ...
    ranovaResults.DF(7), ranovaResults.DF(8), ranovaResults.F(7), ranovaResults.pValue(7), eta2_interaction);

% Store ANOVA p-values for plotting
p_region = ranovaResults.pValue(3);
p_mode = ranovaResults.pValue(5);
p_interaction = ranovaResults.pValue(7);

% Post-hoc pairwise t-tests
fprintf('\nPost-hoc t-tests:\n');
[~, p_acc_all] = ttest(accS_vd, accO_vd);
[~, p_acc_face] = ttest(accFaceS_vd, accFaceO_vd);
[~, p_acc_body] = ttest(accBodyS_vd, accBodyO_vd);
fprintf('  Overall (S vs O): p = %.4f\n', p_acc_all);
fprintf('  Face (S vs O):    p = %.4f\n', p_acc_face);
fprintf('  Body (S vs O):    p = %.4f\n', p_acc_body);

% Means
fprintf('\nDescriptives (visual degrees):\n');
fprintf('  Face S:    M = %.3f, SEM = %.3f\n', mean(accFaceS_vd,'omitnan'), std(accFaceS_vd,'omitnan')/sqrt(N));
fprintf('  Face O:    M = %.3f, SEM = %.3f\n', mean(accFaceO_vd,'omitnan'), std(accFaceO_vd,'omitnan')/sqrt(N));
fprintf('  Body S:    M = %.3f, SEM = %.3f\n', mean(accBodyS_vd,'omitnan'), std(accBodyS_vd,'omitnan')/sqrt(N));
fprintf('  Body O:    M = %.3f, SEM = %.3f\n', mean(accBodyO_vd,'omitnan'), std(accBodyO_vd,'omitnan')/sqrt(N));

%% ========================================================================
%  GAZE RADIUS  
%  ========================================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXPERIMENT 1 - GAZE RADIUS\n');
fprintf('============================================================\n');

fprintf('\nDescriptives (mm):\n');
fprintf('  S: M = %.3f, SEM = %.3f\n', mean(gazeRadiusS,'omitnan'), std(gazeRadiusS,'omitnan')/sqrt(N));
fprintf('  O: M = %.3f, SEM = %.3f\n', mean(gazeRadiusO,'omitnan'), std(gazeRadiusO,'omitnan')/sqrt(N));

%% ========================================================================
%  PLOT: VERTICAL BIAS
%  ========================================================================
figure('Name', 'Vertical Bias', 'Position', [100, 100, 400, 450]);
hold on;

% Colors
colors = [[61 177 219]; [202 29 29]]/255;

% Means and SEMs
vb_means = [mean(vbS_vd,'omitnan'), mean(vbO_vd,'omitnan')];
vb_sems = [std(vbS_vd,'omitnan')/sqrt(N), std(vbO_vd,'omitnan')/sqrt(N)];

% Bar positions
barPos = [1, 1.5];

% Plot bars
b1 = bar(barPos(1), vb_means(1), 0.4, 'FaceColor', colors(1,:));
b2 = bar(barPos(2), vb_means(2), 0.4, 'FaceColor', colors(2,:));

% Error bars
errorbar(barPos, vb_means, vb_sems, 'k', 'linestyle', 'none', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Formatting
ylabel('Vertical Bias (visual degrees)', 'FontSize', 11);
xticks([]);
xlim([0.5 2]);
legend([b1, b2], {'Self', 'Other'}, 'Location', 'Best');
title('Towards-Face Bias (Body - Face)');

% Helper for significance stars
getStars = @(pval) subsref({'n.s.', '*', '**', '***'}, ...
    struct('type', '{}', 'subs', {{(pval < 0.001)*4 + (pval >= 0.001 & pval < 0.01)*3 + ...
    (pval >= 0.01 & pval < 0.05)*2 + (pval >= 0.05)*1}}));

% Add significance markers
yl = ylim;
yRange = yl(2) - yl(1);
bracketOffset = yRange * 0.05;

% Stars for one-sample t-tests vs 0
if p_vb_S < 0.05
    starY = vb_means(1) + sign(vb_means(1)) * (vb_sems(1) + bracketOffset);
    text(barPos(1), starY, getStars(p_vb_S), 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
end
if p_vb_O < 0.05
    starY = vb_means(2) + sign(vb_means(2)) * (vb_sems(2) + bracketOffset);
    text(barPos(2), starY, getStars(p_vb_O), 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
end

% Bracket for paired t-test
if p_vb < 0.05
    bracketY = max(abs(vb_means) + vb_sems) + bracketOffset * 2.5;
    if mean(vb_means) < 0
        bracketY = -bracketY;
    end
    bracketTip = yRange * 0.02;
    plot([barPos(1), barPos(1), barPos(2), barPos(2)], ...
        [bracketY - sign(bracketY)*bracketTip, bracketY, bracketY, bracketY - sign(bracketY)*bracketTip], ...
        'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    text(mean(barPos), bracketY + sign(bracketY)*bracketOffset*0.5, getStars(p_vb), ...
        'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
end

hold off;

%% ========================================================================
%  PLOT: ACCURACY
%  ========================================================================
figure('Name', 'Accuracy', 'Position', [550, 100, 600, 450]);
hold on;

% Means and SEMs for 3 groups (Overall, Face, Body)
acc_means = [mean(accS_vd,'omitnan'), mean(accO_vd,'omitnan');
             mean(accFaceS_vd,'omitnan'), mean(accFaceO_vd,'omitnan');
             mean(accBodyS_vd,'omitnan'), mean(accBodyO_vd,'omitnan')];

acc_sems = [std(accS_vd,'omitnan')/sqrt(N), std(accO_vd,'omitnan')/sqrt(N);
            std(accFaceS_vd,'omitnan')/sqrt(N), std(accFaceO_vd,'omitnan')/sqrt(N);
            std(accBodyS_vd,'omitnan')/sqrt(N), std(accBodyO_vd,'omitnan')/sqrt(N)];

% Bar positions
barWidth = 0.35;
intraGroupGap = 0.05;
interGroupGap = 0.25;
groupCenters = [1, 1 + 2*barWidth + intraGroupGap + interGroupGap, ...
                1 + 2*(2*barWidth + intraGroupGap + interGroupGap)];
xPos = zeros(3, 2);
for g = 1:3
    xPos(g, 1) = groupCenters(g) - (barWidth + intraGroupGap/2)/2;
    xPos(g, 2) = groupCenters(g) + (barWidth + intraGroupGap/2)/2;
end

% Plot bars
barHandles = gobjects(1, 2);
for g = 1:3
    for c = 1:2
        bh = bar(xPos(g,c), acc_means(g,c), barWidth, 'FaceColor', colors(c,:));
        if g == 1
            barHandles(c) = bh;
        end
    end
end

% Error bars
for c = 1:2
    errorbar(xPos(:,c), acc_means(:,c), acc_sems(:,c), 'k', 'linestyle', 'none', 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

% Significance brackets for Self vs Other
p_values = [p_acc_all, p_acc_face, p_acc_body];
yl = ylim;
yRange = yl(2) - yl(1);
bracketOffset = yRange * 0.03;
bracketTipLen = yRange * 0.015;

for g = 1:3
    if p_values(g) < 0.05
        x1 = xPos(g, 1);
        x2 = xPos(g, 2);
        maxY = max(acc_means(g,:) + acc_sems(g,:));
        bracketY = maxY + bracketOffset * 2;
        plot([x1, x1, x2, x2], [bracketY - bracketTipLen, bracketY, bracketY, bracketY - bracketTipLen], 'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
        text((x1+x2)/2, bracketY + bracketOffset * 0.5, getStars(p_values(g)), ...
            'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

% Formatting
ylabel('Mean Error (visual degrees)', 'FontSize', 11);
xticks(groupCenters);
xticklabels({'Overall', 'Face', 'Body'});
legend(barHandles, {'Self', 'Other'}, 'Location', 'NorthWest');
title('Gaze Perception Accuracy');

hold off;

fprintf('\n============================================================\n');
