% reads x,y coordinates of snapshot's crosssection and plots that.
function readXY(ww) % redo for parfor loop.
                                                         % % does not take such a big struct.
[ntimesteps, rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags]=constants();
%[M_mat]=initData2("myPreFft_noTimeYet");
  Bavg = zeros(ss,rMax+1);
  tic
      %sprintf('%s%d%s%d','*t = ',t,'**c=',c)
      M_mat = zeros(540,540); % streamwiseData

    %  cc = sprintf( '%03d', c  ) ;
     % tt = sprintf( '%04d', t  ) ;

      daPath = '/home/mi/citriniPodCode/codes/';
      fileName = [ daPath  'snapWithXYonly.dat']; % t starts at 0.
      formatSpec = '%f';
      a=fopen(fileName, 'r');
      importedData = fscanf(a,formatSpec);
      zz = size(importedData); zz = zz(1);

      myXy = zeros(zz/2,2);



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
    xlim([-.1 1]);
    ylim([-1 1]);
      %f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')
      f=figure('Renderer', 'painters', 'Position', [10 10 900 900],'Visible','on')

      hold on;
for mm=1:1080 % each angle.
   %for ii=1:540
   %  a=coors(1).m(mm).dat(ii);
   %  b=coors(2).m(mm).dat(ii);
   %  hold on;
   %  plot(a,b,'MarkerSize',2);
   %  hold on;
   %  %pause(0.3);
   %end % ii

     a=coors(1).m(mm).dat;
     b=coors(2).m(mm).dat;
     hold on;
     plot(a,b,'MarkerSize',2);
     hold on;
     pause(0.003);

end % mm


      for r=1:rMax  % r is azimuthal mode
        %sprintf('%s%d%s%d','*r = ',r);
      for p=1:540 % p is point
        pointOnLine_r = p + 540*r;
        x_vec=importedData(pointOnLine_r,1); % 5 for streamwise entry of the data matrix % 1 for 1 col
        y_vec=importedData(pointOnLine_r,2);
      end %p
      end %r
%&---------------------------------------------------------------------
      for p=1:540 % p is point

        myPreFft_noTimeYet(p).dat =    M_mat(:,p)';

      end %p
end % fc
