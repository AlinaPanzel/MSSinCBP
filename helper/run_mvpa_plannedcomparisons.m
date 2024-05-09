function Table = run_mvpa_plannedcomparisons(o, Table, data, type)

if strcmpi(type, 'NegAffect')
    numTypes = 5;
    %prexps = data;
    typ = fieldnames(data.clbp_s_l);

elseif strcmpi(type, 'FM')
    numTypes = 2;
    %data = pat_tabl;
    typ = fieldnames(data.clbp_s_l);
end

fields = fieldnames(o);
Condition = ["Pressure_low"; "Pressure_high"; "Sound_low"; "Sound_high"];
numConditions = 4;


for n = 1:numTypes
    for i = 1:numConditions
        g1 = rmoutliers(data.(fields{i}).(typ{n}), 'mean');
        p = i + 6;
        g2 = rmoutliers(data.(fields{p}).(typ{n}), 'mean');
        [h, p, ci, stats] = ttest2(g1, g2);
        ef = mes(g1, g2, 'hedgesg');

        Hypothesis(i,:) = h;
        p_value(i,:) = p;
        confidence_interval(i, :) = ci;
        effectsize(i,:) = ef.hedgesg;
        degreesoffreedom(i,:) = stats.df;
        tstats(i,:) = stats.tstat;
        mean_cbp(i,:) = mean(g1, 'omitnan');
        mean_hc(i,:) = mean(g2, 'omitnan');
        sd_cbp(i,:) = std(g1);
        sd_hc(i,:) = std(g2);
    end

    Table.(typ{n}) = table(Condition, Hypothesis, p_value, confidence_interval, effectsize, degreesoffreedom, tstats, mean_cbp, sd_cbp, mean_hc, sd_hc);
end



end