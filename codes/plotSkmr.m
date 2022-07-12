% for snapshot pod
function plotSkmr(plotObject,isGraph)
[ntimesteps rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags,csSet,timeSet]=constants();
if isGraph=="graph"
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=1;
  A=linspace(0,1,ss)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')  
  hold on;
  for c=1:cMaxx
      subplot(cMaxx,1,1);

      %for t=1:ntimesteps
      for m=4:azimuthalSetSize
      
      labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      pp=plot(A,real(plotObject(c).m(m).dat/ntimesteps),"DisplayName",labelStr);
      tiSt=['Streamwise mode: ' num2str(c)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      if c==1
      legend();
      end
      hold on;
      end % m
      cou = cou + 1;
  end %c
elseif isGraph=="graphPause"
  hold on;
    for m=2:38
    for c=1:ncs
    plot(real(plotObject(m).crosssection(c).dat(end/2:end) )/ntimesteps)
    hold on;
    pause(1);
    end
    end
    %sprintf('%s','pause');
      pause(1)
%else
%end % if
  titleStrr=['Snapshot POD modes $\Phi_{ii}(k,m;r)$ for (tTot,xTot)=(' num2str(ntimesteps) ',' num2str(ncs) ') Uniformly Sampled']
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')
  xlabel('1-r','interpreter','latex')

elseif isGraph=="avg" % plot the avg of the cross sections
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=2;
  A=linspace(0,1,ss)
  %A=linspace(0,1,1079)
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$S_{ii}(k,m;r,r')$",'interpreter','latex')
  hold on;
  cou = 1


for podModeNumber=1:3
    for m=1:azimuthalSetSize
      % initialize with each azimuthal mode.
        avgPlotting(m).dat = zeros(1,540);
    for c=1:ncs
      avgPlotting(m).dat = plotObject(podModeNumber).c(c).m(m).dat + avgPlotting(m).dat;
    end % c
    end % m
          %subplot(cMaxx,1,cou);
          subplot(3,1,podModeNumber);
          for m=1:azimuthalSetSize
          labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
          xlabel('1-r','interpreter','latex')

          pp=plot(A,flip(real(avgPlotting(m).dat/(ntimesteps*ncs))),"DisplayName",labelStr);
          tiSt=['$\Phi^{(' num2str(podModeNumber) ')}_{ii}(k,m;r)$'];
          title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
          if podModeNumber==1
          legend();
          end
          hold on;
          end % m
          cou = cou + 1;
    %  end %c

end % podModeNumber
  titleStrr=['Snapshot POD modes for (tTot,xTot)=(' num2str(ntimesteps) ',' num2str(ncs) ') Uniformly Sampled']
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')

elseif isGraph=="c3"
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])
  cMaxx=1;
  A=linspace(0,1,ss);
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$POD mode of S_{ii}(k,m;r,r')$",'interpreter','latex')  
  hold on;
  for c=1:1
     for PODmode=1:3
      for rs=0:1
      subplot(3,2,(PODmode - 1)*2 + 1 + rs  )
      hold on;
      %for t=1:ntimesteps
      for m=2:azimuthalSetSize
      %%phiVec(1).m(5).PODmode(1).dat  

      if rs==0
                labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      pp=plot(A,real(plotObject(1).m(m).PODmode(PODmode).dat),"DisplayName",labelStr);
            tiSt=['POD mode: ' num2str(PODmode)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      elseif rs==1
                labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
          aa = real(plotObject(1).m(m).PODmode(PODmode).dat(:));
          bb = imag(plotObject(1).m(m).PODmode(PODmode).dat(:));
          cc = (aa(:) + bb(:))*0.5;
          pp=plot(A,cc,"DisplayName",labelStr);
                tiSt=['re(Re+Im)/2 POD mode: ' num2str(PODmode)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      end % if 


      if PODmode==1 && rs==0
      legend();
      end
      hold on;
      end % m
     % cou = cou + 1;
      end % rs

     end % pod mode
  end %c

  elseif isGraph=="c4"
  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')
  cMaxx=1;
  A=linspace(0,1,ss);
  xlabel('radius $\frac{r}{R}$','interpreter','latex')
  ylabel("$POD mode of S_{ii}(k,m;r,r')$",'interpreter','latex')  
  hold on;

% averaging
%
[cAplot]=initData2("cAplot");

  %%qq.phiVec(99).m(5).PODmode(3).dat
for m=1:azimuthalSetSize
for podM=1:3

avC = zeros(ss,1);
for c=1:99
  %qq.phiVec(13).m(4).PODmode(2).dat
  avC = avC + plotObject(c).m(m).PODmode(podM).dat;
end % c
cAplot(m).p(podM).dat = avC ;
end
end

  
  for c=1:1
     for PODmode=1:3
      for rs=0:1
      subplot(3,2,(PODmode - 1)*2 + 1 + rs  )
      hold on;
      %for t=1:ntimesteps
      for m=2:azimuthalSetSize
      %%phiVec(1).m(5).PODmode(1).dat  

      if rs==0
                labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
      pp=plot(A,real(cAplot(m).p(PODmode).dat),"DisplayName",labelStr);
            tiSt=['POD mode: ' num2str(PODmode)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      elseif rs==1
                labelStr = ['(m,k)=(', num2str(azimuthalSet(m)),',',num2str(c),')'];
          %cAplot(5).p(3).dat
          aa = real(cAplot(m).p(PODmode).dat(:));
          bb = imag(cAplot(m).p(PODmode).dat(:));
          cc = (aa(:) + bb(:))*0.5;
          pp=plot(A,cc,"DisplayName",labelStr);
                tiSt=['re(Re+Im)/2 POD mode: ' num2str(PODmode)  ];
      title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
      end % if 


      if PODmode==1 && rs==0
      legend();
      end
      hold on;
      end % m
     % cou = cou + 1;
      end % rs

     end % pod mode
  end %c
end % if 

end % f
