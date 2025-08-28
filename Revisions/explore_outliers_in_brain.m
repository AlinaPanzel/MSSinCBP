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
load('/Users/yoni/Repositories/MSSinCBP/Revisions/Brain_measures_longformat_all_26.08.25.mat')

%% pick a metric, make some helpful vars
metric = 'precuneus';
my_con_long_all = con_long_all(con_long_all.measure==metric,:);

wh1 = my_con_long_all.group==1;
wh2 = my_con_long_all.group==2;
wh3 = my_con_long_all.group==3;

wh_pre = my_con_long_all.timepoint==1;
wh_post = my_con_long_all.timepoint==2;

%% plot pre and post
create_figure('outliers', 2,2); 

when = 'pre';
violinplot({my_con_long_all.value(wh1 & wh_pre), my_con_long_all.value(wh2 & wh_pre), my_con_long_all.value(wh3 & wh_pre) }, 'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'});
legend off
ylabel(metric)
set(gca, 'FontSize', 18)
title(when)

subplot(2,2,2)
when = 'post';
violinplot({my_con_long_all.value(wh1 & wh_post), my_con_long_all.value(wh2 & wh_post), my_con_long_all.value(wh3 & wh_post) }, 'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'});
legend off
ylabel(metric)
set(gca, 'FontSize', 18)
title(when)


%% change scores
subplot(2,2,3)

wide = unstack(my_con_long_all, 'value', 'timepoint');
wide.change = wide.x2 - wide.x1;
violinplot({wide.change(wide.group==1), wide.change(wide.group==2), wide.change(wide.group==3)},  'mc','k', 'medc', 'r', 'xlabel', {'PRT' 'PLA' 'UC'})
title('pre to post change')
set(gca, 'FontSize', 18)
legend off
ylabel(metric)

% time 1 and 2 scatter
subplot(2,2,4)
gscatter(wide.x1, wide.x2, wide.group)
lsline
legend off
xlabel('Pre'), ylabel('Post')
set(gca, 'FontSize', 18)

% plot correlation within group
% Compute and annotate correlations for each group
hold on
groups = unique(wide.group);
colors = lines(numel(groups));

for i = 1:numel(groups)
    g = groups(i);
    idx = wide.group == g;
    x = wide.x1(idx);
    y = wide.x2(idx);

    % correlation
    r = corr(x, y, 'Rows','complete');

    % find position for text (upper left of this group’s cluster)
    xpos = min(wide.x1) + 0.05*range(wide.x1);
    ypos = max(wide.x2) - (0.05*range(wide.x2)*i);

    % place text in group color
    text(xpos, ypos, sprintf('Group %d: r=%.2f', g, r), ...
        'Color', colors(i,:), 'FontSize', 14, 'FontWeight','bold');
end
hold off