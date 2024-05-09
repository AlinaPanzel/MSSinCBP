function plot_roi_groupedcolor(o, roi, region)
if strcmpi(region, 'Aud')

    figure('Name','Unisensory Auditory');
    HC = [1 3 5 7 9 11];
    CLBP = [2 4 6 8 10 12];

    A = ["A1" "MGN" "IC"];
    %B = ["Primary Auditory Cortex" "Medial Geniculate nucleus" "Inferior Colliculus"];
    figurename = string(A);
    clear sd;
    clear mat
    sgt = sgtitle('Unisensory Auditory');
    sgt.FontSize = 35;
    fields = fieldnames(o);

    for c = 1:numel(A) % c = number of areas
        subplot(1,3,c);
        for t = 1:4 % t = type of conditions (thumb low, thumb high..)
            p = t + 6; % p = position of HC in fieldnames in o
            mat{HC(t)} = rmoutliers(roi.(A{c}).(fields{p})(:,1), 'mean');
            mat{CLBP(t)} = rmoutliers(roi.(A{c}).(fields{t})(:,1),'mean');
            %sd.(fields{c})(:,t) = std(mat{t});
        end
        disp(figurename)
        %figure;
        %colors = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
        %colors1 = { [0.1211    0.5859    0.5430] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725] [0.7059    0.8706    0.1725]  [1     1     0] [1 1 0]};
        colors1 = { [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};

        %colors2 = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(c)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.5 3.5];
        set(gca,'XTick',[]);


    end

elseif strcmpi(region, 'Mechfused')

    figure('Name','Unisensory Mechanical');
    HC = [1 3 5 7 9 11];
    CLBP = [2 4 6 8 10 12];

    A = ["S1_L" "S1_R"];
    B = ["S1 Left" "S1 Right"];

    figurename = string(B);
    clear mat;
    sgt = sgtitle('Unisensory Mechanical');
    sgt.FontSize = 35;
    fields = fieldnames(o);

    for c = 1:numel(A) % c = number of areas
        subplot(2,2,c);
        for t = 1:4 % t = type of conditions (thumb low, thumb high..)
            p = t + 6; % p = position of HC in fieldnames in o
            mat{HC(t)} = rmoutliers(roi.(A{c}).(fields{p})(:,1), 'mean');
            mat{CLBP(t)} = rmoutliers(roi.(A{c}).(fields{t})(:,1),'mean');
        end
        disp(figurename)
        %colors1 = { [0.1211    0.5859    0.5430] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725] [0.7059    0.8706    0.1725]  [1     1     0] [1 1 0]};
        colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};
        %colors2 = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(c)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.4 0.7];
        set(gca,'XTick',[]);


    end

elseif strcmpi(region, 'Selfref')

    figure('Name','Self-referential');
    HC = [1 3 5 7 9 11];
    CLBP = [2 4 6 8 10 12];

    A = ["mPFC" "precuneus" "PCC" ];
    figurename = string(A);
    clear sd;
    clear mat;
    sgt = sgtitle('Self-Referential Areas');
    sgt.FontSize = 35;
    fields = fieldnames(o);


    for c = 1:numel(A) % c = number of areas
        subplot(1,3,c);
        for t = 1:4 % t = type of conditions (thumb low, thumb high..)
            p = t + 6; % p = position of HC in fieldnames in o
            mat{HC(t)} = rmoutliers(roi.(A{c}).(fields{p})(:,1), 'mean');
            mat{CLBP(t)} = rmoutliers(roi.(A{c}).(fields{t})(:,1),'mean');
        end
        disp(figurename)
        %colors1 = { [0.1211    0.5859    0.5430] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725] [0.7059    0.8706    0.1725]  [1     1     0] [1 1 0]};
         colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};

        %colors2 = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(c)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.4 0.3];
        set(gca,'XTick',[]);


    end

elseif strcmpi(region, 'm_insula')

    figure('Name','Sensory-Integrative');
    HC = [1 3 5 7 9 11];
    CLBP = [2 4 6 8 10 12];

    A = ["m_ventral_insula" "m_dorsal_insula" "m_posterior_insula"];
    F = ["vIns" "dIns" "pIns"];
    figurename = string(F);

    clear sd;
    clear mat;
    sgt = sgtitle('Sensory-Integrative');
    sgt.FontSize = 35;
    fields = fieldnames(o);

    for c = 1:numel(A) % c = number of areas
        subplot(1,3,c);
        for t = 1:4 % t = type of conditions (thumb low, thumb high..) (4 = sound/pressure high/low, 6 = including intensities )
            p = t + 6; % p = position of HC in fieldnames in o
            mat{HC(t)} = rmoutliers(roi.(A{c}).(fields{p})(:,1), 'mean');
            mat{CLBP(t)} = rmoutliers(roi.(A{c}).(fields{t})(:,1),'mean');
            %sd.(fields{c})(:,t) = std(mat{t});
        end
        %colors1 = { [0.1211    0.5859    0.5430] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725] [0.7059    0.8706    0.1725]  [1     1     0] [1 1 0]};
        colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};

        %colors2 = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
        [handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', (figurename(c)), 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

        hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
        hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

        ax = gca;
        ax.YLim = [-0.1 0.7];
        set(gca,'XTick',[]);
    end



end