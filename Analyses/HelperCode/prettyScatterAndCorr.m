function prettyScatterAndCorr(x, y, pointLabels)


doPointLabels=1;
if nargin<3
    doPointLabels = 0;
    pointLabels = [];
end

% this setting makes sure figure will print in the size that you set
% set(gcf,'PaperPositionMode','auto');

% shrink the figure in, so you can scoot the axis labels out a bit
%h1=axes('FontSize',12);
%a=get(h1,'Position');
%set(h1,'Position',[a(1)+.03 a(2)+.03 a(3) a(4)-.03]);

% plot it:
plot(x, y, 'k.', 'MarkerSize', 10);
drawnow

% put regression line
h = lsline;
set(h, 'LineWidth', 2);



% put text with corr label in the upper corner:
[r p] = corr(x, y);
corrString = ['r = ' sprintf('%2.2f',r)];

text(double(mean(xlim)),double(max(ylim)), corrString, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 16)
drawnow


% put labels on each point:
if doPointLabels
    fudge = .02;
    for i=1:length(x)
        xpos = x(i)+diff(xlims)*fudge;
        ypos = y(i); %+diff(ylims)*fudge;
        text(xpos, ypos, pointLabels{i}, 'FontSize', 12);
    end
end




