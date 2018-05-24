function idx = trimVoxelsWithNotEnoughVariation(featureMatrix)


% if ndims(featureMatrix)==2

    xnorm = sqrt(sum(featureMatrix.^2, 2));
    idx = xnorm <= eps(max(xnorm));
    
    %featureMatrixTrimmed = featureMatrix;
    %featureMatrixTrimmed(idx,:) = [];
    
    disp(sprintf('trim %d voxels with SD<%2.2f', sum(idx), exp(max(xnorm))));


% else
%     % loop through each sub?
%     featureMatrix3d = featureMatrix;
%     idxAll = zeros(size(featureMatrix, 1), 1);
%     for i=1:size(featureMatrix3d,3)
%         
%         featureMatrix = featureMatrix3d(:,:,i);
%         
%         
%         xnorm = sqrt(sum(featureMatrix.^2, 2));
%         idx = xnorm <= eps(max(xnorm));
%         
%         %featureMatrixTrimmed = featureMatrix;
%         %featureMatrixTrimmed(idx,:) = [];
%         
%         disp(sprintf('trim %d voxels with SD<%2.2f', sum(idx), exp(max(xnorm))));
%         
%         
%         idxAll(idx) = 1;
%     end
%     
%     disp(sprintf('\n\n Total trim %d voxels with SD<%2.2f', sum(idxAll), exp(max(xnorm))));
% 
% end

