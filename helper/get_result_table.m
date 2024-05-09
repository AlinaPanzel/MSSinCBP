function Table = get_result_table(Table, o, roi, region)

if strcmpi(region, 'Insula')
   area = {'ventral_insula' 'dorsal_insula' 'posterior_insula'};

elseif strcmpi(region, 'm_insula')
   area = {'m_ventral_insula' 'm_dorsal_insula' 'm_posterior_insula'};
    
elseif strcmpi(region, 'Aud')
   area = {'A1' 'MGN' 'IC'};

elseif strcmpi(region, 'Mech')
   area = {'S1_L' 'S1_R'};

elseif strcmpi(region, 'Selfref')
   area = {'mPFC' 'PCC' 'precuneus'};

end

disp(area)

Condition = ["Pressure_low";"Pressure_high";"Sound_low";"Sound_high"];
    
    fields = fieldnames(o); 
    
    for n = 1: numel(area)
        for i = 1:4
            g1 = rmoutliers((roi.(area{n}).(fields{i})), 'mean');
            p = i + 6;
            g2 = rmoutliers((roi.(area{n}).(fields{p})), 'mean');
      
            [h,p,ci,stats] = ttest2(g1, g2);
            ef = mes(g1, g2, 'hedgesg');
    
            results.(area{n}).(fields{i}).h = h;
            results.(area{n}).(fields{i}).p = p;
            results.(area{n}).(fields{i}).ci = ci;
            results.(area{n}).(fields{i}).ef = ef.hedgesg;
            results.(area{n}).(fields{i}).df = stats.df;
            results.(area{n}).(fields{i}).t = stats.tstat;
            %results.(area{n}).(fields{i}).sd = stats.sd;


            Hypothesis(i,:) = h;
            p_value(i,:) = p;
            confidence_interval(i,:) = ci;
            effectsize(i,:) = ef.hedgesg;
            degreesoffreedom(i,:) = stats.df;
            tstats(i,:) = stats.tstat;
            %std(i,:) = stats.sd;
            mean_cbp(i,:) = mean(g1, 'omitnan');
            mean_hc(i,:) = mean(g2, 'omitnan');
            sd_cbp(i,:) = std(g1);
            sd_hc(i,:) = std(g2);

        end
          
           [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_value, 0.05, 'pdep');
           Table.(area{n}) =  table(Condition, Hypothesis, p_value, adj_p, confidence_interval, effectsize, degreesoffreedom, tstats, mean_cbp, sd_cbp, mean_hc, sd_hc);
    
    end

end