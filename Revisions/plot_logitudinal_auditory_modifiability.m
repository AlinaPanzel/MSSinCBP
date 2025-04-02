function t_results = plot_logitudinal_auditory_modifiability(input, d, lo, prexps, pat_tabl)

% Define colors
pre_col = [0.8902, 0.3490, 0.1569]; % Original pre color
post_col = [0.4, 0, 0]; % New post color (darker orange)

if strcmp(input, 'ROI')
    % Define areas and their corresponding display names
    conditions = {'A1', 'm_ventral_insula', 'm_dorsal_insula', 'm_posterior_insula', 'mPFC', 'precuneus'};
    titles = {'Auditory Cortex', 'Ventral Insula Cortex', 'Dorsal Insula Cortex', ...
        'Posterior Insula Cortex', 'Medial Prefrontal Cortex', 'Precuneus Cortex'};

elseif strcmp(input, 'Behaviour')
    conditions = {'Unpleasantness Ratings'};
    titles = {'Unpleasantness Ratings'};

elseif strcmp(input, 'MVPA_NA')
    conditions = {'sound', 'general'};
    titles = {'Stimulus-type-specific: Aversive Auditory', 'Multimodal (common) Negative Affect'};

elseif strcmp(input, 'MVPA_FM')
    conditions = {'FM_PAIN', 'FM_MSS'};
    titles = {'Fibromyalgia Pain', 'Fibromyalgia MSS'};

end

% Initialize storage for results
t_results = struct();

% Loop through each area and create a separate figure
for i = 1:length(conditions)
    current_area = conditions{i}; % Select brain region
    current_title = titles{i}; % Select corresponding display name

    disp(current_area)
    
    % Open a new figure
    hf = figure;
    hf = colordef(hf, 'white'); % Set color scheme
    hf.Color = 'w'; % Set background color of figure window
    hold on;

    if strcmp(input, 'ROI')
        % Extract data dynamically for each brain region
        cbp_g1_pre  = lo.roi.G1.S1.(current_area).s_l;
        cbp_g1_post = lo.roi.G1.S2.(current_area).s_l;

        cbp_g2_pre  = lo.roi.G2.S1.(current_area).s_l;
        cbp_g2_post = lo.roi.G2.S2.(current_area).s_l;

        cbp_g3_pre  = lo.roi.G3.S1.(current_area).s_l;
        cbp_g3_post = lo.roi.G3.S2.(current_area).s_l;

        cbp_g1_pre_sH  = lo.roi.G1.S1.(current_area).s_h;
        cbp_g1_post_sH = lo.roi.G1.S2.(current_area).s_h;

        cbp_g2_pre_sH  = lo.roi.G2.S1.(current_area).s_h;
        cbp_g2_post_sH = lo.roi.G2.S2.(current_area).s_h;

        cbp_g3_pre_sH  = lo.roi.G3.S1.(current_area).s_h;
        cbp_g3_post_sH = lo.roi.G3.S2.(current_area).s_h;

    elseif strcmp(input, 'Behaviour')

        % Sound low
        cbp_g1_pre  = d.G1.S1.acute_mean_sound_lo;
        cbp_g1_post = d.G1.S2.acute_mean_sound_lo;

        cbp_g2_pre  = d.G2.S1.acute_mean_sound_lo;
        cbp_g2_post = d.G2.S2.acute_mean_sound_lo;

        cbp_g3_pre  = d.G3.S1.acute_mean_sound_lo;
        cbp_g3_post = d.G3.S2.acute_mean_sound_lo;

        % Sound high
        cbp_g1_pre_sH  = d.G1.S1.acute_mean_sound_hi;
        cbp_g1_post_sH = d.G1.S2.acute_mean_sound_hi;

        cbp_g2_pre_sH  = d.G2.S1.acute_mean_sound_hi;
        cbp_g2_post_sH = d.G2.S2.acute_mean_sound_hi;

        cbp_g3_pre_sH  = d.G3.S1.acute_mean_sound_hi;
        cbp_g3_post_sH = d.G3.S2.acute_mean_sound_hi;

    elseif strcmp(input, 'MVPA_NA')

        % Sound low
        cbp_g1_pre   = prexps.G1.S1.s_l.(current_area);
        cbp_g1_post  = prexps.G1.S2.s_l.(current_area);

        cbp_g2_pre   = prexps.G2.S1.s_l.(current_area);
        cbp_g2_post  = prexps.G2.S2.s_l.(current_area);

        cbp_g3_pre   = prexps.G3.S1.s_l.(current_area);
        cbp_g3_post  = prexps.G3.S2.s_l.(current_area);

        % Sound high
        cbp_g1_pre_sH   = prexps.G1.S1.s_h.(current_area);
        cbp_g1_post_sH  = prexps.G1.S2.s_h.(current_area);

        cbp_g2_pre_sH   = prexps.G2.S1.s_h.(current_area);
        cbp_g2_post_sH  = prexps.G2.S2.s_h.(current_area);

        cbp_g3_pre_sH   = prexps.G3.S1.s_h.(current_area);
        cbp_g3_post_sH  = prexps.G3.S2.s_h.(current_area);

    elseif strcmp(input, 'MVPA_FM')

        % Sound low
        cbp_g1_pre   = pat_tabl.G1.S1.s_l.(current_area);
        cbp_g1_post  = pat_tabl.G1.S2.s_l.(current_area);

        cbp_g2_pre   = pat_tabl.G2.S1.s_l.(current_area);
        cbp_g2_post  = pat_tabl.G2.S2.s_l.(current_area);

        cbp_g3_pre   = pat_tabl.G3.S1.s_l.(current_area);
        cbp_g3_post  = pat_tabl.G3.S2.s_l.(current_area);

        % Sound high
        cbp_g1_pre_sH   = pat_tabl.G1.S1.s_h.(current_area);
        cbp_g1_post_sH  = pat_tabl.G1.S2.s_h.(current_area);

        cbp_g2_pre_sH   = pat_tabl.G2.S1.s_h.(current_area);
        cbp_g2_post_sH  = pat_tabl.G2.S2.s_h.(current_area);

        cbp_g3_pre_sH   = pat_tabl.G3.S1.s_h.(current_area);
        cbp_g3_post_sH  = pat_tabl.G3.S2.s_h.(current_area);

    else
        disp('not working, input not found')
    end

    % Run paired t-tests G1
    [h, p, ~, stats] = ttest(cbp_g1_pre, cbp_g1_post); % Sound low
    g_value = hedges_g(cbp_g1_pre, cbp_g1_post);
    fprintf('\n%s G1 (Sound Low) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);
    [h, p, ~, stats] = ttest(cbp_g1_pre_sH, cbp_g1_post_sH); % Sound high
    g_value = hedges_g(cbp_g1_pre_sH, cbp_g1_post_sH);
    fprintf('%s G1 (Sound High) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);

    % Run paired t-tests G2
    [h, p, ~, stats] = ttest(cbp_g2_pre, cbp_g2_post); % Sound low
    g_value = hedges_g(cbp_g2_pre, cbp_g2_post);
    fprintf('\n%s G2 (Sound Low) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);
    [h, p, ~, stats] = ttest(cbp_g2_pre_sH, cbp_g2_post_sH); % Sound high
    g_value = hedges_g(cbp_g2_pre_sH, cbp_g2_post_sH);
    fprintf('%s G2 (Sound High) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);

    % Run paired t-tests G3
    [h, p, ~, stats] = ttest(cbp_g3_pre, cbp_g3_post); % Sound low
    g_value = hedges_g(cbp_g3_pre, cbp_g3_post);
    fprintf('\n%s G3 (Sound Low) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);
    [h, p, ~, stats] = ttest(cbp_g3_pre_sH, cbp_g3_post_sH); % Sound high
    g_value = hedges_g(cbp_g3_pre_sH, cbp_g3_post_sH);
    fprintf('%s G3 (Sound High) - t(%d) = %.3f, p = %.3f, Hedges'' g = %.3f\n', ...
        current_area, stats.df, stats.tstat, p, g_value);


    % Define x positions for spacing
    x_positions = [1 2 3 5 6 7]; % Sound Low on 1,2,3 | Sound High on 5,6,7

    % Plot Sound Low
    al_goodplot(cbp_g1_pre, x_positions(1), 0.5, pre_col, 'left', [], std(cbp_g1_pre) / 1000);
    al_goodplot(cbp_g1_post, x_positions(1), 0.5, post_col, 'right', [], std(cbp_g1_post) / 1000);

    al_goodplot(cbp_g2_pre, x_positions(2), 0.5, pre_col, 'left', [], std(cbp_g2_pre) / 1000);
    al_goodplot(cbp_g2_post, x_positions(2), 0.5, post_col, 'right', [], std(cbp_g2_post) / 1000);

    al_goodplot(cbp_g3_pre, x_positions(3), 0.5, pre_col, 'left', [], std(cbp_g3_pre) / 1000);
    al_goodplot(cbp_g3_post, x_positions(3), 0.5, post_col, 'right', [], std(cbp_g3_post) / 1000);

    % Plot Sound High
    al_goodplot(cbp_g1_pre_sH, x_positions(4), 0.5, pre_col, 'left', [], std(cbp_g1_pre_sH) / 1000);
    al_goodplot(cbp_g1_post_sH, x_positions(4), 0.5, post_col, 'right', [], std(cbp_g1_post_sH) / 1000);

    al_goodplot(cbp_g2_pre_sH, x_positions(5), 0.5, pre_col, 'left', [], std(cbp_g2_pre_sH) / 1000);
    al_goodplot(cbp_g2_post_sH, x_positions(5), 0.5, post_col, 'right', [], std(cbp_g2_post_sH) / 1000);

    al_goodplot(cbp_g3_pre_sH, x_positions(6), 0.5, pre_col, 'left', [], std(cbp_g3_pre_sH) / 1000);
    al_goodplot(cbp_g3_post_sH, x_positions(6), 0.5, post_col, 'right', [], std(cbp_g3_post_sH) / 1000);

    if strcmp(input, 'Behaviour')
        ylim([0 105]); % Set y-axis limits for behavioural data
    elseif strcmp(input, 'MVPA_NA')
        ylim([-0.5 1]); % Set y-axis limits for behavioural data
    end



    % Add grey dashed line between Sound Low and Sound High at position 4
    line([4 4], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 2);

    % Add significance markers (within plot limits)
    add_sig_asterisk(x_positions(1), ttest(cbp_g1_pre, cbp_g1_post));
    add_sig_asterisk(x_positions(2), ttest(cbp_g2_pre, cbp_g2_post));
    add_sig_asterisk(x_positions(3), ttest(cbp_g3_pre, cbp_g3_post));

    add_sig_asterisk(x_positions(4), ttest(cbp_g1_pre_sH, cbp_g1_post_sH));
    add_sig_asterisk(x_positions(5), ttest(cbp_g2_pre_sH, cbp_g2_post_sH));
    add_sig_asterisk(x_positions(6), ttest(cbp_g3_pre_sH, cbp_g3_post_sH));

    % Set x-axis labels
    xticks(x_positions);
    xticklabels({'G1', 'G2', 'G3', 'G1', 'G2', 'G3'});
    set(gca, 'FontSize', 20);


    % Add "Sound Low" and "Sound High" in the top center (inside the plot)
    text(2, max(ylim) * 0.92, 'Sound Low', 'FontSize', 25,  'HorizontalAlignment', 'center');
    text(6, max(ylim) * 0.92, 'Sound High', 'FontSize', 25,  'HorizontalAlignment', 'center');

    % Add legend
    legend({'Pre', 'Post'}, 'FontSize', 20, 'Location', 'northeast');

    % Increase space for overall title
    sgtitle(current_title, 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'none');

    hold off;
end



end