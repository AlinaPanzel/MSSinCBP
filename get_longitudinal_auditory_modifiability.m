%% Longitudinal Analysis to assess modifiability of auditory sensitivity in CBP

% Assessment of treatment effect on longitudinal outcome, will sort into 3
% groups and get 1st and 2nd session, then repeat ROI and MVPA analysis and see if
% treatment/time modified increased auditory activity in CBP 


function [d, lo] = get_longitudinal_auditory_modifiability(d, datadir)


% Load file participants with second session

clbpS2_s_l_g1 = filenames(fullfile(datadir, 'sub-0*', 'ses-02', 'acute_v2', 'con_0003.nii')); % Just to get index of participants with second session does not matter which .nii
clbpS2_s_l_g2 = filenames(fullfile(datadir, 'sub-1*', 'ses-02', 'acute_v2', 'con_0003.nii'));
g = vertcat(clbpS2_s_l_g1, clbpS2_s_l_g2); % combines patients 
subs   = str2double(extractBetween(g,"sub-","/ses"));
subIDs = subs([2:18,20:27, 29:32, 34:44, 46:49, 51:75, 77:99, 101:111, 113:end],:); % Extract subjects that only have session 2, but no session 1
l = struct; % struct for longitudinal assessment
G1 = d.CLBP_metadata.id(d.CLBP_metadata.group == 1);
G2 = d.CLBP_metadata.id(d.CLBP_metadata.group == 2);
G3 = d.CLBP_metadata.id(d.CLBP_metadata.group == 3);

doc intersect
[l.ID.G1, pos1] = intersect(subIDs, G1); % gives common val and its position in 'subIDs'
[l.ID.G2, pos2] = intersect(subIDs, G2); 
[l.ID.G3, pos3] = intersect(subIDs, G3); 

Treatment = {'G1' 'G2' 'G3'};

% Extract S1&2, G1, G2, G3, ID datadirs
for j = 1:numel(Treatment)
    for i = 1:numel(l.ID.(Treatment{j}))
        n    = l.ID.(Treatment{j})(i,1);   % Get ID number                  
        str2 = sprintf( '%04d', n ); % add zeros to numbers
        str1 = "sub-"; % add 'sub-' to numbers 
        str  = append(str1,str2);
        
        % Session 1
        l.(Treatment{j}).S1.t_l(i,:) = filenames(fullfile(datadir, str, 'ses-01', 'acute_v2', 'con_0001.nii')); % Pressure low
        l.(Treatment{j}).S1.t_h(i,:) = filenames(fullfile(datadir, str, 'ses-01', 'acute_v2', 'con_0002.nii')); % Pressure high
        l.(Treatment{j}).S1.s_l(i,:) = filenames(fullfile(datadir, str, 'ses-01', 'acute_v2', 'con_0003.nii')); % Sound low
        l.(Treatment{j}).S1.s_h(i,:) = filenames(fullfile(datadir, str, 'ses-01', 'acute_v2', 'con_0004.nii')); % Sound high
        
        % Session 2
        l.(Treatment{j}).S2.t_l(i,:) = filenames(fullfile(datadir, str, 'ses-02', 'acute_v2', 'con_0001.nii'));
        l.(Treatment{j}).S2.t_h(i,:) = filenames(fullfile(datadir, str, 'ses-02', 'acute_v2', 'con_0002.nii'));
        l.(Treatment{j}).S2.s_l(i,:) = filenames(fullfile(datadir, str, 'ses-02', 'acute_v2', 'con_0003.nii'));
        l.(Treatment{j}).S2.s_h(i,:) = filenames(fullfile(datadir, str, 'ses-02', 'acute_v2', 'con_0004.nii'));
    end
end


% Loop to get longitudinal fmri objects (lo)
lo = struct;
field = fieldnames(l.G1.S2); 
sessions = {'S1','S2'};
Treatment = {'G1' 'G2' 'G3'};

for n = 1:numel(Treatment)
    for s = 1:numel(sessions)
        for i = 1:numel(field)
            lo.(Treatment{n}).(sessions{s}).(field{i}) = fmri_data(l.(Treatment{n}).(sessions{s}).(field{i})); % CLBP, thumb, low
        end
    end 
end


% Get metadata, Sorted by time & group
d.longitudinal_S2 = [];
d.longitudinal_S1 = [];

for i = 1:numel(subIDs)
    long_id_S1 = (d.metadata.id == subIDs(i) & d.metadata.time == 1);
    d.longitudinal_S1 = [d.longitudinal_S1; d.metadata(long_id_S1, :)];
    long_id_S2 = (d.metadata.id == subIDs(i) & d.metadata.time == 2);
    d.longitudinal_S2 = [d.longitudinal_S2; d.metadata(long_id_S2, :)];
end

d.G1.S1 = d.longitudinal_S1(d.longitudinal_S1.group == 1,:);
d.G2.S1 = d.longitudinal_S1(d.longitudinal_S1.group == 2,:);
d.G3.S1 = d.longitudinal_S1(d.longitudinal_S1.group == 3,:);

d.G1.S2 = d.longitudinal_S2(d.longitudinal_S2.group == 1,:);
d.G2.S2 = d.longitudinal_S2(d.longitudinal_S2.group == 2,:);
d.G3.S2 = d.longitudinal_S2(d.longitudinal_S2.group == 3,:);



end