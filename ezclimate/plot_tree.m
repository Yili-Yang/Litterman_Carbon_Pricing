function hFigure = plot_lattice(A)

  %# Compute all the coordinates needed for the lines and points:

  N = size(A,1);
  [xPoints,yPoints] = meshgrid(0:N-1);
  yPoints = bsxfun(@plus,-yPoints,0:0.5:(N-0.5)/2);
  xLines = [xPoints([1:N+1:N^2-N-1 1:N:N^2-2*N+1]); ...
            xPoints([1:N-1 N:-1:2],N).'];  %'
  yLines = [yPoints([1:N+1:N^2-N-1 1:N:N^2-2*N+1]); ...
            yPoints([1:N-1 N:-1:2],N).'];  %'
  index = find(triu(reshape(1:N^2,N,N)));
  xPoints = xPoints(index);
  yPoints = yPoints(index);
  values = strtrim(cellstr(num2str(A(index))));

  %# Create the figure:

  hFigure = figure('Color','w');
  hAxes = axes('Parent',hFigure,'XLim',[-0.5 N-0.5],...
               'YLim',[min(yPoints)-0.5 max(yPoints)+0.5],...
               'YColor','w','XTick',0:N-1,'LineWidth',2);
  hold on;
  plot(hAxes,xLines,yLines,'k','LineWidth',2);
  plot(hAxes,xPoints,yPoints,'o','MarkerFaceColor',[0.96 0.96 0.86],...
       'MarkerSize',30,'MarkerEdgeColor','k','LineWidth',2);
  text(xPoints,yPoints,values,'Parent',hAxes,...
       'HorizontalAlignment','center');
  hold off;

end