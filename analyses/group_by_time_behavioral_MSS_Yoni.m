% let's merge in age and gender


figdir = '/Users/yoni/Repositories/MSSinCBP/figures';

datadir = '/Users/yoni/Repositories/OLP4CBP/data';
load(fullfile(datadir, 'all_subjects_outcomes_demographics.mat'));
all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(all_subjects_outcomes_demographics.time==1 & all_subjects_outcomes_demographics.is_patient==1,:);

all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(:, {'id', 'age', 'gender'});
all_subjects_outcomes_demographics.Properties.VariableNames{1} = 'Subject';

behaviour_table = join(behaviour_table, all_subjects_outcomes_demographics, "Keys","Subject");

%% modeling

% Time is coded 0/1, which is correct and interpretable
% For Group convert to categorical. 
% Then create two versions: one without PLA, one without UC. For testing
% PRT vs. each control, separately
behaviour_table.Group = categorical(behaviour_table.Group);

behaviour_tablePRTvsPLA = behaviour_table(behaviour_table.Group ~= "3",:);
behaviour_tablePRTvsPLA.Group = removecats(behaviour_tablePRTvsPLA.Group);

behaviour_tablePRTvsUC = behaviour_table(behaviour_table.Group ~= "2",:);
behaviour_tablePRTvsUC.Group = removecats(behaviour_tablePRTvsUC.Group);

% we see a highly sig PRT effect vs. placebo! about 6 points
fitlme(behaviour_tablePRTvsPLA, 'Rating ~ Group*Time + Intensity + age + gender + (1|Subject)')

%% we see a highly sig PRT effect vs. UC! about 6 points as well
fitlme(behaviour_tablePRTvsUC, 'Rating ~ Group*Time + Intensity + age + gender + (1|Subject)')



%% sanity/memory check: confirm that when you test subject average low and avg hi, no sig effect
% i previously (5 years ago) tested for Lo and Hi separately.
clc

% Compute the mean of 'Value' for each combination of Subject and Time
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Intensity', 'Group', 'age', 'gender'}, 'mean', 'Rating');

T_avgPRTvsPLA = T_avg(T_avg.Group ~= "3",:);
T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= "2",:);
T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% each intensity separately: not sig
fitlme(T_avgPRTvsPLA, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)', 'Exclude', T_avgPRTvsPLA.Intensity==2)
fitlme(T_avgPRTvsUC, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)', 'Exclude', T_avgPRTvsUC.Intensity==2)

%% sanity/memory check: confirm that when you test subject average across low/hi, no sig effect
% i also previously (5 years ago) tested subj avg, avg across Lo and Hi 
clc

% Compute the mean of 'Value' for each combination of Subject and Time
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Group', 'age', 'gender'}, 'mean', 'Rating');

T_avgPRTvsPLA = T_avg(T_avg.Group ~= "3",:);
T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= "2",:);
T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% each intensity separately: not sig
fitlme(T_avgPRTvsPLA, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)')
fitlme(T_avgPRTvsUC, 'mean_Rating ~ Group*Time + age + gender + (1|Subject)')


%% plot
plot_MSS_group_by_time(T_avg, 'mean_Rating')
print(gcf, fullfile(figdir, 'MSS_group_by_time.pdf'), '-dpdf');


%% plot ratings in PRT by subject ID, to confirm no time/order effect
T_avgPRT = T_avg(T_avg.Group=='1' & T_avg.Intensity==1,:);
figure;
boxplot(T_avgPRT.mean_Rating, T_avgPRT.Subject);
xlabel('Subject');
ylabel('Value');
title('Box Plot of Value by Subject');