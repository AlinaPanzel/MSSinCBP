function Table = get_demographics(d, Table)
 
d.metadatat1 = d.metadata((d.metadata.time==1),:);

condition = {'CLBP_metadata', 'HC_metadata', 'metadatat1'};
Condition = ["CLBP_metadata";"HC_metadata";"metadatat1"];


for i = 1:numel(condition)

    age_mean(i,:)         = mean(d.(condition{i}).age, 'omitnan');
    age_sd(i,:)           = std(d.(condition{i}).age, 'omitnan');
   
    sses_mean(i,:)        = mean(d.(condition{i}).sses, 'omitnan');
    sses_sd(i,:)          = std(d.(condition{i}).sses, 'omitnan');

    bplength_mean(i,:)    = mean(d.(condition{i}).backpain_length, 'omitnan');
    bplength_sd(i,:)      = std(d.(condition{i}).backpain_length, 'omitnan');
    
    pain_avg_mean(i,:)    = mean(d.(condition{i}).pain_avg, 'omitnan');
    pain_avg_sd(i,:)      = std(d.(condition{i}).pain_avg, 'omitnan');
    
    bpi_int_mean(i,:)     = mean(d.(condition{i}).bpi_intensity, 'omitnan');
    bpi_int_sd(i,:)       = std(d.(condition{i}).bpi_intensity, 'omitnan');
   
    bpi_inf_mean(i,:)     = mean(d.(condition{i}).bpi_interference, 'omitnan');
    bpi_inf_sd(i,:)       = std(d.(condition{i}).bpi_interference, 'omitnan');
   
    odi_mean(i,:)         = mean(d.(condition{i}).odi, 'omitnan');
    odi_sd(i,:)           = std(d.(condition{i}).odi, 'omitnan');


    
    g1                    = d.(condition{i}).gender(d.(condition{i}).gender == 2);
    sex_f(i,:)            = numel(g1);
    sex_f_per(i,:)        = (numel(g1)/numel(d.(condition{i}).gender))*100;
    
    g2                    = d.(condition{i}).gender(d.(condition{i}).gender == 1);
    sex_m(i,:)            = numel(g2);
    sex_m_per(i,:)        = (numel(g2)/numel(d.(condition{i}).gender))*100;
    
    education_hs(i,:)     = numel(d.(condition{i}).education(d.(condition{i}).education == 1));
    education_hs_per(i,:) = (numel(d.(condition{i}).education(d.(condition{i}).education == 1)))/numel(d.(condition{i}).education)*100;
    education_sc(i,:)     = numel(d.(condition{i}).education(d.(condition{i}).education == 2));
    education_sc_per(i,:) = (numel(d.(condition{i}).education(d.(condition{i}).education == 2)))/numel(d.(condition{i}).education)*100;
    education_cg(i,:)     = numel(d.(condition{i}).education(d.(condition{i}).education == 3));
    education_cg_per(i,:) = (numel(d.(condition{i}).education(d.(condition{i}).education == 3)))/numel(d.(condition{i}).education)*100;
    
    married(i,:)          = numel(d.(condition{i}).married_or_living_as_marri(d.(condition{i}).married_or_living_as_marri == 1));
    married_per(i,:)      = numel(d.(condition{i}).married_or_living_as_marri(d.(condition{i}).married_or_living_as_marri == 1))/ numel(d.(condition{i}).married_or_living_as_marri)*100;
    
    race_ai(i,:)          = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 1));
    race_ai_per(i,:)      = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 1))/ numel(d.(condition{i}).ethnicity)*100;
    race_pi(i,:)          = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 2));
    race_pi_per(i,:)      = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 2))/ numel(d.(condition{i}).ethnicity)*100;
    race_b(i,:)           = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 3));
    race_b_per(i,:)       = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 3))/ numel(d.(condition{i}).ethnicity)*100;
    race_w(i,:)           = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 4));
    race_w_per(i,:)       = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 4))/ numel(d.(condition{i}).ethnicity)*100;
    race_o(i,:)           = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 5));
    race_o_per(i,:)       = numel(d.(condition{i}).ethnicity(d.(condition{i}).ethnicity == 5))/ numel(d.(condition{i}).ethnicity)*100;
   
    hisp(i,:)             = numel(d.(condition{i}).hispanic(d.(condition{i}).hispanic == 1));
    hisp_per(i,:)         = numel(d.(condition{i}).hispanic(d.(condition{i}).hispanic == 1))/numel(d.(condition{i}).hispanic)*100;
    
    emp_ft(i,:)           = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 1));
    emp_ft_per(i,:)       = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 1))/ numel(d.(condition{i}).employment_status)*100;
    emp_pt(i,:)           = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 2));
    emp_pt_per(i,:)       = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 2))/ numel(d.(condition{i}).employment_status)*100;
    emp_un(i,:)           = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 3));
    emp_un_per(i,:)       = numel(d.(condition{i}).employment_status(d.(condition{i}).employment_status == 3))/ numel(d.(condition{i}).employment_status)*100;

   
    exercise_0(i,:)           = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 1));
    exercise_0_per(i,:)       = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 1))/ numel(d.(condition{i}).sses)*100;
    exercise_1(i,:)           = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 2));
    exercise_1_per(i,:)       = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 2))/ numel(d.(condition{i}).sses)*100;
    exercise_3(i,:)           = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 3));
    exercise_3_per(i,:)       = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 3))/ numel(d.(condition{i}).sses)*100;
    exercise_7(i,:)           = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 4));
    exercise_7_per(i,:)       = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 4))/ numel(d.(condition{i}).sses)*100;
    exercise_14(i,:)          = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 5));
    exercise_14_per(i,:)      = numel(d.(condition{i}).exercise(d.(condition{i}).exercise == 5))/ numel(d.(condition{i}).sses)*100;

      
    
    

end


Table.demographics =  table(Condition, age_mean, age_sd, sex_f, sex_f_per, sex_m, sex_m_per, education_hs, education_hs_per, education_sc, education_sc_per, education_cg, education_cg_per, married, married_per, race_ai, race_ai_per, race_pi, race_pi_per, race_b, race_b_per, race_w, race_w_per, race_o, race_o_per, hisp, hisp_per, emp_ft, emp_ft_per, emp_pt, emp_pt_per, emp_un, emp_un_per,sses_mean, sses_sd, exercise_0, exercise_0_per, exercise_1, exercise_1_per, exercise_3, exercise_3_per, exercise_7, exercise_7_per, exercise_14, exercise_14_per, bpi_int_mean, bpi_int_sd, bpi_inf_mean, bpi_inf_sd, pain_avg_mean, pain_avg_sd, odi_mean, odi_sd, bplength_mean, bplength_sd);


end