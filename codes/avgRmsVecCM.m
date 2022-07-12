% v3 *has* timeblocing *and parallel*. however needs debugging bec the graph is not correct.
function avgRmsVecCM(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
f=figure('Renderer', 'painters', 'Position', [10 10 1900 900],'Visible','on')
%[uuMTS]=initData2("rmsU");
[rmsVecAvg]=initData2("rmsVecM");

qq=open('/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/rmsVecCM.mat')
sprintf('%s','working..')

 dr = 9.276438000000004e-04 + zeros(ss,1);
 rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked

%qq.rmsVecCM(99).m(18).dat
for m=2:18
sprintf('%s%d%s' , 'Reading Data: m=',m,'.')
  avgVec=zeros(540,1);
  for c=1:18
    avgVec = avgVec + qq.rmsVecCM(c).m(m).dat ;
  end %c
  %avgVec = flip(1.1e-7*avgVec);
  %avgVec = 1.1e-7*avgVec;
  avgVec = flip(avgVec);

  wtVec = zeros(540,1);
  for rr=1:ss
      val = avgVec(rr);
      %res=rMat(rr)*val*val;
      %res=rr*val*val;
      res=rr*val;


      wtVec(rr)=res;
  end 
  wtNum = trapz(wtVec);
  %wtNum = trapz(wtVec,dr);

  %rmsVecAvg(m).dat = avgVec;
  %rmsVecAvg(m).dat = wtVec;
  %if wtNum>1e-5
  avgVec = flip(avgVec/wtNum);
  %end 

    labelStr = ['m=' num2str(azimuthalSet(m)) '.']
    hold on
    if m==2
    plot(flip(avgVec) ,'b--' , 'LineWidth' , 2  ,"DisplayName", labelStr)
    else
            plot(flip(avgVec)  ,"DisplayName", labelStr)
    end
    legend();
    titleStrr=['Streamwise Reynolds Stress $rms(uu)$ for Azimuthal modes $m\in[' num2str(azimuthalSet(2)) ',' num2str(azimuthalSet(azimuthalSetSize)) ']$ for Ensemle-averaged Streamwise Modes $k$, $N_t \in [0,999], N_c \in[0,99]$.']
    sgtitle(titleStrr,'FontName','capitana','FontSize',12,'interpreter','latex')

  end %m

end %fc
