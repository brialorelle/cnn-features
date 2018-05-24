function [SV] = computeSharedVariance(RDM_Y, RDM_X1, RDM_X2)
% computeSharedVariance(RDM_X, RDM_Y1, RDM_Y2)
% Computes the share variance between two RDMs that predict a third RDM
% (RDM_Y)
% pg. 25 bonner et al., 2018, "Commonality anlaysis

% rescale between 0 and 1 just in case
RDM_X1 = scale01(RDM_X1);
RDM_X2 = scale01(RDM_X2);

%% RDM size checks -- should be flat and all the same
assert(length(RDM_Y) == length(RDM_X1),'RDMs not the same size!')
assert(length(RDM_Y) == length(RDM_X2),'RDMs not the same size!')

%% note:glmfit and regstats automatically includes a constant term
% [bothFit.b, bothFit.dev, bothFit.stats] = regstats([RDM_X1, RDM_X2],RDM_Y);
% [fit_X1.b, fit_X1.dev, fit_X1.stats] = glmfit(RDM_X2, [RDM_Y]);
% [fit_X2.b, fit_X2.dev, fit_X2.stats]  = glmfit(RDM_X1, [RDM_Y]);

[bothFit]= regstats(RDM_Y,[RDM_X1, RDM_X2]);
[fit_X1] = regstats(RDM_Y, [RDM_X1]);
[fit_X2] = regstats(RDM_Y, [RDM_X2]);

% unique contribution of X1 to predicting Y
y1 = bothFit.rsquare - fit_X2.rsquare;

% common contribution of X1 & X2 to predicting Y 
y12 = fit_X1.rsquare + fit_X2.rsquare - bothFit.rsquare;

if y12 < 0
    disp(['negative common contribution' y12 '--substituting zero!'])
    y12=0
end
    
%% output shared variance
SV = 100 * (y12 / (y12 + y1));

end

