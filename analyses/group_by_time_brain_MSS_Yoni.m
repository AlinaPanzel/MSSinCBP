% This script tests for tx effects on a brain variable (where we have one
% value at each timepoint), and we don't have trial level data

% load in brain data table
T_avg = vIns_table;
T_avg.Subject = str2double(cellstr(T_avg.Subject)); % convert to numeric
T_avg.Time = str2double(cellstr(T_avg.Time)); % convert to numeric

%% let's merge in age and gender

figdir = '/Users/yoni/Repositories/MSSinCBP/figures';

datadir = '/Users/yoni/Repositories/OLP4CBP/data';
load(fullfile(datadir, 'all_subjects_outcomes_demographics.mat'));
all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(all_subjects_outcomes_demographics.time==1 & all_subjects_outcomes_demographics.is_patient==1,:);

all_subjects_outcomes_demographics = all_subjects_outcomes_demographics(:, {'id', 'age', 'gender'});
all_subjects_outcomes_demographics.Properties.VariableNames{1} = 'Subject';

T_avg = join(T_avg, all_subjects_outcomes_demographics, "Keys","Subject");

%% model tx effects on subject average ratings
clc
T_avgPRTvsPLA = T_avg(T_avg.Group ~= "3",:);
T_avgPRTvsPLA.Group = removecats(T_avgPRTvsPLA.Group);

T_avgPRTvsUC = T_avg(T_avg.Group ~= "2",:);
T_avgPRTvsUC.Group = removecats(T_avgPRTvsUC.Group);

% each intensity separately: not sig
fitlme(T_avgPRTvsPLA, 'Measurement ~ Group*Time + age + gender + Intensity + (1|Subject)')
fitlme(T_avgPRTvsUC, 'Measurement ~ Group*Time + age + gender + Intensity + (1|Subject)')


%% plot
plot_MSS_group_by_time(T_avg, 'Measurement')
%print(gcf, fullfile(figdir, 'MSS_group_by_time.pdf'), '-dpdf');
