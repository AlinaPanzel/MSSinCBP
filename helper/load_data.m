function d = load_data(datadir, d)

% Chronic lower back pain (CLBP)

% Thumb (t), low(l) and high(h)
clbp_t_l_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0001.nii'));
clbp_t_l_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0001.nii'));
d.clbp_t_l = vertcat(clbp_t_l_g1,clbp_t_l_g2);

clbp_t_h_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0002.nii'));
clbp_t_h_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0002.nii'));
d.clbp_t_h = vertcat(clbp_t_h_g1,clbp_t_h_g2);

% Sound (t), low(l) and high(h)
clbp_s_l_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0003.nii'));
clbp_s_l_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0003.nii'));
d.clbp_s_l = vertcat(clbp_s_l_g1, clbp_s_l_g2);

clbp_s_h_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0004.nii'));
clbp_s_h_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0004.nii'));
d.clbp_s_h = vertcat(clbp_s_h_g1, clbp_s_h_g2);

% Thumb high vs low
clbp_t_hl_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0006.nii'));
clbp_t_hl_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0006.nii'));
d.clbp_t_hl = vertcat(clbp_t_hl_g1, clbp_t_hl_g2);

% Sound high vs low
clbp_s_hl_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-01', 'acute_v2', 'con_0007.nii'));
clbp_s_hl_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-01', 'acute_v2', 'con_0007.nii'));
d.clbp_s_hl = vertcat(clbp_s_hl_g1, clbp_s_hl_g2);

% ----------------------------------------------------------------------------------------

% Healthy Controls (HC)

% Thumb(t), low(l) and high(h)
d.hc_t_l = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0001.nii'));
d.hc_t_h = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0002.nii'));

% Sound(s), low(l) and high(h)
d.hc_s_l = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0003.nii'));
d.hc_s_h = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0004.nii'));

% Thumb high vs low
d.hc_t_hl = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0006.nii'));

% Sound high vs low
d.hc_s_hl = filenames(fullfile(datadir, 'sub-9*', 'ses-01', 'acute_v2', 'con_0007.nii'));



% ------------------------------------------------------------------------------------------

% Combined for voxelwise
d.all_tl = vertcat(d.clbp_t_l, d.hc_t_l);
d.all_th = vertcat(d.clbp_t_h, d.hc_t_h);
d.all_sl = vertcat(d.clbp_s_l, d.hc_s_l);
d.all_sh = vertcat(d.clbp_s_h, d.hc_s_h);

% Combined for voxelwise

d.cbp_sh_th = vertcat(d.clbp_s_h, d.clbp_t_h);
d.cbp_sl_tl = vertcat(d.clbp_s_l, d.clbp_t_l);
d.hc_sh_th  = vertcat(d.hc_s_h, d.hc_t_h);
d.hc_sl_tl  = vertcat(d.hc_s_l, d.hc_t_l);


end