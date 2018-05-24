
%% set up
close all
clear all
clc
addpath('HelperCode') % add helper code

%% saving figure info
saveDir='Figures'
if ~exist(saveDir); mkdir(saveDir); end 
saveFigFlag=1;

%% plot RDMs for all layers or a specific one -- choose here.
% layerList = {'conv1', 'conv2', 'conv3', 'conv4', 'conv5', 'fc6', 'fc7'};
layerList = {'conv5'} % figure in CCN paper

%% Setup reordering index for rdms -- for grouping first by animacy and then size.
temp=1:276;
temp=squareform(temp); % indexes of all the dissimilarity columns
condList=[7:12,19:24,1:6,13:18] % list of conditions in the order you want them, have to trust me this is hardcoded right.
reOrdered=[]; i=0;
for c=condList
    i=i+1;
    vals=temp(c,condList);
    reOrder(i,:)=vals;
end
Index=squareform(reOrder,'tovector');

%% Get colors for MDS plots
categories={'BigAnimals','BigObjects','SmallAnimals','SmallObjects'}
prefs.condColor  = {[87 28 140], [27 56 245], [255 136 211], [255 145 48]}; % main contrasts

i=0; dotScale=20 ;counti=0;
for cat=1:4
    thisCat=categories{cat};
    countCat=0;
    for nestedFactors=1:6
        i=i+1;
        fullCondSizes(i)=nestedFactors*dotScale
        fullCondColors(i,:)=prefs.condColor{cat}./255; 
    end
end
fullCondSizes=fullCondSizes';

%% set up figure parameters
nCols = length(layerList);
countImType = 0;
imageTypes = {'Originals','Texforms','PhaseScrambled','Silhouettes'}
numImageTypes = length(imageTypes);

% toggle depending on showing one or many layers
if length(layerList)==1
    rdmFigure = subfigure(2,1,1);
    mdsFigure = subfigure(2,1,2);
end

%% load brain data and plot RDM/MDS
load('Data-BrainData/occipitoTemp_Multivariate11-Apr-2018.mat')
% patterns = 8 subjects x 276 dissimilarities (upper triangle of RDM) x 2 image types (originals, texforms)
origRDM=double(mean(patterns(:,:,1)',2)); %% 1 = originals, averages across 8 subjects.

% show neural RDM
[Y, e] = mdscale(squareform(origRDM),2);
figure(mdsFigure)
subplot(1,numImageTypes+1,1)
scatter(Y(:,1),Y(:,2),fullCondSizes,fullCondColors,'filled');
set(gca,'XTickLabel',{},'YTickLabel',{})
axis square; makepalettablescatter;

% show neural MDS
figure(rdmFigure)
subplot(1,numImageTypes+1,1)
showRDM(squareform(origRDM(Index)));


%% Main CNN feature plotting loop
for imageType = imageTypes
    
    countImType = countImType +1;
    clear I
    imageType = char(imageType);
    temp = load(['ImageModel-' imageType '.mat']);
    I = temp.I;
    if length(layerList)~=1
        rdmFigure = subfigure(2,1,1);
        mdsFigure = subfigure(2,1,2);
    end

    for i = 1:length(layerList)
    clear  featureMatrix featMatbyCat rdm_category
    % load data:
    layerName = layerList{i};
    [featureMatrix] = loadLayer('Data-AlexNet', layerName, I.stimSet);
    
    % compute image rdm
    distanceMetric = 'correlation'; %% correlation distance
    rdm = squareform(pdist(featureMatrix, distanceMetric));
    
    % compute category rdm
    featMatbyCat = collapseByCateg_ASTexforms(featureMatrix, I, 'fullCondInd'); 
    rdm_category = pdist(featMatbyCat, distanceMetric);
    
    %% show rdm
    figure(rdmFigure)
    if length(layerList)==1
       subplot(1,numImageTypes+1,countImType+1);
       title(I.stimSet)
    else
        subplot(1, nCols, i)
    end
    showRDM(squareform(rdm_category(Index))); %% resorts for easier viewing of categories%    
    
    %% compute mds and plot it
    [Y, e] = mdscale(squareform(rdm_category),2);
    figure(mdsFigure)
    if length(layerList)==1
        subplot(1,numImageTypes+1,countImType+1);
        title(I.stimSet)
    else
        subplot(1, nCols, i)
    end
    scatter(Y(:,1),Y(:,2),fullCondSizes,fullCondColors,'filled');   
    set(gca,'XTickLabel',{},'YTickLabel',{})
    axis square; makepalettablescatter;
 
    end
   
    if length(layerList)~=1
        figure(mdsFigure); 
        saveFigureHelper(saveFigFlag, saveDir, [I.stimSet 'MDS.png'])
        
        figure(rdmFigure); 
        saveFigureHelper(saveFigFlag, saveDir, [I.stimSet 'RDM.png'])
        close all;
    end
end




 if length(layerList)==1
     figure(mdsFigure);
     saveFigureHelper(saveFigFlag, saveDir, [layerList{1} 'MDS.png'])
     
     figure(rdmFigure); 
     saveFigureHelper(saveFigFlag, saveDir, [layerList{1} 'RDM.png'])
     close all;
 end

% %%  plot "route through shape space"
% layerList = {'conv1', 'conv2', 'conv3', 'conv4', 'conv5', 'fc6', 'fc7'};
% 
% for i = 1:length(layerList)
%     
%     % load data:
%     %layerName = getLayerNameFromMat(layerList{i});
%     layerName = layerList{i};
%     [Yflat] = loadLayer(layerName, I.stimSet);
%     
%     % get rdmvector
%     distanceMetric = 'correlation';
%     rdmVector = pdist(Yflat, distanceMetric);
% 
%     % save it:
%     layerNameAll{i} = layerName;
%     rdmAll(i,:) = rdmVector;
%                                              
% end
% disp('...done');
% size(rdmAll)
% 
% %% correlate the RDMs with each other
% 
% uberRDM = squareform(pdist(rdmAll, 'correlation'));
% 
% figure('Color', [ 1 1 1], 'Position', [ 235   593   885   355])
% 
% subplot(121)
% imagesc(uberRDM, [-1 1])
% colormap(jet);
% axis('square')
% set(gca, 'ytick', 1:24);
% set(gca, 'xtick', [])
% set(gca, 'yticklabel', layerNameAll)
% set(gca, 'FontSize', 16)
% 
% 
% subplot(122)
% xy = cmdscale(double(uberRDM), 2);
% plot(xy(:,1), xy(:,2), 'ko-', 'lineWidth', 3);
% set(gca, 'xtick', [-.5:.5:.5]);
% set(gca, 'ytick', [-.5:.5:.5]);
% axis('equal', 'square')
% box on
% set(gca, 'FontSize', 12)
% grid on;
% for i=1:length(xy)
%     text(xy(i,1)+.02, xy(i,2), layerNameAll{i}, 'FontSize', 12)
% end


%%

















