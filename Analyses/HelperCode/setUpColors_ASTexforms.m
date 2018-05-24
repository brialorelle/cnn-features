
categories={'BigAnimals','BigObjects','SmallAnimals','SmallObjects'}
prefs.condColor  = {[87 28 140], [27 56 245], [255 136 211], [255 145 48]}; % main contrasts

i=0; dotScale=60 ;counti=0;
for cat=1:4
    thisCat=categories{cat};
    countCat=0;
    for nestedFactors=1:6
        i=i+1;
        prefs.fullColors{i}=prefs.condColor{cat}*(nestedFactors/6);
        prefs.fullColorsUni{i}=prefs.condColor{cat};
        %
        prefs.fullCondSizes(i)=nestedFactors*dotScale
        colorPlotUni(i,:)=prefs.condColor{cat}./255; 
        scaleFactor=scale01(S.(thisCat).TotalAccScoreSorted)+.01;
        
        for ii=1:5
            counti=counti+1;
            countCat=countCat+1;
            fullColorsUni120(counti,:)=prefs.condColor{cat}./255;
            fullSizesUni120(counti)=1+scaleFactor(countCat)*dotScale;       
        end
    end
end