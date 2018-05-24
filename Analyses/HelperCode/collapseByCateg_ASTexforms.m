function fm2 = collapseByCateg_ASTexforms(fm, I, condIndField)


fm2=[];
for i=1:length(unique(I.(condIndField)))
    fm2(i,:) = mean(fm(I.(condIndField)==i,:));
end