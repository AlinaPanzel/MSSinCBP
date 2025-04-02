function [sound_table, pressure_table] = prep_mvpa_data(mvpa_struct, d, pattern_name)
% PREP_MVPA_DATA Prepares MVPA data for statistical analysis for both sound and pressure
%
% Inputs:
%   mvpa_struct - Data structure containing MVPA data (prexps for NA or pat_tabl for FM)
%   d - Behavioral data structure (to get subject IDs)
%   mvpa_type - String: 'NA' or 'FM'
%   pattern_name - String: name of the pattern ('general', 'sound', 'FM_PAIN', 'FM_MSS')
%
% Outputs:
%   sound_table - Table containing formatted MVPA data for sound conditions
%   pressure_table - Table containing formatted MVPA data for pressure conditions
%
% Example usage:
%   [sound_data, pressure_data] = prep_mvpa_data(prexps, d, 'NA', 'general');
%   [sound_data, pressure_data] = prep_mvpa_data(pat_tabl, d, 'FM', 'FM_PAIN');

    % Define modalities and their condition prefixes
    modalities = {'sound', 'pressure'};
    condition_prefixes = {'s', 't'};
    
    % Initialize output tables
    sound_table = [];
    pressure_table = [];
    
    % Define groups and sessions
    groups = {'G1', 'G2', 'G3'};
    sessions = {'S1', 'S2'};
    time_values = [0, 1]; % 0=pre, 1=post
    intensity_values = [1, 2]; % 1=low, 2=high
    
    % Process each modality
    for m = 1:length(modalities)
        modality = modalities{m};
        prefix = condition_prefixes{m};
        
        % Define intensity conditions for this modality
        intensity_conditions = {[prefix '_l'], [prefix '_h']}; % low, high
        
        % Initialize data arrays for this modality
        subject_ids = [];
        group_ids = [];
        time_ids = [];
        intensity_ids = [];
        pattern_expressions = [];
        
        % Loop through all groups and sessions
        for g = 1:length(groups)
            group = groups{g};
            
            for s = 1:length(sessions)
                session = sessions{s};
                time_value = time_values(s);
                
                % Get subject IDs from behavioral data
                subject_list = d.(group).(session).id;
                
                % Process each intensity condition
                for i = 1:length(intensity_conditions)
                    condition = intensity_conditions{i};
                    intensity_value = intensity_values(i);
                    
                    % Get MVPA data based on type
                    mvpa_data = mvpa_struct.(group).(session).(condition).(pattern_name);
                    
                    % Check if data exists and has correct dimensions
                    if isempty(mvpa_data) || length(mvpa_data) ~= length(subject_list)
                        warning('Missing or mismatched data for %s, %s, %s. Skipping.', group, session, condition);
                        continue;
                    end
                    
                    % Add data to arrays
                    for j = 1:length(subject_list)
                        % Skip NaN values
                        if isnan(mvpa_data(j))
                            continue;
                        end
                        
                        subject_ids = [subject_ids; subject_list(j)];
                        group_ids = [group_ids; g];
                        time_ids = [time_ids; time_value];
                        intensity_ids = [intensity_ids; intensity_value];
                        pattern_expressions = [pattern_expressions; mvpa_data(j)];
                    end
                end
            end
        end
        
        % Create table for this modality
        if isempty(pattern_expressions)
            % Create empty table with correct structure if no data
            data_table = table('Size', [0, 5], ...
                              'VariableTypes', {'double', 'double', 'double', 'double', 'double'}, ...
                              'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'PatternExpression'});
            warning('No valid MVPA data extracted for pattern %s with modality %s', pattern_name, modality);
        else
            data_table = table(subject_ids, group_ids, time_ids, intensity_ids, pattern_expressions, ...
                'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'PatternExpression'});
        end
        
        % Assign to the appropriate output table
        if strcmp(modality, 'sound')
            sound_table = data_table;
        else % pressure
            pressure_table = data_table;
        end
        
        % Print summary for this modality
        fprintf('\n%s MVPA data for pattern: %s\n', upper(modality), pattern_name);
        fprintf('Total observations: %d\n', height(data_table));
        
        if ~isempty(data_table)
            fprintf('Unique subjects: %d\n', length(unique(data_table.Subject)));
            
            % Check for missing combinations
            group_counts = histcounts(data_table.Group, 1:4);
            fprintf('Observations per group: G1=%d, G2=%d, G3=%d\n', group_counts(1), group_counts(2), group_counts(3));
            
            time_counts = histcounts(data_table.Time, 0:2);
            fprintf('Observations per time: Pre=%d, Post=%d\n', time_counts(1), time_counts(2));
            
            intensity_counts = histcounts(data_table.Intensity, 1:3);
            fprintf('Observations per intensity: Low=%d, High=%d\n', intensity_counts(1), intensity_counts(2));
        end
    end
end
