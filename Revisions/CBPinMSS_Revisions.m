%% Revisions of: Neural Mechanisms of Multisensory Sensitivity in Chronic Back Pain

% Author: Alina Panzel
% Last Date of Changes: 01.04.2025

% 

%% Editorial Comment: Modifiability of auditory hypersensitivity in CBP

% Assessment of treatment effect on longitudinal outcome, will sort into 3
% groups (see initial clinical study) and get 1st and 2nd session, then repeat ROI and MVPA analysis and see if
% treatment/time modified increased auditory activity in CBP 

% clean 
clc;
clear;

% addpath
%addpath(genpath('/Users/alinapanzel/Desktop/Dartmouth_project'))
%datadir = '/Users/alinapanzel/Desktop/Dartmouth_project/acute_contrast_maps/work/ics/data/projects/wagerlab/labdata/projects/OLP4CBP/first_level';

% set structs
d = struct; % struct for directories/ data
o = struct; % struct for fmriobjects
a = struct; % struct for atlas

% Get metadata table
d = get_metadata(d);

% Sorts, loads and gets longitudinal fMRI and behavioral metadata 
[d, lo] = get_longitudinal_auditory_modifiability(d, datadir);



%% -------  Behavioral Analysis  --------

% Plot & significant tasts (ttests) Auditory unpleasantness ratings
plot_logitudinal_auditory_modifiability('Behaviour', d)

% Prepare data for self-report analysis, sorts into seperate tables
[PRTvsPLA_sound, PRTvsUC_sound, PRTvsPLA_pressure, PRTvsUC_pressure] = prep_behavioural_data(d);

% Random intercept only (Yoni's approach on github)
fitlme(PRTvsPLA_sound, 'Rating ~ Group*Time + Intensity + Age + Gender + (1|Subject)')

% Added random slope for Time
% This is how i did it in my model and i think it makes sense here to
% allow for individual differences in how the subjects change over time no?
fitlme(PRTvsPLA_sound, 'Rating ~ Group*Time + Intensity + Age + Gender + (Time|Subject)')

%Re: looking at the AIC and BIC and loglikelihood, the second model also
%performs much better, which suggests that there are large individual
%differences

% AIC: 12779 vs 13940 (lower is better)
% BIC: 12839 vs 13988 (lower is better)
% LogLikelihood: -6378.7 vs -6960.9 (higher is better)

% When controlling for this, the effect is not significant anymore 
% Same thing for PRTvsUC

% Lets do assumption check

% Get the bestfitting model
model = fitlme(PRTvsPLA_sound, 'Rating ~ Group*Time + Intensity + Age + Gender + (Time|Subject)');

% Residual normality
figure;
subplot(2,2,1);
histogram(residuals(model), 30);
title('Residual Distribution');
subplot(2,2,2);
qqplot(residuals(model));
title('Q-Q Plot of Residuals');

% Residuals vs fitted
subplot(2,2,3);
scatter(fitted(model), residuals(model), 'o');
hold on;
plot([min(fitted(model)), max(fitted(model))], [0, 0], 'r-');
title('Residuals vs Fitted Values');
xlabel('Fitted Values'); ylabel('Residuals');

% Homoscedasticity by group
subplot(2,2,4);
boxplot(residuals(model), PRTvsPLA_sound.Group);
title('Residuals by Group');

% Residual distribution; minor positive skew but looks good
% QQ plot; slight deviations but looks good
% Residuals vs fitted values: no sign of heteroscedasticity or
% nonlinearness
% Residual  by group also looks similar


% Compare results for different subsets
% Low intensity only
model_low = fitlme(PRTvsPLA_sound(PRTvsPLA_sound.Intensity == 1, :), ...
    'Rating ~ Group*Time + Age + Gender + (Time|Subject)');

% High intensity only
model_high = fitlme(PRTvsPLA_sound(PRTvsPLA_sound.Intensity == 2, :), ...
    'Rating ~ Group*Time + Age + Gender + (Time|Subject)');

% Display coefficients side by side
disp('Low Intensity Results:');
disp(model_low.Coefficients);
disp('High Intensity Results:');
disp(model_high.Coefficients);

% Similarities: PRT group shows more improvement over time, No GroupxTime
% interaction, consistent gender effect, no age effect

% Differences: Baseline ratings (expectedly)
% -> makes sense to move on with combined model for power

% Check for session order effects within subjects
% Calculate mean change scores by subject
subj_means = groupsummary(PRTvsPLA_sound, {'Subject','Time','Group'}, 'mean', 'Rating');
subj_wide = unstack(subj_means, 'mean_Rating', 'Time');
subj_wide.Properties.VariableNames(end-1:end) = {'Time0', 'Time1'};
subj_wide.change = subj_wide.Time1 - subj_wide.Time0;

% Plot change scores by subject ID to check for time/order effects
figure;
scatter(1:height(subj_wide), subj_wide.change, 50, categorical(subj_wide.Group), 'filled');
hold on;
plot([1, height(subj_wide)], [0, 0], 'k--');
legend('PRT', 'Placebo');
title('Change in Ratings by Subject');
xlabel('Subject Index'); ylabel('Change (Time1 - Time0)');


% High individual variation in treatment response (-90 to 40) -> reinforces argument that we
% should use random slopes model over random intercepts (-> even looks like
% we could split into "responders" and "non-responders")


% Create summary statistics and plot group means

% Get unique values for grouping variables
unique_groups = unique(PRTvsPLA_sound.Group);
unique_times = unique(PRTvsPLA_sound.Time);
unique_intensities = unique(PRTvsPLA_sound.Intensity);

% Create arrays to store results
num_groups = length(unique_groups);
num_times = length(unique_times);
num_intensities = length(unique_intensities);

means = nan(num_groups, num_times, num_intensities);
sems = nan(num_groups, num_times, num_intensities);
counts = nan(num_groups, num_times, num_intensities);

% Calculate statistics for each combination
for g = 1:num_groups
    for t = 1:num_times
        for i = 1:num_intensities
            % Get current values
            curr_group = unique_groups(g);
            curr_time = unique_times(t);
            curr_intensity = unique_intensities(i);
            
            % Find matching data
            idx = PRTvsPLA_sound.Group == curr_group & ...
                  PRTvsPLA_sound.Time == curr_time & ...
                  PRTvsPLA_sound.Intensity == curr_intensity;
            
            % Calculate statistics if data exists
            if any(idx)
                means(g, t, i) = mean(PRTvsPLA_sound.Rating(idx), 'omitnan');
                sems(g, t, i) = std(PRTvsPLA_sound.Rating(idx), 'omitnan') / sqrt(sum(~isnan(PRTvsPLA_sound.Rating(idx))));
                counts(g, t, i) = sum(idx);
            end
        end
    end
end

% Plot results
figure;
colors = [0.2 0.6 0.8; 0.8 0.4 0.2]; % Blue for PRT, Orange for Placebo

for i = 1:num_intensities
    subplot(1, num_intensities, i);
    
    for g = 1:num_groups
        % Get x values (time)
        x_values = unique_times;
        
        % Get y values (means) for this group and intensity
        y_values = squeeze(means(g, :, i));
        
        % Get error values
        error_values = squeeze(sems(g, :, i));
        
        % Plot
        errorbar(x_values, y_values, error_values, '-o', ...
            'LineWidth', 2, 'Color', colors(g,:), 'MarkerFaceColor', colors(g,:));
        hold on;
    end
    
    title(['Intensity Level ' num2str(unique_intensities(i))]);
    xlabel('Session (0=Pre, 1=Post)');
    ylabel('Unpleasantness Rating');
    legend('PRT', 'Placebo', 'Location', 'best');
    grid on;
    set(gca, 'XTick', unique_times);
    
    % Set consistent y-limits across subplots
    all_means = means(:);
    all_sems = sems(:);
    valid_idx = ~isnan(all_means) & ~isnan(all_sems);
    y_min = min(all_means(valid_idx) - all_sems(valid_idx)) - 5;
    y_max = max(all_means(valid_idx) + all_sems(valid_idx)) + 5;
    ylim([y_min y_max]);
end

sgtitle('Change in Auditory Sensitivity by Treatment Group and Intensity');



%% ----------  ROI Analysis  -----------

% NOTE: for ROI analysis, atlases need to be loaded from main fMRI MSSinCBP
% script

% Conduct analysis
% Loop through ROIs of comparison interest
areas = {'A1','m_ventral_insula', 'm_dorsal_insula', 'm_posterior_insula', 'mPFC', 'precuneus'};
sessions = {'S1','S2'};
Treatment = {'G1' 'G2' 'G3'};
field = fieldnames(lo.G1.S1);

for n = 1:numel(Treatment)
    for s = 1:numel(sessions)
        for u = 1:numel(areas)
            for i = 1:numel(field)  %numel(fields) % number of conditions
                r = extract_roi_averages(lo.(Treatment{n}).(sessions{s}).(field{i}), a.(areas{u})); 
                lo.roi.(Treatment{n}).(sessions{s}).(areas{u}).(field{i}) = cat(2, r.dat); 
            end
        end
    end
end

% Plot ROI Analysis
plot_logitudinal_auditory_modifiability('ROI', d, lo)

% Prep data for LMM

% Prepare ROI data for insula
[A1_pressure_table, A1_sound_table]               = prep_roi_data(lo, d, 'A1');
[vIns_pressure_table, vIns_sound_table]           = prep_roi_data(lo, d, 'm_ventral_insula');
[dIns_pressure_table, dIns_sound_table]           = prep_roi_data(lo, d, 'm_dorsal_insula');
[pIns_pressure_table, pIns_sound_table]           = prep_roi_data(lo, d, 'm_posterior_insula');
[precuneus_pressure_table, precuneus_sound_table] = prep_roi_data(lo, d, 'precuneus');
[mPFC_pressure_table, mPFC_sound_table]           = prep_roi_data(lo, d, 'mPFC');




%% --------    MVPA Pattern Analysis  ---------

fields = fieldnames(lo.G1.S1);
group = {'G1','G2','G3'};
session = {'S1','S2'};

for g = 1:numel(group)
    for s = 1:numel(session)
        for i = 1:numel(fields)
            pat_tabl.(group{g}).(session{s}).(fields{i}) = apply_FM_patterns(lo.(group{g}).(session{s}).(fields{i}), 'cosine_similarity'); % Fibromyalgia patterns
            prexps.(group{g}).(session{s}).(fields{i}) = apply_multiaversive_mpa2_patterns(lo.(group{g}).(session{s}).(fields{i})); % Negative affect patterns
        end
    end 
end

% Plot MVPA Analysis
plot_logitudinal_auditory_modifiability('MVPA_NA', d, lo, prexps) % Negative affect
plot_logitudinal_auditory_modifiability('MVPA_FM', d, lo, prexps, pat_tabl) % Fibromyalgia patterns

% Prepare MVPA data for LMM
[na_common_sound_table, na_common_pressure_table] = prep_mvpa_data(prexps, d, 'general');
[na_auditory_sound_table, na_auditory_pressure_table] = prep_mvpa_data(prexps, d, 'sound');

[fm_pain_sound_table, fm_pain_pressure_table] = prep_mvpa_data(pat_tabl, d, 'FM_PAIN');
[fm_mss_sound_table, fm_mss_pressure_table] =  prep_mvpa_data(pat_tabl, d, 'FM_MSS');


% 
% % FM_MSS pattern expression data
% data_tables_pattern = struct();
% data_tables_pattern.combined = fm_mss_table;
% data_tables_pattern.low = fm_mss_table(fm_mss_table.Intensity == 1, :);
% data_tables_pattern.high = fm_mss_table(fm_mss_table.Intensity == 2, :);
% 
% lmm_fm_mss = fit_mixed_effects_models(data_tables_pattern,
% 'PatternExpression', true); 

% 
% % FM_PAIN pattern expression data
% data_tables_pattern = struct();
% data_tables_pattern.combined = fm_pain_table;
% data_tables_pattern.low = fm_pain_table(fm_pain_table.Intensity == 1, :);
% data_tables_pattern.high = fm_pain_table(fm_pain_table.Intensity == 2, :);
% 
% lmm_fm_pain = fit_mixed_effects_models(data_tables_pattern, 'PatternExpression', true);
% 





% %% ---------  Correlational analysis ---------
% 
% % This was not specifically asked for, but is sensible to interpret the
% % findings form above.
% 
% 
% % Define Groups & ROIs
% groups = {'G1', 'G2', 'G3'};
% rois = {'precuneus', 'mPFC'};
% conditions = {'s_l', 's_h'}; % Sound Low & Sound High
% 
% % Initialize results storage
% correlation_results = struct();
% 
% % Loop through each group
% for g = 1:length(groups)
%     group = groups{g};
% 
%     % Compute change in back pain for this group
%     delta_backpain = d.(group).S2.bpi_intensity - d.(group).S1.bpi_intensity;
% 
%     % Compute change in auditory VAS ratings
%     delta_auditory_sl = d.(group).S2.acute_mean_sound_lo - d.(group).S1.acute_mean_sound_lo;
%     delta_auditory_sh = d.(group).S2.acute_mean_sound_hi - d.(group).S1.acute_mean_sound_hi;
% 
%     % Correlate delta back pain with delta auditory sensitivity (Sound Low & High)
%     for c = 1:length(conditions)
%         condition = conditions{c};
% 
%         % Select the correct delta auditory VAS
%         if strcmp(condition, 's_l')
%             delta_auditory = delta_auditory_sl;
%         else
%             delta_auditory = delta_auditory_sh;
%         end
% 
%         % Remove NaN values to ensure valid correlation
%         valid_idx = ~isnan(delta_backpain) & ~isnan(delta_auditory);
%         clean_backpain = delta_backpain(valid_idx);
%         clean_auditory = delta_auditory(valid_idx);
%         n_bp = sum(valid_idx); % Sample size
%         df_bp = n_bp - 2; % Degrees of freedom
% 
%         % Compute correlation only if at least 2 valid data points
%         if n_bp >= 2
%             [r_bp, p_bp] = corr(clean_backpain, clean_auditory, 'Type', 'Pearson');
%         else
%             r_bp = NaN;
%             p_bp = NaN;
%         end
% 
%         % Store results
%         correlation_results.(group).backpain_vs_auditory.(condition).r = r_bp;
%         correlation_results.(group).backpain_vs_auditory.(condition).p = p_bp;
%         correlation_results.(group).backpain_vs_auditory.(condition).df = df_bp;
%         correlation_results.(group).backpain_vs_auditory.(condition).n = n_bp;
%         % Print results for manuscript reporting
%         fprintf('%s - Back Pain vs. Auditory (%s): r(%d) = %.3f, p = %.3f, n = %d\n', ...
%             group, condition, df_bp, r_bp, p_bp, n_bp);
%     end
% 
%     % Loop through each ROI
%     for r = 1:length(rois)
%         roi = rois{r};
% 
%         % Loop through Sound Low & Sound High
%         for c = 1:length(conditions)
%             condition = conditions{c};
% 
%             % Select the correct delta auditory VAS
%             if strcmp(condition, 's_l')
%                 delta_auditory = delta_auditory_sl;
%             else
%                 delta_auditory = delta_auditory_sh;
%             end
% 
%             % Compute change in ROI activation
%             delta_roi = lo.roi.(group).S2.(roi).(condition) - lo.roi.(group).S1.(roi).(condition);
% 
%             % Remove NaN values to ensure valid correlation
%             valid_idx = ~isnan(delta_auditory) & ~isnan(delta_roi);
%             clean_auditory = delta_auditory(valid_idx);
%             clean_roi = delta_roi(valid_idx);
%             n = sum(valid_idx); % Sample size
%             df = n - 2; % Degrees of freedom
% 
%             % Compute correlation only if at least 2 valid data points
%             if n >= 2
%                 [r_value, p_value] = corr(clean_auditory, clean_roi, 'Type', 'Pearson');
%             else
%                 r_value = NaN;
%                 p_value = NaN;
%             end
% 
%             % Store results
%             correlation_results.(group).(roi).(condition).r = r_value;
%             correlation_results.(group).(roi).(condition).p = p_value;
%             correlation_results.(group).(roi).(condition).df = df;
%             correlation_results.(group).(roi).(condition).n = n;
% 
%             % Print results for manuscript reporting
%             fprintf('%s - %s (%s): r(%d) = %.3f, p = %.3f, n = %d\n', ...
%                 group, roi, condition, df, r_value, p_value, n);
%         end
%     end
% end



%% Reviewer II Comment: Sponpain Ratings & VAS/ Brain Responses

% Examine how variability in pain ratings (VAS) relates to task ratings and brain activity

% Problem: Some subjects have excessive NaNs or highly fluctuating spontaneous pain ratings, 
% leading to inflated variance (600-1000) when using var() or nanvar().
% Solution: Applied Median Absolute Deviation (MAD) filtering

% Get number of subjects
num_subjects = size(d.CLBP_metadata.acute_pain_ratings, 1);

% Initialize storage for mean & variance of auditory ratings
auditory_stats = nan(num_subjects, 2); % Columns: [Mean_Auditory, Variance_Auditory]
sponpain_stats = nan(num_subjects, 2); % Columns: [Mean_SponPain, Variance_SponPain]

% Loop through subjects
for i = 1:num_subjects
    % Extract all acute pain ratings for this subject
    aud_pain_all = d.CLBP_metadata.acute_pain_ratings(i, :);
    spon_pain_all = d.CLBP_metadata.spon_pain_ratings(i, :);

    % Identify auditory trials (exclude thumb stimulation)
    stim_mask = d.CLBP_metadata.acute_stim_is_thumb(i, :) == 0;
    aud_pain_ratings = aud_pain_all(stim_mask); % Keep only auditory trials
    
    % Compute mean & variance of auditory ratings
    mean_aud = mean(aud_pain_ratings, 'omitnan'); % Ignore NaNs
    var_aud = var(aud_pain_ratings, 'omitnan'); % Ignore NaNs

    % Apply MAD filtering to spontaneous pain ratings
    median_sponpain = nanmedian(spon_pain_all, 2); % Compute median row-wise
    mad_sponpain = mad(spon_pain_all, 1, 2); % Compute MAD row-wise
    threshold = 3 * mad_sponpain; % Define threshold for outlier removal

    % Identify outliers and replace with NaN
    outlier_mask = abs(spon_pain_all - median_sponpain) > threshold;
    spon_pain_filtered = spon_pain_all;
    spon_pain_filtered(outlier_mask) = NaN;

    % Compute variance of filtered spontaneous pain ratings
    var_sponpain = nanvar(spon_pain_filtered, 1, 2); % Normalize by N, ignore NaNs
    mean_sponpain = nanmean(spon_pain_filtered, 2); % Compute mean post filter

    % Store results
    auditory_stats(i, :) = [mean_aud, var_aud];
    sponpain_stats(i, :) = [mean_sponpain, var_sponpain];
end

% Display summary
fprintf('\nAuditory Ratings Summary Across Subjects:\n');
fprintf('Mean Auditory Pain: %.3f ± %.3f\n', nanmean(auditory_stats(:, 1)), nanstd(auditory_stats(:, 1)));
fprintf('Variance of Auditory Pain: %.3f ± %.3f\n', nanmean(auditory_stats(:, 2)), nanstd(auditory_stats(:, 2)));

% Identify valid subjects (no NaNs in any column)
valid_idx = all(~isnan([sponpain_stats, auditory_stats]), 2);

% Filter out NaN subjects
filtered_sponpain = sponpain_stats(valid_idx, :);
filtered_auditory = auditory_stats(valid_idx, :);

% set storage for correlations
correlation_results_aud.auditory = nan(2, 2); % Rows: [Mean VAS, Variance VAS] | Columns: [r, p]

% Compute across-subject correlations (only valid subjects)
[r_mean, p_mean] = corr(filtered_sponpain(:, 1), filtered_auditory(:, 1), 'Type', 'Pearson'); % Mean pain vs. Mean auditory
[r_var, p_var] = corr(filtered_sponpain(:, 2), filtered_auditory(:, 2), 'Type', 'Pearson'); % Variance pain vs. Variance auditory

% Store results
correlation_results_aud.auditory = [r_mean, p_mean; r_var, p_var];

% Print results
fprintf('\nAcross-Subjects Correlation Results (VAS ↔ Auditory Ratings):\n');
fprintf('Mean Pain vs. Mean Auditory: r=%.3f, p=%.3f\n', r_mean, p_mean);
fprintf('Variance Pain vs. Variance Auditory: r=%.3f, p=%.3f\n', r_var, p_var);


