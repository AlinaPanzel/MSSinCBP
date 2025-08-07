% to what extent the same subjects are the outliers acorss
% metrics? Doing a multivariate outlier approach is the way to look at
% this. this method treats each metric (column) independently (which is
% good)

% largely, subjects are NOT "repeat offenders", meaning there are only
% THREE subjects who have more than one observation identified as an
% outlier. And SIX with only one obs identified as an outlier.

% to me, this overall supports excluding outliers on a metric-by-metric
% basis, rather than dropping whole subjects. 

%% load data 
% not sure whether this is high or low -- doesn't matter too much
load('/Users/yoni/Repositories/MSSinCBP/Revisions/brain_outcomes_for_andrew.mat')

all_change = [brainmeasure_data.PRT.change_matrix; brainmeasure_data.Placebo.change_matrix; brainmeasure_data.UC.change_matrix];

[B,TFrm,TFoutlier] = rmoutliers(all_change);

%% how many outlying obs per subject? histogram
% almost all have no outliers. 
% 6 have 1, 1 has 2, 2 have 3 outliers.
histc(sum(TFoutlier,2), 0:10)'


%% how many outliers for each metric?
% 0 - 4, very reasonable and in line with manual checking i did
sum(TFoutlier,1)