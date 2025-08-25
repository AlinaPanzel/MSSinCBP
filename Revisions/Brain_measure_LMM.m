%% Set up & clearn
T = con_long;                             % columns: subID,timepoint,group,intensity,measure,value
T.value     = double(T.value);
T.subID     = categorical(T.subID);
T.group     = categorical(T.group);
T.timepoint = categorical(T.timepoint);
T.intensity = categorical(T.intensity);
T.measure   = categorical(T.measure);

measures = categories(T.measure);

save('brain_measures_longformat.mat', 'con_long');


%% Fit & test
% 
results = table(strings(0,1), zeros(0,1), nan(0,1), nan(0,1), nan(0,1), nan(0,1), ...
    'VariableNames', {'measure','NumObs','F','df1','df2','p'});
models  = struct('measure',{},'lme',{});

for k = 1:numel(measures)
    m  = measures{k};
    Tk = T(T.measure == m, :);
    Tk = Tk(~ismissing(Tk.value), :);

    if height(Tk) < 5 || numel(categories(Tk.group))<2 || numel(categories(Tk.timepoint))<2
        results = [results; {string(m), height(Tk), NaN, NaN, NaN, NaN}];
        continue
    end

    lme = fitlme(Tk, 'value ~ group*timepoint + intensity + (1|subID)');

    % joint test of all group:timepoint coefficients
    cn = string(lme.CoefficientNames);
    J  = find(contains(cn,"group") & contains(cn,"timepoint"));
    if isempty(J), F=NaN; df1=NaN; df2=NaN; p=NaN;
    else
        L = zeros(numel(J), numel(cn));
        for i=1:numel(J), L(i,J(i)) = 1; end
        [p,F,df1,df2] = coefTest(lme, L);
    end

    results = [results; {string(m), height(Tk), F, df1, df2, p}];
    models(end+1).measure = string(m); %#ok<SAGROW>
    models(end).lme = lme;
end

% FDR (Benjamini–Hochberg)
p = results.p; keep = ~isnan(p); q = nan(size(p));
if any(keep), [~,~,~,q(keep)] = fdr_bh(p(keep)); end
results.q_BH = q;

% nice printing table
Rprint = sortrows(results, 'p');
Rprint.F   = round(Rprint.F,3);
Rprint.df1 = round(Rprint.df1,2);
Rprint.df2 = round(Rprint.df2,2);
Rprint.p   = round(Rprint.p,4);
Rprint.q_BH= round(Rprint.q_BH,4);

disp('=== Group × Time interaction (per measure) ===');
disp(Rprint);

% (optional) save to CSV
% writetable(Rprint, 'lmm_groupXtime_results.csv');

%% Figures

valid = ~isnan(results.p);
[~, ord] = sort(results.p(valid), 'ascend');
meas_sorted = string(results.measure(valid));
neglogp = -log10(results.p(valid));
meas_sorted = meas_sorted(ord); neglogp = neglogp(ord);

figure('Color','w');
bar(neglogp);
xticks(1:numel(meas_sorted)); xticklabels(meas_sorted); xtickangle(35);
ylabel('-log_{10}(p)'); title('group \times time interaction by measure');
yline(-log10(0.05),'--','\alpha = 0.05','LabelHorizontalAlignment','left'); grid on; box off;

% % Heatmap 
% figure('Color','w');
% imagesc(neglogp(:)'); colorbar; colormap(parula);
% title('-log_{10}(p) (sorted)'); set(gca,'YTick',[],'XTick',1:numel(meas_sorted),'XTickLabel',meas_sorted); xtickangle(35);

%% Mean plots

sigOrTop = string(Rprint.measure(1:min(6,height(Rprint)))); % top 6 by p
tl = tiledlayout(ceil(numel(sigOrTop)/2), 2, 'TileSpacing','compact','Padding','compact');
for i = 1:numel(sigOrTop)
    nexttile;
    Tk = T(T.measure == categorical(sigOrTop(i)), :);
    S  = summarize_by_gtx(Tk); % mean/std/n/sem per group×time×intensity

    grpLevels = categories(S.group);
    intLevels = categories(S.intensity);
    C = lines(numel(grpLevels));
    hold on;
    for gi = 1:numel(grpLevels)
        for ii = 1:numel(intLevels)
            rows = S.group==grpLevels{gi} & S.intensity==intLevels{ii};
            if ~any(rows), continue; end
            x = double(S.timepoint(rows));
            y = S.mean(rows);
            e = S.sem(rows);
            off = (ii - (numel(intLevels)+1)/2) * 0.08;
            errorbar(x+off, y, e, '-o', 'Color', C(gi,:), 'MarkerFaceColor', C(gi,:));
        end
    end
    title(sigOrTop(i)); xlabel('Time'); ylabel('Mean \pm SEM'); grid on; box off;
    hold off;
end
title(tl, 'Raw means by group × time × intensity');



%% ==================== HELPER FUNCTIONS ====================
function S = summarize_by_gtx(Tk)
% mean/std/n/sem by group×time×intensity
[grp, gL, tL, iL] = findgroups(Tk.group, Tk.timepoint, Tk.intensity);
meanVal = splitapply(@mean, Tk.value, grp);
stdVal  = splitapply(@std,  Tk.value, grp);
nVal    = splitapply(@numel, Tk.value, grp);
semVal  = stdVal ./ sqrt(nVal);
S = table(gL, tL, iL, meanVal, stdVal, nVal, semVal, ...
    'VariableNames', {'group','timepoint','intensity','mean','std','n','sem'});
end

function [h, crit_p, adj_ci_cvrg, q] = fdr_bh(pvals,q,method,report)
% Benjamini–Hochberg FDR
if nargin<2||isempty(q), q=.05; end
if nargin<3||isempty(method), method='pdep'; end
if nargin<4, report=''; end 
p = pvals(:); [ps, idx] = sort(p);
V = numel(ps); I = (1:V)';
cV = strcmpi(method,'pdep')*1 + strcmpi(method,'dep')*sum(1./(1:V));
if cV==0, cV=1; end
thresh = (I/V)*q/cV;
isSig = ps<=thresh; cut = find(isSig,1,'last');
h = false(size(p)); if ~isempty(cut), h(idx(1:cut)) = true; end
crit_p = []; if ~isempty(cut), crit_p = ps(cut); end
q = nan(size(p)); if ~isempty(ps), q(idx) = min(1, cummin((V./I).*ps, 'reverse')); end
adj_ci_cvrg = NaN;
end
