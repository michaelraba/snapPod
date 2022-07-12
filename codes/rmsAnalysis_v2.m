% v2 *has* timeblocing. however needs debugging bec the graph is not correct.
function rmsAnalysis_v2(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')

%for tBloc=1:blocLength
blocLength=1;
for c=1:ncs
for mz=1:1:18
%% load data.
%subplot(9,11,c);
for tBloc=1:blocLength
sprintf('%s%d%s%d%s%d' , 'Reading Data: c=',c,', tBloc=', tBloc, ', mz=',mz)

saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
qq=open(saveStr);
%xdirPostFft=qq.xdirPostFft;
    uu=zeros(ss,1);
    nts=ntimesteps
    %for tt=1:ntimesteps
    for tt=1:nts
    for sz=1:ss
       %uu = qMinusQbar_noCsYet(tt).circle(mz).dat(sz)  ;
      %qq.xdirPostFft(8).RadialCircle(12).azimuth(17).dat
       uu = qq.xdirPostFft(tt).RadialCircle(sz).azimuth(mz).dat(c);
       uuuz(tt + (tBloc-1)*ntimesteps).dat(sz) = uu*uu;
    end  % sz
    end % tt
  end % tBloc
 
%% process data.
    rmsVec = zeros(ss,1);
    for sp=1:ss
    thVec=zeros(nts*blocLength,1);
    for tBloc=1:blocLength   
    for ts=1:nts*blocLength
        thVec(ts) = uuuz(ts).dat(sp);
    end %ts
    end % bloc
    
    daRoot = rms(thVec);
    rmsVec(sp) = daRoot;
    end %sp
    labelStr = ['Azimuthal Angle ' num2str(mz) '*2 Pi/180']
    hold on
    plot(flip(rmsVec),"DisplayName", labelStr)
     tiSt=['c=' num2str(c) ];
          title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
    if c==1
    legend();
    end % if
    end % mz now.
     titleStrr=["Reynolds Shear Stress at $u'u'$ in Streamwise Direction for at particular azimuthal angle for different streamwise modes $k\in[1,99]$."]
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')
  sprintf('%s%f%s%f' , 'c,m', num2str(c),', ', num2str(tBloc))

end % c
end % fc



