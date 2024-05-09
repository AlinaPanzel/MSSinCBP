function d = get_metadata(d)
    % Create metadata table for CLBP S1 & append widespreadness of pain 
    load("acute_v2_fmri_data_objs.mat");
    dat{1}.metadata_table = get_subject_metadata_from_fnames(dat{1}.fullpath);

    d.metadata = dat{1,1}.metadata_table;
    metadata = d.metadata((1:271),:);
    d.HC_metadata = d.metadata((272:end),:);
    index = table2array(metadata(:,[1,2]));
    load('/Users/alinapanzel/Desktop/Dartmouth_project/elig_session_data.mat', 'tabl_elig')
    SubID = tabl_elig.id;
    ind = find(index(:,2)==1);
    CLBP_metadata = metadata(ind,:);
    d.CLBP_metadata = CLBP_metadata((1:142),:);
    %ids = table2array(CLBP_metadata(:,1));
    %idn = find(SubID(:,1) == ids(:,1));
    widespreadness = tabl_elig(:,172);
    i = [1, 21, 30, 36, 51, 60, 71, 92, 121, 133]; 
    toDelete = i;
    widespreadness(toDelete,:) = [];
    n = NaN;
    ix = 106;
    x = table2array(widespreadness);
    widespreadness = [x(1:ix-1);n;x(ix:end)];
    d.CLBP_metadata.widespreadness = widespreadness;
end