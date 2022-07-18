function [qq]=initData2(initStr) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
  %[ntimesteps ,~ ,~, ~ ,ncs ,~ ,~, azimuthalSetSize ,printStatus, ~]=constants();
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();

Ncs= [ncs,1];
Nts= [ntimesteps,1];
Naz = [azimuthalSetSize,1]; % azimuthal
Nps=[540,1];
  if printStatus=="on" 
    %sprintf('%s%s', '* Initializing ', initStr)
  end
if initStr=="myPreFftDrawCircle" %redo
qq=struct('t', repmat({struct('circle', repmat({  struct('dat',repmat({zeros(3,1080)}, Nps))}, Nts)) }, Ncs));
elseif initStr=="myPreFft" %redo
qq=struct('t', repmat({struct('circle', repmat({  struct('dat',repmat({zeros(1,1080)}, Nps))}, Nts)) }, Ncs));
elseif initStr=="myPreFft_noTimeYet" %redo
qq=struct('dat', repmat({zeros(1,1080)}, [1,540]));
elseif initStr=="myPreFft_noCsYet" %redo
qq=struct('circle', repmat({struct('dat',repmat({zeros(1,1080)}, [1,540]))} , [1,ntimesteps]));
elseif initStr=="postAzimuthFft_noCsYet" %redo
qq=struct('circle', repmat({struct('dat',repmat({zeros(1,1080)}, [1,540]))} , [1,ntimesteps]));
elseif initStr=="uXfft" %redo
% m k r t % save to minimize t and r, which are the largest parameters. t should be last -> operates on t.
qq=struct('cs', repmat({struct('rad', repmat({  struct('dat',repmat({zeros(ntimesteps,1)}, [540,1]))}, [ncs,1])) }, [azimuthalSetSize,1]));


elseif initStr=="savePostAzimuthFft_noCsYet" %redo
  % m,t,r
%qq=struct('circle', repmat({struct('dat',repmat({zeros(540,1)}, [ntimesteps,1]))} , [azimuthalSetSize,1]));
qq=struct('circle', repmat({struct('dat',repmat({zeros(azimuthalSetSize,1)}, [540,1]))} , [ntimesteps,1]));
elseif initStr=="azimWithCs" %redo
% m k r t % save to minimize t and r, which are the largest parameters. t should be last -> operates on t.
qq=struct('savePostAzimuthFft_noCsYet', repmat({struct('circle', repmat({  struct('dat',repmat({zeros(azimuthalSetSize,1)}, [540,1]))}, [ntimesteps,1])) }, [ncs,1]));


elseif initStr=="azimuthDoneXcorrDone" % for findAzimuthalModes with *if ordStr="xcorrNow"*
qq=struct('circle', repmat({struct('dat',repmat({zeros(1080,1)}, [1,1080]))} , [1,ntimesteps]));
elseif initStr=="azimuthDoneXcorrDoneAnticipate_cs" % for findAzimuthalModes with *if ordStr="xcorrNow"*
%qq=struct('radial', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,100)}, [1,azimuthalSetSize]))}, [1,1079])) }, Nts));
qq=struct('azimuth', repmat({struct('radial', repmat({  struct('dat',repmat({zeros(1,100)}, [1,1079]))}, [1,azimuthalSetSize])) }, Nts));
%azimuthDoneXcorrDoneAnticipate_cs


elseif initStr=="uu" % used in m6
qq=struct('dat', repmat({zeros(1,ntimesteps*blocLength)}, [1,azimuthalSetSize]));
elseif initStr=="corrMatSmits"
qq=struct('x', repmat({struct('dat',repmat({zeros(ntimesteps,ntimesteps)}, [ncs,1]))} , [azimuthalSetSize,1]));


elseif initStr=="corrMatSmits_noCs" %redo
qq=struct('dat', repmat({zeros(ntimesteps,ntimesteps)}, [azimuthalSetSize,1]));


elseif initStr=="xdirNew"
  %qq=struct('RadialCircle', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(ncs,1)}, Naz))}, [1,1079])) }, Nts));
  qq=struct('RadialCircle', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(ncs,1)}, Naz))}, [1,540])) }, Nts));

elseif initStr=="xdirPostFft"
%qq=struct('RadialCircle', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(ncs,1)}, Naz))}, [1,1079])) }, Nts));
qq=struct('RadialCircle', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(ncs,1)}, Naz))}, [1,540])) }, Nts));

elseif initStr=="avgTimeEnd" %redo
qq=struct('circle', repmat({struct('dat',repmat({zeros(1079,1)}, [1,azimuthalSetSize]))} , [1,ncs]));


elseif initStr=="smitsXdir" %redo
%qq=struct('circle', repmat({struct('dat',repmat({zeros(ncs,1)}, [ntimesteps*2,1]))} , [azimuthalSetSize,1]));
qq=struct('t', repmat({struct('dat',repmat({zeros(ncs,1)}, [ntimesteps*ntimesteps,1]))} , [azimuthalSetSize,1]));

elseif initStr=="corrMatFuckYeah" %redo
%qq=struct('circle', repmat({struct('dat',repmat({zeros(ncs,1)}, [ntimesteps*2,1]))} , [azimuthalSetSize,1]));
qq=struct('x', repmat({struct('dat',repmat({zeros(ntimesteps,ntimesteps)}, [ncs,1]))} , [azimuthalSetSize,1]));

elseif initStr=="myPreFft_noCsNoTimeYet" %redo
qq=struct('dat', repmat({zeros(1,1080)}, [540,1]));

elseif initStr=="avgPreFft" %redo
%qq=struct('circle', repmat({struct('dat',repmat({zeros(540,1)}, [1,1080]))} , [1,ncs]));
qq=struct('circle', repmat({struct('dat',repmat({zeros(540,1)}, [1080,1]))} , [1,ncs]));

elseif initStr=="avgPreFft_noCsYet" %redo
  qq=struct('dat',repmat({zeros(540,1)}, [1080,1]));
elseif initStr=="qMinusQbar"
qq=struct('t', repmat({struct('circle', repmat({  struct('dat',repmat({zeros(1,1080)}, Nps))}, Nts)) }, Ncs));

elseif initStr=="qMinusQbar_noCsYet"
qq=struct('circle', repmat({struct('dat',repmat({zeros(540,1)}, [1080,1]))} , [1,ntimesteps]));
  %qq=struct('dat',repmat({zeros(1,1080)}, [1,540]));
elseif initStr=="rmsU"
qq=struct('t', repmat({struct('dat',repmat({zeros(540,1)}, [ntimesteps*blocLength,1]))} , [azimuthalSetSize,1]));
elseif initStr=="thVecM" %redo
  qq=struct('dat',repmat({zeros(ntimesteps*blocLength,1)}, [azimuthalSetSize,1]));
elseif initStr=="rmsVecM" %redo
  qq=struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]));
elseif initStr=="rmsVecCM" %redo
  %qq=struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]));
  qq=struct('m', repmat({struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]))} , [ncs,1]));

elseif initStr=="qMinusQbar_noCsNoTimeYet" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  qq=struct('dat',repmat({zeros(540,1)}, [1080,1]));

elseif initStr=="cmRaoM" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ncs,1]));
elseif initStr=="pvfmM" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  qq=struct('dat',repmat({zeros(ss,1)}, [3,1]));

elseif initStr=="ii2" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));


elseif initStr=="ii1" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  %qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));
  qq=struct('dat',repmat({zeros(ntimesteps*blocLength,1)}, [ss,1]));

elseif initStr=="ii1t" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  %qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));
  qq=struct('dat',repmat({zeros(ntimesteps,1)}, [ss,1]));

elseif initStr=="ii1_additiveRead" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  %qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));
  qq=struct('dat',repmat({zeros(ntimesteps*blocLength,1)}, [ss,1]));
elseif initStr=="RavStack" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  qq=struct('dat',repmat({zeros(ntimesteps,ntimesteps*blocLength)}, [blocLength,1]));


elseif initStr=="ii1t2" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  %qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));
  %qq=struct('dat',repmat({zeros(ntimesteps,1)}, [ss,1]));
  qq=struct('r', repmat({struct('dat',repmat({zeros(ntimesteps,1)}, [ss,1]))} , [blocLength,1]));


elseif initStr=="ii1b" % for truncating out the time when we feed eahc itme step to the azimuth fucnciton.
  %qq=struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]));
  qq=struct('dat',repmat({zeros(ntimesteps*(blocLength+1),1)}, [ss,1]));


elseif initStr=="cAplot" %redo
  %qq=struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]));
  qq=struct('p', repmat({struct('dat',repmat({zeros(ss,1)}, [3,1]))} , [azimuthalSetSize,1]));


elseif initStr=="cmPaoM" %redo
  %qq=struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]));
  qq=struct('r', repmat({struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]))} , [ncs,1]));

elseif initStr=="ctfcmpaoM" %redo
  %qq=struct('dat',repmat({zeros(540,1)}, [azimuthalSetSize,1]));
  qq=struct('r', repmat({struct('dat',repmat({zeros(ntimesteps*blocLength,ntimesteps*blocLength)}, [ss,1]))} , [ncs,1]));



elseif initStr=="radialXcorrStruct" % redo
qq=struct('crossSec', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,540)}, Naz))}, Ncs)) }, Nts));
elseif initStr=="XcorrData"
%%%%%    XcorrData(t).crossSec(c).azimuth(m).dat = zeros(1,1080);
qq=struct('crossSec', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,1080)}, Naz))}, Ncs)) }, Nts));
elseif initStr=="XcorrDonePreCsFft"
qq=struct('radial', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,ncs)}, Naz))}, [1,1080])) }, Nts));
elseif initStr=="XcorrDonePostCsFft"
qq=struct('radial', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,ncs)}, Naz))}, [1,1080])) }, Nts));
elseif initStr=="XcorrDoneCsFftDonePreAzimFft"
qq=struct('radial', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,azimuthalSetSize)}, Ncs))}, [1,1080])) }, Nts));
elseif initStr=="XcorrDoneCsFftDonePostAzimFft"
qq=struct('crossSec', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,azimuthalSetSize)}, Ncs))}, [1,1080])) }, Nts));
elseif initStr=="XcorrAzimDonePreTimeAvg"
qq=struct('radial', repmat({struct('crosssection', repmat({  struct('dat',repmat({zeros(1,ntimesteps)}, Ncs))}, [1,1080])) }, Naz));
elseif initStr=="XcorrAzimDonePostTimeAvg"
qq=struct('radial', repmat({struct('crosssection', repmat({  struct('dat',repmat({zeros(1,ntimesteps)}, Ncs))}, [1,1080])) }, Naz));
elseif initStr=="Skmr"
qq=struct('radial', repmat({struct('crosssection', repmat({  struct('dat',repmat({zeros(1,ntimesteps)}, Ncs))}, [1,1])) }, Naz));
elseif initStr=="streamwiseFft"
qq=struct('RadialCircle', repmat({struct('azimuth', repmat({  struct('dat',repmat({zeros(1,540)}, Naz))}, [1,540])) }, Nts));
elseif initStr=="SrrPrForFourierPre"
qq=struct('t', repmat({struct('azimuthal', repmat({  struct('dat',repmat({zeros(1,540)}, Naz))}, Nts)) }, Ncs));
elseif initStr=="SrrPrForFourierPost"
qq=struct('t', repmat({struct('azimuthal', repmat({  struct('dat',repmat({zeros(1,540)}, Naz))}, Nts)) }, Ncs));

elseif initStr=="collectTime"
qq=struct('t', repmat({struct('azimuthal', repmat({  struct('dat',repmat({zeros(ntimesteps*blocLength,1)}, [540,1]))}, ncs)) }, [azimuthalSetSize,1]));


elseif initStr=="snapshotPhiVec"
%qq=struct('c', repmat({struct('m', repmat({  struct('dat',repmat({zeros(1,540)}, [azimuthalSetSize,1]))}, [ncs,1])) }, [3,1])); % stores 3 pod modes
% reorganize:
%qq=struct('m', repmat({struct('PODmode', repmat({  struct('dat',repmat({zeros(540,1)}, [3,1]))}, [azimuthalSetSize,1])) }, [ncs,1])); % stores 3 pod modes
qq=struct('m', repmat({struct('PODmode', repmat({  struct('dat',repmat({zeros(1,540)}, [3,1]))}, Naz)) }, Ncs));

end %if

end %fc
