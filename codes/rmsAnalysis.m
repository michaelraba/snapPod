% no timeblocing. see v2 of this script for blocs.
function rmsAnalysis(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)

[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
f=figure('Renderer', 'painters', 'Position', [10 10 1900 900])


%for tBloc=1:blocLength
for tBloc=1:1
% open blocfile

for c=1:ncs
 %subplot(9,11,c);
 subplot(1,2,c);


saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
qq=open(saveStr);
%xdirPostFft=qq.xdirPostFft;

    sprintf('%s','hi')
    for mz=1:1:18
        sprintf('%s%s%s%s','Form Corrmat: c',num2str(c),'m',num2str(mz))

    uu=zeros(ss,1);
    nts=ntimesteps
    %for tt=1:ntimesteps
    for tt=1:nts
    for sz=1:ss
       %uu = qMinusQbar_noCsYet(tt).circle(mz).dat(sz)  ;
      %qq.xdirPostFft(8).RadialCircle(12).azimuth(17).dat
       uu = qq.xdirPostFft(tt).RadialCircle(sz).azimuth(mz).dat(c);
       uuuz(tt).dat(sz) = uu*uu;
    end  % sz
    end % tt
    
    rmsVec = zeros(ss,1);
    for sp=1:ss
    tVecc=zeros(nts,1);
    for ts=1:nts
        thVec(ts) = uuuz(ts).dat(sp);
    end
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
    end % mz 
     titleStrr=["Reynolds Shear Stress at $u'u'$ in Streamwise Direction for at particular azimuthal angle for different  $c\in[1,99]$."]
  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')




%%for m=1:azimuthalSetSize
%%for r=1:540
%%for t=1:ntimesteps
%%
%%
%%end % t
%%end % r
%%end % m
sprintf('%s%f%s%f' , 'c,m', num2str(c),', ', num2str(tBloc))

end % c
end % tBloc


end % fc
