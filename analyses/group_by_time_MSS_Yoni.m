% let's merge in age and gender


datadir = '/Users/yoni/Repositories/OLP4CBP/data';
load(fullfile(datadir, 'all_subjects_outcomes_demographics.mat'));
all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(all_subjects_outcomes_demographics.time==1 & all_subjects_outcomes_demographics.is_patient==1,:);

all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(:, {'id', 'age', 'gender'});
all_subjects_outcomes_demographics.Properties.VariableNames{1} = 'Subject';

behaviour_table = join(behaviour_table, all_subjects_outcomes_demographics, "Keys","Subject");

%% modelling

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


%% just for my own sanity, confirm that when you test subject averages, no sig effect
% Compute the mean of 'Value' for each combination of Subject and Time
clc
T_avg = groupsummary(behaviour_table, {'Subject','Time', 'Intensity', 'Group', 'age', 'gender'}, 'mean', 'Rating');

T_avgPRTvsPLA = T_avg(T_avg.Group ~= "3",:);
T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= "2",:);
T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% we see a highly sig PRT effect vs. placebo! about 6 points
fitlme(T_avgPRTvsPLA, 'mean_Rating ~ Group*Time + Intensity + age + gender + (1|Subject)')

% we see a highly sig PRT effect vs. placebo! about 6 points
fitlme(T_avgPRTvsUC, 'mean_Rating ~ Group*Time + Intensity + age + gender + (1|Subject)')