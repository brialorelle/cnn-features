function I = setUpImageModelASTexforms(stimSet, stimDir, saveDir)

% get the list of images
% sets the classes they belong to based on the subfolder structure

% eventually may be worth implementing this as a data set, with multiple
% grouping factors...

% already computed?
matname = ['ImageModel-' stimSet '.mat'];
saveFileName = fullfile(saveDir, matname);
if exist(saveFileName, 'file')
    disp('... image model already set up, loading existing file');
    ImageModel = load(saveFileName);
    I = ImageModel.ImageModel;
    return
end

% else make it!
disp('...set up image model');

% initialize I
I.stimSet = stimSet;
I.stimDir = stimDir;

% loop through images
disp('... looping through images')

% get folders
folders = getSubfolders(stimDir);

% set up colors for later
categories={'BigAnimals','BigObjects','SmallAnimals','SmallObjects'}
condColor  = {[87 28 140], [27 56 245], [255 136 211], [255 145 48]}; % main contrasts

% set up counters
countIms=0; % for all image
countCond=0; % for all 24 sub conditions

% loop throough
for f=1:length(folders)
    thisFolder = folders(f).name;
    subfolders = getSubfolders([stimDir filesep thisFolder]);
    
    for s=1:length(subfolders);
        
        countCond = countCond+1;
        thisSubfolder = subfolders(s).name;
        % if not png, try jpg
        temp = dir(fullfile([stimDir filesep thisFolder filesep thisSubfolder], '*.png'));
        if length(temp)==0
           temp = dir(fullfile([stimDir filesep thisFolder filesep thisSubfolder], '*.jpg'));
        end
        %
        for i=1:length(temp)
            % increase counter
            countIms = countIms +1;
            
            % this image:
            thisIm = temp(i);

            % image inforamtion
            I.imName{countIms}              = thisIm.name(1:end-length('*.png')+1);
            I.imFullFilePath{countIms}      = fullfile(stimDir, thisFolder, thisSubfolder, thisIm.name);
            assert(exist(I.imFullFilePath{countIms}, 'file')>0)
            
            % label information
            I.category{countIms}          = thisFolder;
            I.classifiability{countIms}   = thisSubfolder;
            I.fullCondInd(countIms)       = countCond;
            
            I.fourCondInd(countIms) = find(strcmp(thisFolder,categories));
            I.condColor(countIms)   = condColor(I.fourCondInd(countIms));
        end
    end
end





I.numImages = length(I.imName);

% save it:'
disp('saving')
if ~exist(saveDir, 'dir'), mkdir(saveDir), end;
save(saveFileName, 'I');
