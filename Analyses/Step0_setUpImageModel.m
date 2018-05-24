% % step0 - set up image model

% this code creates and saves a struct I
% which has pointers to all image files
% and what "conditions" they come from
% and all other meta data desired from each stimulus

%% set up
close all
clear all
clc
addpath('HelperCode');
%%
stimSet = 'Originals';
stimDir = '../Stimuli/Originals';
saveDir = pwd;
I = setUpImageModelASTexforms(stimSet, stimDir, saveDir);

%%
stimSet = 'Texforms';
stimDir = '../Stimuli/Texforms';
saveDir = pwd;
I = setUpImageModelASTexforms(stimSet, stimDir, saveDir);

%%
stimSet = 'Silhouettes';
stimDir = '../Stimuli/Silhouettes';
saveDir = pwd;
I = setUpImageModelASTexforms(stimSet, stimDir, saveDir);

%%
stimSet = 'PhaseScrambled';
stimDir = '../Stimuli/PhaseScrambled';
saveDir = pwd;
I = setUpImageModelASTexforms(stimSet, stimDir, saveDir);

