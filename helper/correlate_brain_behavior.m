function Table = correlate_brain_behavior(Table, o, d, roi, correlation)

fields = fieldnames(o);

if strcmpi(correlation, 'brainbehavior')

measure = {'pain_avg' 'spon_pain_rating_mean'};
area = {'ventral_insula' 'dorsal_insula' 'posterior_insula' 'A1' 'mPFC', 'precuneus'};
%Area = ["Ventral Insula"; "Dorsal Insula"; "Posterior Insula"; "A1"; "mPFC"; "precuneus"];
%Condition = ["Sound_low"; "Sound_high"; "Pressure low";"Pressure_intensity"];
fields = {'clbp_s_l' 'clbp_s_h' 'hc_s_l' 'hc_s_h' };
Fields = ["clbp_s_l"; "clbp_s_h"; "hc_s_l"; "hc_s_h"];

for n = 1:numel(area)

    for m = 1: numel(measure)

               clear p_value;
               clear p_value_hc;
               clear rho;
               clear adj_p;
               clear pval;
               clear Rho;
               clear adj_p_hc;
               clear Rho_hc;

       for i = 1:2
                p = i+2;
    
                X = d.CLBP_metadata.(measure{m});
                Y = roi.(area{n}).(fields{i});
    
                [rho, pval] = corr(X,Y,'Rows','complete', 'type', 'Pearson');
                p_value(i,:) = pval;
                Rho(i,:) = rho;
                
                X_hc = d.HC_metadata.(measure{m});
                Y_hc = roi.(area{n}).(fields{p});
                [rho,pval] = corr(X_hc,Y_hc,'Rows','complete', 'type', 'Pearson');
                p_value_hc(i,:) = pval;
                Rho_hc(i,:) = rho;
                
        end 
               
             

               Table.corr.(measure{m}).(area{n}).clbp =  table(Fields(1:2), p_value, adj_p, Rho);
               Table.corr.(measure{m}).(area{n}).hc =  table(Fields(3:4), p_value_hc, adj_p_hc, Rho_hc);
    
     end
    
end

elseif strcmpi(correlation, 'meanpain')
    
    fields = fieldnames(o);
    clear p_value;clear pval;clear rho;clear Rho;clear Rho_hc; clear p_value_hc;
    area = {'ventral_insula' 'dorsal_insula' 'posterior_insula' 'A1' 'mPFC', 'precuneus'};
    Condition = ["Sound_low";"Sound_high"];
    stimtype = {'acute_mean_sound_lo' 'acute_mean_sound_hi'};

    for n = 1: numel(area)
        %figure("Name",(area{n}))
        for i = 1:2
            j = i + 2;
            X = d.CLBP_metadata.(stimtype{i});
            Y = roi.(area{n}).(fields{j});
            [rho,pval] = corr(X,Y,'Rows','complete', 'type','Pearson');
            p_value(i,:) = pval;
            Rho(i,:) = rho;
            
            p = j + 6;
            X_hc = d.HC_metadata.(stimtype{i});
            Y_hc = roi.(area{n}).(fields{p});
            [rho,pval] = corr(X_hc,Y_hc,'Rows','complete', 'type','Pearson');
            p_value_hc(i,:) = pval;
            Rho_hc(i,:) = rho;

        end
         
            Table.corr.stim_pain.(area{n}).clbp =  table(Condition, p_value, adj_p, Rho);
            Table.corr.stim_pain.(area{n}).hc   =  table(Condition, p_value_hc,adj_p_hc, Rho_hc);

    end
end

end