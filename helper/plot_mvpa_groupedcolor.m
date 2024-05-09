function plot_mvpa_groupedcolor(o, data, pattern)

if strcmpi(pattern, 'NegAffect')
    prexps = data;
    fields = fieldnames(o);

    % Plot multivariate aversive patterns
    figure;
    type = fieldnames(prexps.(fields{1}));
    stimname = 'Aversive patterns';
    sgt = sgtitle("Multivariate Aversive Patterns");
    sgt.FontSize = 35;
    HC = [1 3 5 7 9];
    CLBP = [2 4 6 8 10];
    A = ["Generalized negative affect" "Stimulus-specific: pressure" "Stimulus-specific: sound"];
    figurename = string(A);
    patterns = [1 2 4]; % General, Mechanical, Sound

    clear mat;
    clear sd;


    for t = 1:numel(patterns) % t = type of patterns to iterate through (General, Mechanical ...)
        i = patterns(t);
        subplot(1,3,t);

        for c = 1:4 % c = number of conditions per group (Thumb high, Thumb low ...)
            p = c + 6; % p = position of HC in fieldnames in o
            mat{HC(c)} = rmoutliers(prexps.(fields{p}).(type{i}), 'mean');
            mat{CLBP(c)} = rmoutliers(prexps.(fields{c}).(type{i}), 'mean');
        end

        disp(figurename)
        colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(t)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.1 0.5];
        set(gca,'XTick',[]);

    end

elseif strcmpi(pattern, 'FM')
    pat_tabl = data;

    fields = fieldnames(o);

    % Plot FM patterns
    figure;
    type = fieldnames(pat_tabl.(fields{1}));
    stimname = 'FM patterns';
    sgt = sgtitle("Fibromyalgia Patterns");
    sgt.FontSize = 35;
    HC = [1 3 5 7 9];
    CLBP = [2 4 6 8 10];
    A = ["FM Pain" "FM Multisensory"];
    figurename = string(A);
    pattern = [1 2]; % FM Pain, FM MSS

    clear mat;
    clear sd;


    for t = 1:numel(pattern) % t = type of patterns to iterate through (General, Mechanical ...)
        i = pattern(t);
        subplot(1,2,t);

        for c = 1:4 % c = number of conditions per group (Thumb high, Thumb low ...)
            p = c + 6; % p = position of HC in fieldnames in o
            mat{HC(c)} = rmoutliers(pat_tabl.(fields{p}).(type{i}), 'mean');
            mat{CLBP(c)} = rmoutliers(pat_tabl.(fields{c}).(type{i}), 'mean');
        end

        disp(figurename)
        colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(t)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.01 0.03];
        set(gca,'XTick',[]);

    end


end