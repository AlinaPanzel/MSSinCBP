function [PRTvsPLA_sound, PRTvsUC_sound, PRTvsPLA_pressure, PRTvsUC_pressure] = prep_behavioural_data(d)
    % Initialize data structures for sound
    subject_ids_sound = [];
    group_ids_sound = [];
    time_ids_sound = []; % pre=0, post=1
    intensity_ids_sound = []; % low=1, high=2
    ratings_sound = [];
    ages_sound = [];
    genders_sound = [];
    
    % Initialize data structures for pressure
    subject_ids_pressure = [];
    group_ids_pressure = [];
    time_ids_pressure = []; % pre=0, post=1
    intensity_ids_pressure = []; % low=1, high=2
    ratings_pressure = [];
    ages_pressure = [];
    genders_pressure = [];

    % Define groups and sessions
    groups = {'G1', 'G2', 'G3'};
    sessions = {'S1', 'S2'};
    time_values = [0, 1]; % 0=pre, 1=post

    % Loop through all groups and sessions
    for g = 1:length(groups)
        group = groups{g};
        
        for s = 1:length(sessions)
            session = sessions{s};
            time_value = time_values(s);
            
            % Access data for this group and session
            current_data = d.(group).(session);
            
            % Loop through subjects
            for i = 1:length(current_data.id)
                subj_id = current_data.id(i);
                age = current_data.age(i);
                gender = current_data.gender(i);

                % Get all ratings
                all_ratings = current_data.acute_pain_ratings(i, :);
                
                % Check which are sound trials (not thumb)
                is_sound = current_data.acute_stim_is_thumb(i, :) == 0;
                is_thumb = current_data.acute_stim_is_thumb(i, :) == 1;

                % Check intensity levels
                stim_intensity = current_data.acute_stim_intensity(i, :);
                
                % Skip if no valid data
                if isempty(all_ratings) || all(isnan(all_ratings)) || (~any(is_sound) && ~any(is_thumb))
                    continue;
                end
                
                % Process all sound trials
                sound_ratings = all_ratings(is_sound);
                sound_intensities = stim_intensity(is_sound);

                % Process all pressure trials
                pressure_ratings = all_ratings(is_thumb);
                pressure_intensities = stim_intensity(is_thumb);
                
                % Remove NaN values while keeping track of corresponding intensities
                valid_idx = ~isnan(sound_ratings);
                valid_ratings_sound_subj = sound_ratings(valid_idx);
                valid_intensities_sound_subj = sound_intensities(valid_idx);

                valid_idx = ~isnan(pressure_ratings);
                valid_ratings_pressure_subj = pressure_ratings(valid_idx);
                valid_intensities_pressure_subj = pressure_intensities(valid_idx);
                
                if ~isempty(valid_ratings_sound_subj)
                    n_valid = length(valid_ratings_sound_subj);
                    
                    % Add to dataset
                    subject_ids_sound = [subject_ids_sound; repmat(subj_id, n_valid, 1)];
                    group_ids_sound = [group_ids_sound; repmat(g, n_valid, 1)];
                    time_ids_sound = [time_ids_sound; repmat(time_value, n_valid, 1)];
                    intensity_ids_sound = [intensity_ids_sound; valid_intensities_sound_subj'];
                    ratings_sound = [ratings_sound; valid_ratings_sound_subj'];
                    ages_sound = [ages_sound; repmat(age, n_valid, 1)];
                    genders_sound = [genders_sound; repmat(gender, n_valid, 1)];
                end
                 
                if ~isempty(valid_ratings_pressure_subj)
                    n_valid = length(valid_ratings_pressure_subj);
                    
                    % Add to dataset
                    subject_ids_pressure = [subject_ids_pressure; repmat(subj_id, n_valid, 1)];
                    group_ids_pressure = [group_ids_pressure; repmat(g, n_valid, 1)];
                    time_ids_pressure = [time_ids_pressure; repmat(time_value, n_valid, 1)];
                    intensity_ids_pressure = [intensity_ids_pressure; valid_intensities_pressure_subj'];
                    ratings_pressure = [ratings_pressure; valid_ratings_pressure_subj'];
                    ages_pressure = [ages_pressure; repmat(age, n_valid, 1)];
                    genders_pressure = [genders_pressure; repmat(gender, n_valid, 1)];
                end
            end
        end
    end

    % Create tables
    sound_table = table(subject_ids_sound, group_ids_sound, time_ids_sound, intensity_ids_sound, ratings_sound, ages_sound, genders_sound, ...
        'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'Rating', 'Age', 'Gender'});

    pressure_table = table(subject_ids_pressure, group_ids_pressure, time_ids_pressure, intensity_ids_pressure, ratings_pressure, ages_pressure, genders_pressure, ...
        'VariableNames', {'Subject', 'Group', 'Time', 'Intensity', 'Rating', 'Age', 'Gender'});

     % Convert Group to categorical
    sound_table.Group    = categorical(sound_table.Group);
    pressure_table.Group = categorical(pressure_table.Group);
    
    % Create PRT vs PLA tables (excluding Group 3 which is UC)
    PRTvsPLA_sound       = sound_table(sound_table.Group ~= "3", :);
    PRTvsPLA_sound.Group = removecats(PRTvsPLA_sound.Group);
    
    PRTvsPLA_pressure    = pressure_table(pressure_table.Group ~= "3", :);
    PRTvsPLA_pressure.Group = removecats(PRTvsPLA_pressure.Group);
    
    % Create PRT vs UC tables (excluding Group 2 which is PLA)
    PRTvsUC_sound       = sound_table(sound_table.Group ~= "2", :);
    PRTvsUC_sound.Group = removecats(PRTvsUC_sound.Group);
    
    PRTvsUC_pressure    = pressure_table(pressure_table.Group ~= "2", :);
    PRTvsUC_pressure.Group = removecats(PRTvsUC_pressure.Group);

end
