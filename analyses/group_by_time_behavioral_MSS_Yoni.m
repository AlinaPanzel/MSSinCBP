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

%% find and remove the outlier that Andrew noticed

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

% Time is coded 0/1, which is correct and interpretable
% For Group convert to categorical. 
% Then create two versions: one without PLA, one without UC. For testing
% PRT vs. each control, separately
behaviour_table.Group = categorical(behaviour_table.Group);
behaviour_table.IsPRT = behaviour_table.Group == "1";

behaviour_tablePRTvsPLA = behaviour_table(behaviour_table.Group ~= "3",:);
behaviour_tablePRTvsPLA.Group = removecats(behaviour_tablePRTvsPLA.Group);

behaviour_tablePRTvsUC = behaviour_table(behaviour_table.Group ~= "2",:);
behaviour_tablePRTvsUC.Group = removecats(behaviour_tablePRTvsUC.Group);

% we see a highly sig PRT effect vs. placebo! about 6 points
fitlme(behaviour_tablePRTvsPLA, 'Rating ~ Group*Time*Intensity + (1+Time|Subject)', 'Exclude',ismember(behaviour_tablePRTvsPLA.Subject, wh_drop))

%% PRT vs combined control
fitlme(behaviour_table, 'Rating ~ IsPRT*Time + Intensity + age + gender + (Time|Subject)', 'Exclude',ismember(behaviour_table.Subject, wh_drop))

%% SUMMARY
% dropping the two outliers brings the p values from the n.s. zone into the
% marginally sig zone. Andrew's RE model must be what takes it from
% marginal zone to significant.


%% sanity/memory check: confirm that when you test subject average low and avg hi, no sig effect
% i previously (5 years ago) tested for Lo and Hi separately.


% Compute the mean of 'Value' for each combination of Subject and Time
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Intensity', 'Group', 'age', 'gender'}, 'mean', 'Rating');

T_avgPRTvsPLA = T_avg(T_avg.Group ~= "3",:);
T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= "2",:);
T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% each intensity separately: not sig
fitlme(T_avgPRTvsPLA, 'mean_Rating ~ Group*Time + age + gender + (Time|Subject)', 'Exclude', T_avgPRTvsPLA.Intensity==2)
%fitlme(T_avgPRTvsUC, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)', 'Exclude', T_avgPRTvsUC.Intensity==2)

%% sanity/memory check: confirm that when you test subject average across low/hi, no sig effect
% i also previously (5 years ago) tested subj avg, avg across Lo and Hi 
clc

% Compute the mean of 'Value' for each combination of Subject and Time
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Group', 'Intensity', 'age', 'gender'}, 'mean', 'Rating');

T_avg = T_avg(~ismember(T_avg.Subject, wh_drop),:);

T_avgPRTvsPLA = T_avg(T_avg.Group ~= 3,:);
%T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= 2,:);
%T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% each intensity separately: not sig
fitlme(T_avgPRTvsPLA, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)')
fitlme(T_avgPRTvsUC, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)')


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