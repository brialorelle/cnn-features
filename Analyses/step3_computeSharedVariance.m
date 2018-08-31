%% set up
close all
clear all
clc
addpath('HelperCode') % add helper code

%% saving figure info
saveDir='Figures'
if ~exist(saveDir); mkdir(saveDir); end 
saveFigFlag=1;

%% Load neural data
load('Data-BrainData/occipitoTemp_Multivariate11-Apr-2018.mat')
% patterns = 8 subjects x 276 dissimilarities (upper triangle of RDM) x 2 image types (originals, texforms)
origNeuralRDM=double(mean(patterns(:,:,1)',2)); %% 1 = originals, averages across 8 subjects.
distanceMetric = 'correlation'; % specify distance metric
layerList = {'conv1', 'conv2', 'conv3', 'conv4', 'conv5', 'fc6', 'fc7'};

% grab cnn RDMs for each image type
for imageType = {'Originals','Texforms','Silhouettes','PhaseScrambled'}
    clear I
    imageType = char(imageType);
    temp = load(['ImageModel-' imageType '.mat']);
    I = temp.I;
    for i = 1:7
        clear featureMatrix featMatbyCat
        % load data:
        layerName = layerList{i};
        [featureMatrix] = loadLayer('Data-AlexNet', layerName,  I.stimSet);
        
        % compute category rdm
        featMatbyCat = collapseByCateg_ASTexforms(featureMatrix, I, 'fullCondInd');
        cnn_rdm_category.(replaceDash(imageType)){i} = pdist(featMatbyCat, distanceMetric);
    end
end

%% compute orig-CNN fit and shared variance with other feature types in each layer
for layerInd = 1:7
    % fit original RMD with original cnn features in each layer
    origCnnRDM=cnn_rdm_category.Originals{layerInd}';
    origFitLayer= regstats(origNeuralRDM, origCnnRDM);
    origFit(layerInd) = origFitLayer.rsquare;

    
    % now grab cnn rdms for this layer
    texCnnRDM=cnn_rdm_category.Texforms{layerInd}';
    texFitLayer= regstats(origNeuralRDM, texCnnRDM);
    texFit(layerInd) = texFitLayer.rsquare;
    
    %%
    silCnnRDM=cnn_rdm_category.Silhouettes{layerInd}';
    phaseCnnRDM=cnn_rdm_category.PhaseScrambled{layerInd}';
    
    % and compute shared variance 
    SV.OrigvTex(layerInd) = computeSharedVariance(origNeuralRDM, origCnnRDM, texCnnRDM);
    SV.OrigvSilhouette(layerInd) = computeSharedVariance(origNeuralRDM, origCnnRDM, silCnnRDM);
    SV.OrigvPhaseScram(layerInd) = computeSharedVariance(origNeuralRDM, origCnnRDM, phaseCnnRDM);
end

%% Make key figure
subfigure(2,3,1)
lb=2; ub=7; % layers to plot
comparisons = {'OrigvTex','OrigvPhaseScram','OrigvSilhouette'}
Colors = {[130 130 130],[1 123 118],[86 200 194]}

for layer=lb:ub
   subplot(1,ub-lb+1,layer-lb+1)
   for c=1:length(comparisons)
       thisComparison = comparisons{c};
       toPlot(c) = SV.(thisComparison)(layer);
       bar(c,toPlot(c),'FaceColor',Colors{c}./255); hold on;
       ylim([0 100])
   end
   makepalettablescatter; set(gca,'XTick',[],'YTickLabel',[]); 
   set(gca,'FontSize',18)
end

