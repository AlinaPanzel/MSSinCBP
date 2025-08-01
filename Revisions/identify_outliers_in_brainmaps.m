
%% load. already smoothed
datadir = '/Users/yoni/Library/CloudStorage/Dropbox/2022_multisensory_sensitization_Alina_Panzel/Writing/Submission2_AnnalsOfNeurology/Resubmission1/';
dat = fmri_data(fullfile(datadir, 'treatment_difference.nii'));


% the first 42 are PRT; the next 41 are PLA; the rest are UC
whPRT = 1:42;
whPLA = 43:83;
whUC = 84:120;

%% look at first 20
orthviews(threshold(get_wh_image(dat, 92:100), [-4 4], 'raw-outside'))

%% look at outliers

outliers(dat, 'notimeseries'); % if do seprately by group, get even more outliers...

% using mahal covariation makes more sense -- the first set of outputs --
% as it is sensitive to mean shifts in contrast maps. This finds 20 or 23
% outliers.
