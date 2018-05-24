function showRDM(thisRDM)

% imagesc(squareform(thisRDM),[0 2]);

imagesc(thisRDM);
axis square;
set(gca,'XTick',[], 'YTick',[],'XTickLabel',{}, 'YTickLabel',{})
set(gcf,'Color','White')
colormap(jet)
end

