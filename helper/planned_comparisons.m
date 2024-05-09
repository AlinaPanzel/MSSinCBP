function Table = planned_comparisons(d, Table, type)

if strcmpi(type, 'pain')

    % 1) Planned comparisons between CLBP vs controls (avg_pain, spon_pain) and unpleasantness ratings
    Condition = ["Average pain";"Spontaneous Pain";"Mean Acute Thumb low";"Mean Acute Thumb high";"Mean Acute Sound low"; "Mean Acute Sound high"];
    measure = {'pain_avg' 'spon_pain_rating_mean' 'acute_mean_thumb_lo' 'acute_mean_thumb_hi' 'acute_mean_sound_lo' 'acute_mean_sound_hi' };

    for n = 1: numel(measure)
        g1 = d.HC_metadata.(measure{n});
        g2 = d.CLBP_metadata.(measure{n});

        [h,p,ci,stats] = ttest2(g1, g2);
        ef = mes(g1, g2, 'hedgesg');

        CLBP_mean(n,:) = mean(g2, 'omitnan');
        CLBP_std(n,:) = std(g2, 'omitnan');
        HC_mean(n,:) = mean(g1, 'omitnan');
        HC_std(n,:) = std(g1, 'omitnan');
        Hypothesis(n,:) = h;
        p_value(n,:) = p;
        confidence_interval(n,:) = ci;
        effectsize(n,:) = ef.hedgesg;

    end

    % Get  in table
    Table.behavior =  table(Condition, CLBP_mean, CLBP_std, HC_mean, HC_std, Hypothesis, p_value, confidence_interval, effectsize);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif strcmpi(type, 'correlation')


    % 3) Behavioral correlations

    % Correlate unpleasantness ratings from acute pain and auditory stimuli in
    % CLBP, HC


    % CLBP
    Tbl = table(d.CLBP_metadata.acute_mean_thumb_lo, d.CLBP_metadata.acute_mean_thumb_hi, d.CLBP_metadata.acute_mean_sound_lo, d.CLBP_metadata.acute_mean_sound_hi, d.CLBP_metadata.pain_avg, d.CLBP_metadata.spon_pain_rating_mean, 'VariableNames', {'TL', 'TH', 'SL', 'SH', 'Pavg', 'SponP'});
    [R,PValue] = corrplot(Tbl, Type = 'Pearson'); % Pearson correlation
    title('CLBP')
    results.clbp.R = R;
    results.clbp.Pval = PValue;
    [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(PValue); % FDR correction
    results.clbp.adj_Pval = adj_p;

    % HC
    Tbl = table(d.HC_metadata.acute_mean_thumb_lo, d.HC_metadata.acute_mean_thumb_hi, d.HC_metadata.acute_mean_sound_lo, d.HC_metadata.acute_mean_sound_hi, 'VariableNames', {'TL', 'TH', 'SL', 'SH'});
    %Tbl = table(d.HC_metadata.acute_mean_thumb_lo,  d.HC_metadata.acute_mean_sound_lo, 'VariableNames', {'Pressure low', 'Sound low'});
    [R,PValue] = corrplot(Tbl, Type = 'Pearson') % Pearson correlation
    title('HC')
    results.hc.R = R;
    results.hc.Pval = PValue;
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(PValue); % FDR correction
    results.hc.adj_Pval = adj_p;

    % Plot significant correlations
    plot_correlation(d, 'HC');
    plot_correlation(d, 'CLBP');
    plot_correlation(d, 'CLBP_clinical');


elseif strcmpi(type, 'variance')


    % Compare variance on unpleasantness sound and pressure ratings
    var_tl = [var(d.CLBP_metadata.acute_mean_thumb_lo) var(d.HC_metadata.acute_mean_thumb_lo)]';
    var_th = [var(d.CLBP_metadata.acute_mean_thumb_hi) var(d.HC_metadata.acute_mean_thumb_hi)]';
    var_sl = [var(d.CLBP_metadata.acute_mean_sound_lo) var(d.HC_metadata.acute_mean_sound_lo)]';
    var_sh = [var(d.CLBP_metadata.acute_mean_sound_hi) var(d.HC_metadata.acute_mean_sound_hi)]';

    std_tl = [std(d.CLBP_metadata.acute_mean_thumb_lo) std(d.HC_metadata.acute_mean_thumb_lo)]';
    std_th = [std(d.CLBP_metadata.acute_mean_thumb_hi) std(d.HC_metadata.acute_mean_thumb_hi)]';
    std_sl = [std(d.CLBP_metadata.acute_mean_sound_lo) std(d.HC_metadata.acute_mean_sound_lo)]';
    std_sh = [std(d.CLBP_metadata.acute_mean_sound_hi) std(d.HC_metadata.acute_mean_sound_hi)]';
    Condition = ["CLBP";"HC"];
    Table.variance = table(Condition, var_tl, var_th, var_sl, var_sh, std_tl, std_th, std_sl, std_sh);

end