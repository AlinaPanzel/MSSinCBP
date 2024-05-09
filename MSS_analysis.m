% _________________________________________________________________________

% Multisensory sensitivity in chronic lower back pain fMRI Analysis 
%
% Author: Alina Panzel
% Last edited: 17.04.2024
% Sourcecode: Yoni Ashar, CANlab tools
%
% Analysis plan: 
%
% I. Behavioral Analysis
%    Linear Mixed Model assessing CLBP vs controls in unpleasantness
%    ratings (auditory lo/hi, pressure pain lo/hi)
%    Pearson Correlations between unpleasantness ratings and clinical pain (avg_pain
%   (BPI-item), spontaneous pain)
% 
% II.  Univariate ROI Analysis
%   (1) Unisensory: Auditory (A1,IC,MGN), Mechanical (S1) 
%   (2) Sensory integrative: Insula (Ventral- & Dorsal Anterior, Posterior)
%   (3) Higher level: medial Prefrontal Cortex, Precuneus, TPJ, posterior cingulate cortex
% 
% III. Multivariate Analysis 
%   Aversive Patterns: Common, Mechanical, Auditory
%   FM patterns: FM pain, FM multisensory stimulation
%
% IV. Brain - Behavior correlations 
%   areas displaying a significant difference between groups in BOLD
%   activity will be further correlated with the behavioral outcomes above
%
% V. Follow-up whole-brain exploratory voxel-wise analysis
%     To investigate potential MSS-related activity changes outside of
%     defined ROI regions
%
% 
% Hypothesis
%
% I. Increased sensitivity to auditory and mechnaical stimulation compared to controls 
%    Trending correlations in HC between auditory and pressure pain unpleasantness ratings, which 
%        display significance, and extend to clinical pain, in CLBP patients 
%
% II. Hypoactivation in CLBP patients in primary sensory areas, paired with hyperactivation of sensory-
%        integrative as well as self-referential areas. 
%
% III. Increased stimulus specific- as well as generalized negative aversive processing in CLBP
%      Increased activity in CLBP vs controls in FM pain and FM MSS
%      patterns
%
% IV. Hyperactivation of insula sub-areas to relate to the degree of clinical pain
%
% _________________________________________________________________________

%% Set up

% clean 
clc;
clear;

% addpath
datadir = '/Users/alinapanzel/Desktop/Dartmouth_project/acute_contrast_maps/work/ics/data/projects/wagerlab/labdata/projects/OLP4CBP/first_level';
d = struct; % struct for directories/ data
o = struct; % struct for fmriobjects
a = struct; % struct for atlas
Table = struct; % struct for result tables

% Load data & fMRI objects
d = load_data(datadir, d); % loads & sorts data into groups & conditions
o = load_fmri_objects(d, o); % loads fMRI object for each group & condition

%% I.   Behavioral Analysis

% Get metadata table & CLBP metadata including widespreadness
d = get_metadata(d);

% Plot behavioral data
plot_behavior(d);

% Demographics
Table = get_demographics(d, Table);

% Planned comparisons
Table = behavioral_analysis(d, Table, 'pain'); % Planned comparisons between CLBP vs controls (avg_pain, spon_pain) and unpleasantness ratings
Table = behavioral_analysis(d, Table, 'correlation'); % % Correlate unpleasantness ratings from acute pain and auditory stimuli in CBP vs controls
Table = behavioral_analysis(d, Table, 'variance'); % Compare variance on unpleasantness sound and pressure ratings (sanity check)


% Linear Mixed model 

% Resort data into a long format
m = (d.metadata.time == 1);
complete_data = d.metadata(m,:);

Patient = complete_data.is_patient;
ID = complete_data.id;
Gender = complete_data.gender;
Age = complete_data.age;
Avg_pp_lo = complete_data.acute_mean_thumb_lo;
Avg_pp_hi = complete_data.acute_mean_thumb_hi;
Avg_AA_lo = complete_data.acute_mean_sound_lo;
Avg_AA_hi = complete_data.acute_mean_sound_hi;

S = table(Patient, ID, Gender, Age, Avg_pp_lo, Avg_pp_hi);
PP_data_long = stack(S,{'Avg_pp_lo','Avg_pp_hi'},...
          'NewDataVariableName','Rating')

Audio = table(Patient, ID, Gender, Age, Avg_AA_lo, Avg_AA_hi);
AA_data_long = stack(Audio ,{'Avg_AA_lo','Avg_AA_hi'},...
          'NewDataVariableName','Rating')


% Fit Model

% Audio
AA_data_long.cAge = AA_data_long.Age-nanmean(AA_data_long.Age);
AA_data_long.nGroup = categorical(AA_data_long.Patient,[1 0],{'CBP','Healthy'});
AA_data_long.nGender = categorical(AA_data_long.Gender,[1 2],{'male','female'});
AA_data_long.Properties.VariableNames{5} = 'nIntensity';

AA_data_long.nGroup = categorical(AA_data_long.Patient,[0 1],{'Healthy','CBP'});
lmeNoRE = fitlme(AA_data_long,'Rating ~ cAge+nGender+nIntensity*nGroup + (1|ID)','FitMethod','REML')
[pval,F,DF1,DF2] = coefTest(lmeNoRE,[0 1 0 0 0 0],[0],'DFMethod','Satterthwaite')
[pval,F,DF1,DF2] = coefTest(lmeNoRE,[0 0 0 1 0 0],[0],'DFMethod','Satterthwaite')

% Pressure 
PP_data_long.cAge = PP_data_long.Age-nanmean(PP_data_long.Age);
PP_data_long.nGroup = categorical(PP_data_long.Patient,[1 0],{'CBP','Healthy'});
PP_data_long.nGender = categorical(PP_data_long.Gender,[1 2],{'male','female'});
PP_data_long.Properties.VariableNames{5} = 'nIntensity'

PP_data_long.nGroup = categorical(PP_data_long.Patient,[0 1],{'Healthy','CBP'});
lmeNoRE = fitlme(PP_data_long,'Rating ~ cAge+nGender+nIntensity*nGroup + (1|ID)','FitMethod','REML')
[pval,F,DF1,DF2] = coefTest(lmeNoRE,[0 1 0 0 0 0],[0],'DFMethod','Satterthwaite')
[pval,F,DF1,DF2] = coefTest(lmeNoRE,[0 0 1 0 0 0],[0],'DFMethod','Satterthwaite')


%% II. ROI: Unisensory: Auditory
% Areas of Interest: AA(A1, MGN, inferior colliculus)

% Load atlas objects
atlas_obj = load_atlas('canlab2018_2mm');
atlas_obj.labels{:,454}  = 'Bstem_IC_L'; %Rename or else it will include false areas!

% Create seperate auditory atlas subsets 
a.A1  = select_atlas_subset(atlas_obj, {'_A1_'}, 'flatten'); % Select all regions and relabel:
a.MGN = select_atlas_subset(atlas_obj, {'Thal_MGN'}, 'flatten');
a.IC  = select_atlas_subset(atlas_obj, {'Bstem_IC'}, 'flatten');

%orthviews(a.A1)

% Extract ROI averages for all subregions of both unisensory atlases
unisenareas = {'A1','MGN', 'IC'};

fields = fieldnames(o); 
for u = 1:numel(unisenareas)
    for i = 1:12  %numel(fields) % number of conditions
        r = extract_roi_averages(o.(fields{i}), a.(unisenareas{u})); 
        roi.(unisenareas{u}).(fields{i}) = cat(2, r.dat); 
    end
end

% Plot regionwise
plot_roi_groupedcolor(o,roi, 'Aud');
 
% Calculate t-tests, effectsize & CI & get results into a table
Table = get_result_table(Table, o, roi, 'Aud');

%% II. ROI: Unisensory: Mechanical 
% Areas of Interest: S1

% Load atlas objects
atlas_obj = load_atlas('canlab2018_2mm');

% Joint BA1 & BA2 S1
a.S1_L = select_atlas_subset(atlas_obj,{ '_1_L', '_2_L'}, 'flatten');
a.S1_R = select_atlas_subset(atlas_obj,{ '_1_R', '_2_R'}, 'flatten');

% Extract seperate Unisensory areas
fields = fieldnames(o); 
areas = {'S1_L' 'S1_R'};
for u = 1:numel(areas)
    for i = 1:12  %numel(fields) % number of conditions
        r = extract_roi_averages(o.(fields{i}), a.(areas{u})); 
        roi.(areas{u}).(fields{i}) = cat(2, r.dat); 
    end
end

% Plot regionwise
plot_roi_groupedcolor(o,roi, 'Mechfused');

% Calculate t-tests, effectsize & CI & get results into a table
Table = get_result_table(Table, o, roi, 'Mech');


%% II. ROI: Sensory-Integrative: Insula

% 1) Load atlas and get ROI averages

% Chang 2012 Cerebral Cortex for reference see 'mycollection' documentation
[files_on_disk, url_on_neurovault, mycollection, myimages] = retrieve_neurovault_collection(13); 

% Ventral anterior Insula
parcellation_fileVI = 'Ventral_Insula_Percent_Coherence.nii';  
label = {'Ventral_Anterior_Insula'};
a.ventral_insula = atlas(which(parcellation_fileVI), 'labels', label, ...
    'references', 'Chang 2012', 'noverbose');
a.ventral_insula.atlas_name = 'Ventral_Anterior_Insula';
%orthviews(a.ventral_insula); % for displaying purposes

% Dorsal anterior Insula
parcellation_fileDI = 'Dorsal_Insula_Percent_Coherence.nii';  
label = {'Dorsal_Anterior_Insula'};
a.dorsal_insula = atlas(which(parcellation_fileDI), 'labels', label, ...
    'references', 'Chang 2012', 'noverbose');
a.dorsal_insula.atlas_name = 'Dorsal_Anterior_Insula';
%orthviews(a.dorsal_insula);

% Posterior Inusla
parcellation_filePI = 'Posterior_Insula_Percent_Coherence.nii';  
label = {'Posterior_Insula'};
a.posterior_insula = atlas(which(parcellation_filePI), 'labels', label, ...
    'references', 'Chang 2012', 'noverbose');
a.posterior_insula.atlas_name = 'Posterior_Insula';
%orthviews(a.posterior_insula);

% mirror insula regions as atlas above does not include both hemispheres

% flip works with an image_vector, so convert from atlas to image_vector
rVI_dat = region2fmri_data(atlas2region(a.ventral_insula), fmri_data(which(parcellation_fileVI)));
rDI_dat = region2fmri_data(atlas2region(a.dorsal_insula), fmri_data(which(parcellation_fileDI)));
rPI_dat = region2fmri_data(atlas2region(a.posterior_insula), fmri_data(which(parcellation_filePI)));

% flip
lVI_dat = flip(rVI_dat);
lDI_dat = flip(rDI_dat);
lPI_dat = flip(rPI_dat);

% combine left and right
a.m_ventral_insula = image_math(rVI_dat,lVI_dat,'plus');
a.m_dorsal_insula = image_math(rDI_dat,lDI_dat,'plus');
a.m_posterior_insula = image_math(rPI_dat,lPI_dat,'plus');

% transform back into an atlas 
a.m_ventral_insula = atlas(a.m_ventral_insula);
a.m_dorsal_insula = atlas(a.m_dorsal_insula);
a.m_posterior_insula = atlas(a.m_posterior_insula);

% Extract ROI averages for all mirrored insula subregions 
fields = fieldnames(o); 
for i = 1:numel(fields)
    % Ventral Anterior Insula
    r = extract_roi_averages(o.(fields{i}), a.m_ventral_insula); 
    roi.m_ventral_insula.(fields{i}) = cat(2, r.dat);  
    % Dorsal Anterior Insula 
    r = extract_roi_averages(o.(fields{i}), a.m_dorsal_insula); 
    roi.m_dorsal_insula.(fields{i}) = cat(2, r.dat);   
    % Posterior Insula 
    r = extract_roi_averages(o.(fields{i}), a.m_posterior_insula); 
    roi.m_posterior_insula.(fields{i}) = cat(2, r.dat);   
end

% plot grouped colors
plot_roi_groupedcolor(o, roi, 'm_insula')

% Conduct t-tests, get results in table
Table = get_result_table(Table, o, roi, 'm_insula');


%% II. ROI: Self-referential 
% Areas of Interest: mPFC, PCC,  Precuneus

% Load atlas objects
atlas_obj = load_atlas('canlab2018_2mm');

% Create seperate atlas subsets 
a.mPFC          = select_atlas_subset(atlas_obj, {'10'}, 'flatten');
a.PCC           = select_atlas_subset(atlas_obj, {'23a', '23d'}, 'flatten');
a.precuneus     = select_atlas_subset(atlas_obj, {'_7m', '_7Pm'}, 'flatten');

                
%orthviews(a.precuneus)

% Extract ROI averages for all subregions of both unisensory atlases
selfrefareas = {'mPFC', 'PCC', 'precuneus'}; %'PCC','precuneus'

fields = fieldnames(o); 
for u = 1:numel(selfrefareas)
    for i = 1:12  %numel(fields) % number of conditions
        r = extract_roi_averages(o.(fields{i}), a.(selfrefareas{u})); 
        roi.(selfrefareas{u}).(fields{i}) = cat(2, r.dat); 
    end
end

% Plot regionwise
plot_roi_groupedcolor(o, roi, 'Selfref');
 
% Calculate t-tests, effectsize & CI & get results into a table
Table = get_result_table(Table, o, roi, 'Selfref');


%% III:  Multivariate: Aversive Patterns 

% Load aversive patterns for each group & condition
fields = fieldnames(o);
for i = 1:12
    prexps.(fields{i}) = apply_multiaversive_mpa2_patterns(o.(fields{i})); 
end

% Plot pattern expressions
plot_mvpa_groupedcolor(o, prexps, 'NegAffect');

% Planned comparisons
Table = run_mvpa_plannedcomparisons(o, Table, prexps, 'NegAffect');

%saveas(gcf, 'Aversive_patterns.png')



%% III:  Multivariate: FM patterns 

fields = fieldnames(o);
for i = 1:12
    pat_tabl.(fields{i}) = apply_FM_patterns(o.(fields{i}), 'cosine_similarity'); 
end

% Plot pattern expressions
plot_mvpa_groupedcolor(o, pat_tabl, 'FM');

%saveas(gcf, 'FM_patterns.png')

% Planned comparisons
Table = run_mvpa_plannedcomparisons(o, Table, pat_tabl, 'FM');


%% IV.   Brain - Behavior Correlations

% Get metadata table & CLBP metadata including widespreadness
d = get_metadata(d);

% Correlate Brain activity with Behaviour in conditions where a significant difference between CLBP and HC was found: 
% A1: Sound low/high 
% Ventral Anterior Insula: Pressure low/intensity, Sound high
% Dorsal Anterior Insula: Sound low/high
% Posterior Insula: Sound low/high, pressure intensity
Table = correlate_brain_behavior(Table, o, d, roi, 'brainbehavior'); % relation to clinical pain
Table = correlate_brain_behavior(Table, o, d, roi, 'meanpain'); % relation to stimulus pain


%% V.  Follow-up exploratory voxelwise analysis 

% Select data
condition = {'all_s_l', 'all_s_h', 'all_t_l', 'all_t_h'};

dat = o.(condition{1}); %  hardcoded as crashing potential in loop

% Smooth data
dat_smooth = preprocess(dat,'smooth', 6);

% Create the dummy variable
group_dummy_variable = [ones(142, 1); -1*ones(51, 1)];
variable_names = {'GroupDummy', 'Intercept'};

% Calculate weights
weights_for_ones = 1 / 142;
weights_for_minus_ones = -1 / 51;

% Apply weights
group_dummy_variable(1:142) = weights_for_ones;
group_dummy_variable(143:end) = weights_for_minus_ones;

% Confirm mean is 0 
mean_after = mean(group_dummy_variable);
disp(mean_after)

% for visualization
% write(t, 'fname', 'fname.nii','thresh') command

% Combine & run regression
dat_smooth.X =  group_dummy_variable;
grey_matter_mask = fmri_data(which('gray_matter_mask.nii'));
grey_matter_mask.dat = grey_matter_mask.dat > .3;
dat_smooth_masked = apply_mask(dat_smooth, grey_matter_mask);
out = regress(dat_smooth_masked, 'variable_names', variable_names, .001, 'unc', 'k', 10, 'robust'); % .001, 'unc', 'k', 10 in greymatter mask

% Select the predictor image we care about: (the 2nd/last image is the intercept)
t = select_one_image(out.t, 1);

orthviews(out.t)

% Select the Success regressor map
r = region(out.t);

% Autolabel regions and print a table
r = table(r);

% display on a series of slices and surfaces
figure;
o2 = montage(t, 'trans', 'full', 'parent');
snapnow







