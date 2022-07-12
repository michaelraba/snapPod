% reads x,y coordinates of snapshot's crosssection and plots that.
function readXY_v2(ww,tt , cs, isPlot) % redo for parfor loop.
[ntimesteps, rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags]=constants();
      daPath = '/home/mi/citriniPodCode/codes/';
      fileName = [ daPath  'snapWithXYonly.dat']; % t starts at 0.
      formatSpec = '%f';
      a=fopen(fileName, 'r');
      importedData = fscanf(a,formatSpec);
      zz = size(importedData); zz = zz(1);
      for mm=1:1080 % each angle.
      x_vec = zeros(1,540); % streamwiseData
      y_vec = zeros(1,540); % streamwiseData
      xCounter=1;
      yCounter=1;
      for ii=1:540*2
      if mod(ii,2) == 0
        y_vec(yCounter) = importedData(ii + 2*540*(mm-1));
        yCounter = yCounter + 1;
      elseif mod(ii,2) ~= 0
        x_vec(xCounter) = importedData(ii + 2*540*(mm-1));
        xCounter = xCounter + 1;
        end % if
      end % for ii
      % 1 =x , 2 =y;
      coors(1).m(mm).dat = x_vec;
      coors(2).m(mm).dat = y_vec;
end % mm
%plot

if isPlot == "on"
    xlim([-.1 1]);
    ylim([-1 1]);
      f=figure('Renderer', 'painters', 'Position', [10 10 900 900],'Visible','on')
      hold on;
for mm=1:1080 % each angle.
     a=coors(1).m(mm).dat;
     b=coors(2).m(mm).dat;
     hold on;
     plot(a,b,'MarkerSize',2);
     hold on;
     pause(0.003);
end % mm

elseif isPlot=="gnuPlot"
  gnuP = ['/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/fluctuationContourPlotJun24/VeloFlux_at_crossSec' num2str(cs) '/'];
   tz = sprintf('%s%d%s%04d','VeloFluc_cs',cs, '_ts',tt);
  opStr = [gnuP tz '.dat']
    fileID = fopen(opStr,'w');
% write to file...for reading in gnuplot.
for mm=1:1080 % each angle.
%for mm=1:1 % each angle.
  for pp=1:540
  %for pp=1:10
     a=coors(1).m(mm).dat(pp);
     b=coors(2).m(mm).dat(pp);
     c=ww(mm).dat(pp);
     %z=0;
     fprintf(fileID,'%f %f %f  \n',a,b,c);
     %fprintf(fileID,'%f \n',c);

     end %pp
end % mm
fclose(fileID);

end % if isPlot. 

end % fc
