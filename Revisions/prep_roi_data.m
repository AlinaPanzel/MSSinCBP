function [pressure_table, sound_table] = prep_roi_data(lo, d, area_name)
% PREP_ROI_DATA Prepares ROI data for statistical analysis for both pressure and sound
%
% Inputs:
%   lo - Data structure containing ROI data
%   d - Behavioral data structure (to get subject IDs)
%   area_name - String: brain area name (e.g., 'insula', 'ACC')
%
% Outputs:
%   pressure_table - Table containing formatted pressure ROI data
%   sound_table - Table containing formatted sound ROI data
%
% Example usage:
%   [pressure_data, sound_data] = prep_roi_data(lo, d, 'insula');

    % Define modalities and their field names
    modalities = {'pressure', 'sound'};
    field_prefixes = {'t', 's'};
    
    % Initialize output tables
    pressure_table = [];
    sound_table = [];
    
    % Define groups and sessions
    groups = {'G1', 'G2', 'G3'};
    sessions = {'S1', 'S2'};
    time_values = [0, 1]; % 0=pre, 1=post
    
    % Process each modality
    for m = 1:length(modalities)
        modality = modalities{m};
        prefix = field_prefixes{m};
        
        % Initialize data arrays for this modality
        subject_ids = [];
        group_ids = [];
        time_ids = [];
        intensity_ids = [];
        measurements = [];
        
        % Loop through all groups and sessions
        for g = 1:length(groups)
            group = groups{g};
            
            for s = 1:length(sessions)
                session = sessions{s};
                time_value = time_values(s);
                
                % Get subject IDs from behavioral data - using direct access as in original code
                subject_list = d.(group).(session).id;
                
                % Get ROI data
                if isfield(lo, 'roi') && isfield(lo.roi, group) && isfield(lo.roi.(group), session) && ...
                   isfield(lo.roi.(group).(session), area_name)
                    
                    % Low intensity data
                    low_field = [prefix '_l'];
                    if isfield(lo.roi.(group).(session).(area_name), low_field)
                        low_data = lo.roi.(group).(session).(area_name).(low_field);
                        
                        % Process valid data
                        valid_low = ~isnan(low_data);
                        if any(valid_low)
                            for i = 1:length(valid_low)
                                if valid_low(i)
                                    subject_ids = [subject_ids; subject_list(i)];
                                    group_ids = [group_ids; g];
                                    time_ids = [time_ids; time_value];
                                    intensity_ids = [intensity_ids; 1]; % 1 for low
                                    measurements = [measurements; low_data(i)];
                                end
                            end
                        end
                    end
                    
                    % High intensity data
                    high_field = [prefix '_h'];
                    if isfield(lo.roi.(group).(session).(area_name), high_field)
                        high_data = lo.roi.(group).(session).(area_name).(high_field);
                        
                        % Process valid data
                        valid_high = ~isnan(high_data);
                        if any(valid_high)
                            for i = 1:length(valid_high)
                                if valid_high(i)
                                    subject_ids = [subject_ids; subject_list(i)];
                                    group_ids = [group_ids; g];
                                    time_ids = [time_ids; time_value];
                                    intensity_ids = [intensity_ids; 2]; % 2 for high
                                    measurements = [measurements; high_data(i)];
                                end
                            end
                        end
                    end
                else
                    warning('ROI data not found for group %s, session %s, area %s', group, session, area_name);
                end
            end
        end
        
        % Check if we have data
        if isempty(measurements)
            % Create an empty table with the correct structure
            data_table = table('Size', [0, 5], ...
                              'VariableTypes', {'categorical', 'categorical', 'categorical', 'categorical', 'double'}, ...
                              'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'Measurement'});
            warning('No valid ROI data extracted for area %s with modality %s', area_name, modality);
        else
            % Create the data table
            data_table = table(subject_ids, group_ids, time_ids, intensity_ids, measurements, ...
                'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'Measurement'});
            
            % Convert grouping variables to categorical
            data_table.Subject = categorical(data_table.Subject);
            data_table.Group = categorical(data_table.Group);
            data_table.Time = categorical(data_table.Time);
            data_table.Intensity = categorical(data_table.Intensity);
        end
        
        % Assign to the appropriate output table
        if strcmp(modality, 'pressure')
            pressure_table = data_table;
        else % sound
            sound_table = data_table;
        end
    end
end
