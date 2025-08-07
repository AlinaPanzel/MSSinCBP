% in this file, i spend some time staring at data points and thinking about
% how to deal with outliers

% conclusion from staring at 'sound' pattern: one person is identified as
% an outlier in change scores, whether looking within PLA or across all
% groups. Dropping that 1 person won't explain the overall pattern of
% placebo elevation at baseline. It looks like placebo simply really is
% elevated at baseline (not outlier-driven), and that there's a good deal
% of variability in data at pre and at post and in change scores.
% test-retest looks reasonable, and confirms the one outlier inflating
% placebo reductions. This one outlier could make a difference on a
% marginal p value but doesn't change overall pattern of change.

% conclusion from staring at 'general' pattern: there really are stable
% ind diffs, so seems risky/wrong to exclude ppl based on pre or post
% alone, as those might be "true" or near-true values. Better to exclude
% based on change scores. In change scores, i see one obvious outlier
% in UC, who has a likely-artifical large increase. If you account for
% this, you'll probably see *all* groups decreasing, instead of only PRT
% and PLA decreasing. So this will work against a PRT vs UC effect.

% staring at mPFC: outliers are exagerating a potential PRT vs UC effect

% staring at precuneus: relatively less impact of outliers, just 1, and its
% "working against" the potential PRT effect so removing will help

%% load data 
% not sure whether this is high or low -- doesn't matter too much
load('/Users/yoni/Repositories/MSSinCBP/Revisions/brain_outcomes_for_andrew.mat')

%% pick a metric
metric = 'precuneus';

%% plot pre and post
create_figure('ya', 2,2); 

when = 'pre';
violinplot({brainmeasure_data.PRT.(when).(metric), brainmeasure_data.Placebo.(when).(metric), brainmeasure_data.UC.(when).(metric)}, 'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'});
legend off
ylabel(metric)
set(gca, 'FontSize', 18)
title(when)

subplot(2,2,2)
when = 'post';
violinplot({brainmeasure_data.PRT.(when).(metric), brainmeasure_data.Placebo.(when).(metric), brainmeasure_data.UC.(when).(metric)}, 'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'});
legend off
ylabel(metric)
set(gca, 'FontSize', 18)
title(when)

%% plot change scores

subplot(2,2,3)
title('Pre to Post Change')
fn = fieldnames(brainmeasure_data.PRT.pre);                 % cell-array of field names
idx = find(strcmp(metric, fn), 1);   

cellarr = {brainmeasure_data.PRT.change_matrix(:,idx), brainmeasure_data.Placebo.change_matrix(:,idx), brainmeasure_data.UC.change_matrix(:,idx)};
violinplot(cellarr, 'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'});
legend off
ylabel(metric)
set(gca, 'FontSize', 18)

%% find outliers in change scores, testing across all groups
arr = vertcat(cellarr{:});
[B, wh_out] = rmoutliers(arr);
arr(wh_out)

%% test retest: gscatter

subplot(2,2,4)
when = 'pre';
pre = {brainmeasure_data.PRT.(when).(metric), brainmeasure_data.Placebo.(when).(metric), brainmeasure_data.UC.(when).(metric)};
pre = vertcat(pre{:});

when = 'post';
post = {brainmeasure_data.PRT.(when).(metric), brainmeasure_data.Placebo.(when).(metric), brainmeasure_data.UC.(when).(metric)};
post = vertcat(post{:});

% build grouping labels
g = [ repmat({'PRT'}, numel(brainmeasure_data.PRT.pre.A1), 1);
      repmat({'PLA'}, numel(brainmeasure_data.Placebo.pre.A1), 1);
      repmat({'UC'}, numel(brainmeasure_data.UC.pre.A1), 1) ];

% plot
gscatter(pre, post, g, 'rgb', 'osd', 8);
xlabel('Pre'); ylabel('Post');
legend('Location','best');
hold on;

% 4) add one least-squares line per group
h = lsline;                          % fits and plots lines
for k = 1:numel(h)
    h(k).LineWidth = 2;              % thicken them
    % (optional) match marker color:
    % h(k).Color = get(gca,'ColorOrder')(k,:);
end

hold off;

%% save

repodir = '/Users/yoni/Repositories/MSSinCBP/';
figdir = fullfile(repodir, 'Revisions', 'figures');

exportgraphics(gcf, fullfile(figdir, ['outliers_' metric '.pdf']), 'ContentType', 'vector')

% plot_logitudinal_auditory_modifiability('MVPA_NA', 