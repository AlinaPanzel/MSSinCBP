function pat_table = apply_FM_patterns(dat, varargin)

% This is a compact way to assign multiple variables. The input argument
% names and variable names must match, however:

%similarity_metric = 'dotproduct';
%similarity_metric = 'cosine_similarity';
%intcpts = [0 0 0 0 0];

%intcpts = [0.1831233   0.0175146   0.1473605   0.0037268   0.0145212];

allowable_inputs = {'similarity_metric'};

% optional inputs with default values - each keyword entered will create a variable of the same name

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}

            case 'cosine_similarity'
                
                similarity_metric = 'cosine_similarity';
                
            case 'correlation'
                
                similarity_metric = 'correlation';
                
            case allowable_inputs
                
                eval([varargin{i} ' = varargin{i+1}; varargin{i+1} = [];']);
                
            otherwise, warning(['Unknown input string option:' varargin{i}]);
        end
    end
end

% Zero out intercepts if they are not meaninful for chosen similarity metric
if strcmp(similarity_metric, 'cosine_similarity') || strcmp(similarity_metric, 'correlation')
    intcpts = [0 0 0 0 0];
end

% -------------------------------------------------------------------------
% LOAD PATTERNS (MODELS) AND APPLY THEM TO DATA
% -------------------------------------------------------------------------

    pats = load_image_set('fm');
    
    pexps = apply_mask(dat, pats, 'pattern_expression', similarity_metric);
    
    % Add intercepts for each model (or zeros for cosine_sim/corr)
    
    for i = 1:2
        pexps(:, i) = pexps(:, i) + intcpts(:, i);
    end
    
    pat_table = array2table(pexps, 'VariableNames', {'FM_PAIN','FM_MSS'});
    

end


