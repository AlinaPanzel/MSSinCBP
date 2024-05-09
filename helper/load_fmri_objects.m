function o = load_fmri_objects(d, o)

o.clbp_t_l = fmri_data(d.clbp_t_l); % CLBP, thumb, low
o.clbp_t_h = fmri_data(d.clbp_t_h); % CLBP, thumb, high

o.clbp_s_l = fmri_data(d.clbp_s_l); % CLBP, sound, low
o.clbp_s_h = fmri_data(d.clbp_s_h); % CLBP, sound, high

o.clbp_t_hl = fmri_data(d.clbp_t_hl); % CLBP, thumb, low vs high
o.clbp_s_hl = fmri_data(d.clbp_s_hl); % CLBP, sound, low vs hig

o.hc_t_l = fmri_data(d.hc_t_l); % HC, thumb, low
o.hc_t_h = fmri_data(d.hc_t_h); % HC, thumb, high

o.hc_s_l = fmri_data(d.hc_s_l); % HC, sound, low
o.hc_s_h = fmri_data(d.hc_s_h); % HC, sound, high

o.hc_t_hl = fmri_data(d.hc_t_hl); % HC, thumb, low vs high
o.hc_s_hl = fmri_data(d.hc_s_hl); % HC, sound, low vs high

% Combined for voxelwise analysis

o.all_t_l = fmri_data(d.all_tl); % CLBP, thumb, low
o.all_t_h = fmri_data(d.all_th); % CLBP, thumb, high

o.all_s_l = fmri_data(d.all_sl); % CLBP, sound, low
o.all_s_h = fmri_data(d.all_sh); % CLBP, sound, high

% Combined for conjunction analysis within group

o.cbp_sh_th = fmri_data(d.cbp_sh_th); % CLBP, sound, low
o.cbp_sl_tl = fmri_data(d.cbp_sl_tl); % CLBP, sound, high

o.hc_sh_th = fmri_data(d.hc_sh_th); % CLBP, sound, low
o.hc_sl_tl = fmri_data(d.hc_sl_tl); % CLBP, sound, high

end