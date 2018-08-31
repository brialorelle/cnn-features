function showRDM(thisRDM)

minRDM = min(squareform(thisRDM,'tovector'));
maxRDM = max(squareform(thisRDM,'tovector'));
imagesc(thisRDM,[minRDM maxRDM]);
axis square;
set(gca,'XTick',[], 'YTick',[],'XTickLabel',{}, 'YTickLabel',{})
set(gcf,'Color','White')
colormap(jet)
end

