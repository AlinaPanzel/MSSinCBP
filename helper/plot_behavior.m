function plot_behavior(d)


% Behavioral rating figure
figure('Name','Unpleasantness ratings');
HC = [1 3 5 7 9 11];
CLBP = [2 4 6 8 10 12];

%A = "Unpleasantness ratings";
%B = ["Primary Auditory Cortex" "Medial Geniculate nucleus" "Inferior Colliculus"];
figurename = "Unpleasantness ratings";
clear sd;
clear mat
%sgt = sgtitle('Unpleasantness ratings');
%sgt.FontSize = 35;
%fields = fieldnames(o);

mat{HC(1)} = rmoutliers(d.HC_metadata.acute_mean_thumb_lo(:,1), 'mean');
mat{CLBP(1)} = rmoutliers(d.CLBP_metadata.acute_mean_thumb_lo(:,1),'mean');
mat{HC(2)} = rmoutliers(d.HC_metadata.acute_mean_thumb_hi(:,1), 'mean');
mat{CLBP(2)} = rmoutliers(d.CLBP_metadata.acute_mean_thumb_hi(:,1),'mean');
mat{HC(3)} = rmoutliers(d.HC_metadata.acute_mean_sound_lo(:,1), 'mean');
mat{CLBP(3)} = rmoutliers(d.CLBP_metadata.acute_mean_sound_lo(:,1),'mean');
mat{HC(4)} = rmoutliers(d.HC_metadata.acute_mean_sound_hi(:,1), 'mean');
mat{CLBP(4)} = rmoutliers(d.CLBP_metadata.acute_mean_sound_hi(:,1),'mean');

%figure;
%colors = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
colors1 = {  [0.7216    0.8824    0.5255] [0.7216    0.8824    0.5255]  [0.4980    0.7373    0.2549] [0.4980    0.7373    0.2549] [0.6980    0.6706    0.8235] [0.6980    0.6706    0.823] [ 0.5020    0.4510    0.6745] [ 0.5020    0.4510    0.6745]};

%colors2 = { [0.2656    0.0039    0.3281] [0.2812    0.1484    0.4648] [0.1992    0.3867    0.5508] [0.1211    0.5859    0.5430] [ 0.4275    0.8039    0.3490] [0.7059    0.8706    0.1725]  [1     1     0] [0.9922    0.9059    0.1451]};
[handles] = barplot_columns(mat, '95CI','noviolin', 'noind', 'nostars','plotout','title', figurename, 'colors',colors1,'nofig', 'ind','LineStyle',':', 'names', {'HC: Pressure low ', 'CLBP: Pressure low ', 'HC: Pressure high ', 'CLBP: Pressure high', 'HC: Sound low ', 'CLBP: Sound low ','HC: Sound high ', 'CLBP: Sound high '}, 'x', [1,1.8,3,3.8,5,5.8,7,7.8]);

hatchfill2(handles.bar_han{2},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
hatchfill2(handles.bar_han{4},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
hatchfill2(handles.bar_han{6},'single','HatchAngle',45,'hatchcolor',[0 0 0]);
hatchfill2(handles.bar_han{8},'single','HatchAngle',45,'hatchcolor',[0 0 0]);

ax = gca;
ax.YLim = [0 100];
set(gca,'XTick',[]);

%map = brewermap(9,'PRGn');



end