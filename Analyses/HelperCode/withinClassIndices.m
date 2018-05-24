function classIndices =  withinClassIndices(RDM,num_classes,obs_per_class)
[x,y] = size(RDM);
if x ~= y
    fprintf('ERROR: RDM is not a square.')
end

classIndices = zeros(x,x);

for classIdx = 1:num_classes
    classStartingIdx = classIdx * obs_per_class - (obs_per_class - 1);
    classEndingIdx = classStartingIdx + (obs_per_class - 1);
    classIndices(classStartingIdx:classEndingIdx,classStartingIdx:classEndingIdx) = 1;
end