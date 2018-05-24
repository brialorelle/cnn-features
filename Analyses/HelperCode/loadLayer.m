function [featureMatrix] = loadLayerAllFeat(activationDir, layerName, imSetName)


% find the right activation mat
LayerInd = (layerName(end));
temp = fullfile(activationDir, [imSetName '_' LayerInd '_' layerName 'out.mat']);
fn = dir(temp);
if length(fn)==0
    disp('no matching activation mat')
    keyboard
elseif length(fn)>1
    disp('too many matching activation mats')
    keyboard
end


% load it
load(fullfile(activationDir,fn.name));



% % get num ims
% numIms = size(featureMatrix, 1);
% 
% % reshape to organize BY neuron (240 x n);
% Yflat = reshape(featureMatrix, [], numIms)';





