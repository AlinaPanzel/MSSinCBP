% This script makes a group by time plot for OLP4CBP study from standard metadata
%
% :Usage:
% ::
%
%     lme = plot_MSS_group_by_time(metadata, outcome, [optional inputs])
%
%
%     Copyright (C) 2020 Yoni Ashar
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ..
%
% :Inputs:
%
%   **metadata:**
%        table in standard format, with fields 'group' 'time'
%
%   **outcome:**
%        a field in metadata to use as the outcome
%
%   **'plothealthies':**
%        Add a tile with the distribution of healthy controls next to the
%        group by time plot
%
% :Outputs:
%
%   **lme:**
%        mixed effects model
%
function [h1, h2, h3, tabl_delta] = plot_MSS_group_by_time(tabl, outcome, varargin)

ms = 50; % marker size
placebo_color = [.5 0 .5];
tau_color = [.3 .3 .3];


% Logical flags
% ----------------------------------------------------------------------
plothealthies=false;

if any(strcmp(varargin, 'plothealthies')), plothealthies=true; end

wh_T1 = tabl.Time==0;
wh_T2 = tabl.Time==1;
wh_prt = tabl.Group==1;
wh_pla = tabl.Group==2;
wh_wl = tabl.Group==3;

%% Interaction plot

if plothealthies
    tiledlayout(1,2)
    nexttile
else
    create_figure(['grp by time ' outcome num2str(randi(1000))], 1, 1); 
end

h1=lineplot_columns( {tabl.(outcome)(wh_T1 & wh_prt) tabl.(outcome)(wh_T2 & wh_prt)}, 'color', 'b', 'x', [1 2]); hold on
h2=lineplot_columns( {tabl.(outcome)(wh_T1 & wh_wl) tabl.(outcome)(wh_T2 & wh_wl)}, 'color', [.3 .3 .3], 'x', [1.03 2.03]);  hold on
h3=lineplot_columns( {tabl.(outcome)(wh_T1 & wh_pla) tabl.(outcome)(wh_T2 & wh_pla)}, 'color', placebo_color, 'x', [.97 1.97]);

set(gca, 'XTick', [1 2], 'XTickLabel', {'Baseline' 'Post-tx'}, 'FontSize', 16)
ylabel(format_strings_for_legend(outcome))

legend([h1.line_han h3.line_han h2.line_han],{'PRT' 'Placebo' 'Usual Care'}, 'Location', 'SW')

xlim([.9 2.1])

if plothealthies
    nexttile
    boxchart(tabl.(outcome)(~tabl.is_patient))
end
    

h1=gcf;

end

%%  plot ind diffs: outcome by change in pain -- take code from plot_olp4cbp_group_by_time.m
