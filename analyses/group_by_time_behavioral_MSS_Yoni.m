% let's merge in age and gender

figdir = '/Users/yoni/Repositories/MSSinCBP/figures';

datadir = '/Users/yoni/Repositories/OLP4CBP/data';
load(fullfile(datadir, 'all_subjects_outcomes_demographics.mat'));
all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(all_subjects_outcomes_demographics.time==1 & all_subjects_outcomes_demographics.is_patient==1,:);

all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(:, {'id', 'age', 'gender'});
all_subjects_outcomes_demographics.Properties.VariableNames{1} = 'Subject';

load(fullfile(fileparts(figdir), 'data', 'behavioural_sound_ratings_all.mat'))
behaviour_table = sound_table;
behaviour_table = join(behaviour_table, all_subjects_outcomes_demographics, "Keys","Subject");

%% find and remove the two outliers that Andrew noticed

% compute average per person per timepoint, averaging across trials and
% intensities
Tavg = groupsummary(behaviour_table, {'Subject','Group','Time','age','gender'}, 'mean','Rating');

% now compute change score per person -- pivot to wide format

% Pivot so that Time becomes separate columns
Tw = unstack(Tavg, 'mean_Rating', 'Time');
Tw.Change = Tw.x1 - Tw.x0;

figure, scatter(1:height(Tw),sort(Tw.Change))
ylabel('Pre-to-Post Change Scores')
xlabel('Subjects')
set(gca, 'FontSize', 24)

%% 1 min and 1 max outlier
tmp = Tw(Tw.Change == min(Tw.Change) | Tw.Change == max(Tw.Change),:)

wh_drop = tmp.Subject'

%% modeling
clc

% Time is coded 0/1, which is correct and interpretable
% For Group convert to categorical. 
% Then create two versions: one without PLA, one without UC. For testing
% PRT vs. each control, separately
behaviour_table.Group = categorical(behaviour_table.Group);
behaviour_table.Time = categorical(behaviour_table.Time);
behaviour_table.Intensity = categorical(behaviour_table.Intensity);

% This here below is the simple version of Andrew's model, which gives p =
% .06 for PRT vs PLA. You have to include a main effect of Group.
% Otherwise, groups are forced to have the same baseline value, and all you
% estimating is group difference from that forced-same baseline value to
% the post-treatment value. If groups are similar at post-tx, there will be
% no sig Group x Time. Once you include a main effect of Group (eg at
% baseline), the slope for each group can have a different baseline value,
% then going to post-treatment, you estimate a DiD model which is what you
% want.
fitlme(behaviour_table, 'Rating ~ Group + Time + Intensity + Group:Time + (1+Time|Subject)', 'Exclude', ismember(behaviour_table.Subject, wh_drop))


%% SUMMARY
% dropping the two outliers brings the p values from the n.s. zone into the
% marginally sig zone. Andrew's RE model must be what takes it from
% marginal zone to significant.


%% sanity/memory check: confirm that when you test subject average low and avg hi, no sig effect
clc

% Compute the mean of 'Value' for each combination of Subject and Time
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Intensity', 'Group', 'age', 'gender'}, 'mean', 'Rating');

T_avg.isprt = T_avg.Group=='1';
fitlme(T_avg, 'mean_Rating ~ Group*Time + Intensity + (Time|Subject)', 'Exclude', ismember(T_avg.Subject, wh_drop))


% OK, the real issue is: 5 years ago, I did NOT check for outliers. I don't
% need to model each trial separately. Its totally fine to average them.
% What I need to do is: 1) check for outliers, 2) put ALL the data in the
% same model -- both control groups, and both intensities


%% plot
plot_MSS_group_by_time(T_avg(T_avg.Intensity==2,:), 'mean_Rating')
title('Hi')
%print(gcf, fullfile(figdir, 'MSS_group_by_time.pdf'), '-dpdf');


%% plot ratings in PRT by subject ID, to confirm no time/order effect
T_avgPRT = T_avg(T_avg.Group=='1' & T_avg.Intensity==1,:);
figure;
boxplot(T_avgPRT.mean_Rating, T_avgPRT.Subject);
xlabel('Subject');
ylabel('Value');
title('Box Plot of Value by Subject');