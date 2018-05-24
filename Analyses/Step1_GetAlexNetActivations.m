% Extract activations for each layer
% tkonkle@gmail.com, 23 april 2018
% continued bria long, bria@stanford.edu, May 2018

%%  set up
close all
clear all
clc
tic

%% get images:
% 4d array of images, [h w 3 N]

% load image model
load('ImageModel-Silhouettes');
% load('ImageModel-PhaseScrambled');
% load('ImageModel-Originals');
% load('ImageModel-Texforms');
I

% get images in 4d Cube
disp('reading in images...')
for i=1:I.numImages
    im = imread(I.imFullFilePath{i});
    im = imresize(im, [227 227]);
    if strcmp(I.stimSet,'Silhouettes')
        im = double(im) * 255; % is a logical vector, need to convert
    end
    allIms(:,:,:,i) = im;
end
size(allIms)
disp('...done getting images')


%% extract activations for each layer:
% get layers
nn = alexnet;
nn.Layers
keyboard

% seven layers to look at, use output of each stage, use pooling layers
% when avaliable
layerList = {'pool1', 'pool2', 'relu3', 'relu4', 'pool5', 'drop6', 'drop7'};
layerListHelper = {'conv1out', 'conv2out', 'conv3out', 'conv4out', 'conv5out', 'fc6out', 'fc7out'};
save('LayerNames.mat', 'layerList', 'layerListHelper');

% extract and save...
saveDir = 'Data-AlexNet';
if ~exist(saveDir, 'dir'), mkdir(saveDir), end

for thisLayer = 1:length(layerList)
    
    % fn
    layerName = layerList{thisLayer};
    layerNameHelper = layerListHelper{thisLayer};
    fn = fullfile(saveDir, [I.stimSet '_' num2str(thisLayer) '_' layerNameHelper '-all.mat']);
    disp(layerNameHelper)
    
    % if already made
    if exist(fn, 'file')>0
        disp('... already made')
    else
        disp('computing activations');
        tic
        X = allIms;
        
        % make 3 channels artificially since bw images
        X(:,:,2,:)=X(:,:,1,:);
        X(:,:,3,:)=X(:,:,1,:);
        
        Y = activations(nn, X, layerName, 'OutputAs', 'channels');
        save(fn, 'Y', 'layerName', 'layerNameHelper');

    end
end
toc
%%

