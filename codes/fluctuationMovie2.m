function fluctuationMovie2(currentTime, currentCrossSec, qMinusQbar_noCsYet,corrMatSmits,aliasStr,radVec,dr,corrMethod)
  [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();

  f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','off')

  currentCrossSec = 1;
  %timeBlocIt=1;

  %for tb=1:blocLength
  for tb=1:blocLength
      sprintf('%s%d','current timebloc sei', tb)
  %for tb=1:1
%parfor tt=1:ntimesteps
parfor tt=1:ntimesteps % blocsize
saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(tb) '.mat'       ];
qq=open(saveStr);
%subplot(6,3,m)
      %for m=1:azimuthalSetSize
      for m=1:1
% qq.qMinusQbar_noCsYet(t:1:timeBlocSize).circle(4).dat
mm = azimuthalSet(m);
    labelStr = ['azimuthal angle=' num2str(azimuthalSet(m)) '.']
%%plot(qq.qMinusQbar_noCsYet(tt).circle(mm).dat  )
%%     tiSt=['$\theta(m)$=' num2str(mm) ];
%%          title(tiSt, 'FontName','capitana','FontSize',12,'interpreter','latex')
  end % m
  tComb = (tb -1)*ntimesteps + tt;
      readXY_v2( qq.qMinusQbar_noCsYet(tt).circle , tComb, currentCrossSec, "gnuPlot") ;
%%  tVal = sprintf('%03d',((tb-1)*ntimesteps + tt));
%%  titleStrr=['Raw Velo Fluctuation at crossSec c=' num2str(currentCrossSec) 'at t=' tVal];
%%  sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex');
%%  svSt=['/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/movieJun23VeloFluctuationCs1/' 'cs55t' tVal '.png' ]
%%  saveas(gcf,svSt)
end % tt
  end % tb

end
