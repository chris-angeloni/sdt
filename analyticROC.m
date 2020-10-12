function [auc,pHit,pFa] = analyticROC(signalMean,noiseMean,commonSd,criteria)

% Compute ROC curve
for i = 1:length(criteria)
    [pHit(i),pFa(i)] = AnalyticpHitpFa(signalMean,noiseMean,commonSd,criteria(i));
end

% Integrate numerically to get area.  The negative
% sign is because the way the computation goes, the hit rates
% decrease with increasing criteria.
auc = -trapz([1 pFa 0],[1 pHit 0]);


end

% hit and false alarm rates
function [pHit,pFa] = AnalyticpHitpFa(signalMean,noiseMean,commonSd,rightCrit)

pHit = 1-normcdf(rightCrit,signalMean,commonSd);
pFa = 1-normcdf(rightCrit,noiseMean,commonSd);

end