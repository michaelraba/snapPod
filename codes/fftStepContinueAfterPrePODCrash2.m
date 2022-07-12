 % this version factors m out around l112 to avoid crashes.
function [qq]=fftStepContinueAfterPrePODCrash2()
tic
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

 dr = 9.276438000000004e-04 + zeros(ss,1);
     [phiVec]=initData2("snapshotPhiVec");
     %[phiVecNormalized]=initData2("snapshotPhiVec");
     %[collectTimeForCorrMatPreAvg]=initData2("collectTime");
 rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked
  %if 1==1
    %[qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet"); % initialize avg struct
    %[qMinusQbar]=initData2("qMinusQbar"); % initialize avg struct
    %[myPreFft_noCsYet]=initData2("myPreFft_noCsYet");
    %[avgPreFft_noCsYet]=initData2("avgPreFft_noCsYet");
    %[xcorrDone]=initData2("azimuthDoneXcorrDone");
    %[qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet");
    %[xdirNew]=initData2("xdirNew");
    %[xdirPostFft]=initData2("xdirPostFft");
    %[avgTimeEnd]=initData2("avgTimeEnd");
    [corrMatRavgOhneM]=initData2("cmRaoM");
    [corrMatPreAvgOhneM]=initData2("cmPaoM");
    [collectTimeForCorrMatPreAvgOhneM]=initData2("ctfcmpaoM");

aMat = zeros(540,1);
% form corrmat before averginng in r
corrMat = zeros(ntimesteps*blocLength,ntimesteps*blocLength);

for m=1:azimuthalSetSize
for tBloc=1:blocLength
% open blocfile
saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
qq=open(saveStr);
xdirPostFft=qq.xdirPostFft;
for c=1:ncs % <- parfor
    sprintf('%s%s%s%s%s%s', 'tBloc', num2str(tBloc), 'Form Corrmat: c',num2str(c),'m',num2str(m))
for r=1:540
for t=1:ntimesteps
aa = xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
%collectTimeForCorrMatPreAvg(m).c(c).r(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa;
collectTimeForCorrMatPreAvgOhneM(c).r(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa;
end %t
if t==ntimesteps & tBloc==blocLength
%az=collectTimeForCorrMatPreAvg(m).c(c).r(r).dat;
az=collectTimeForCorrMatPreAvgOhneM(c).r(r).dat;

corrMatPreAvgOhneM(c).r(r).dat=az*ctranspose(az); % eq after smits.eq.2.4.
end % if t
end %r
%end %m
end %c
end %tB

%% r-average.
for timeBloc=1:blocLength
parfor c=1:ncs % <- parfor
%for m=1:azimuthalSetSize

for t=1:ntimesteps
for tPr=1:ntimesteps
aMat = zeros(ss,1);
for r=1:540
   %aa=corrMatPreAvg(m).c(c).r(r).dat(ntimesteps*(timeBloc-1)+t,ntimesteps*(timeBloc-1)+tPr);
   aa=corrMatPreAvgOhneM(c).r(r).dat(ntimesteps*(timeBloc-1)+t,ntimesteps*(timeBloc-1)+tPr);
   aMat(r) = rMat(r)*aa; % aa should be tt correlation
end % r
Rint = trapz(aMat);
%corrMatRavg(m).c(c).dat(t*tBloc,tPr*tBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
corrMatRavgOhneM(c).dat(t*tBloc,tPr*tBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
end % tPr (little)
end % t (little)
end % c % end parfor
end % timeBloc
        saveStr=[saveDir '/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[Azimuth]' num2str(m) '.mat'];
        %save(saveStr,'corrMatRavg','-v7.3');
        save(saveStr,'corrMatRavgOhneM','-v7.3');

for c=1:ncs % <- parfor
sprintf('%s%s%s%s','POD: c',num2str(c),'bloc', num2str(timeBloc))
%[phiVec(c).m(m).PODmode]=snapshotPod(m,c,corrMatRavgOhneM(c).dat,collectTimeForCorrMatPreAvgOhneM(c),phiVec,phiVecNormalized); % m c mode.
[phiVec(c).m(m).PODmode]=snapshotPod(m,c,corrMatRavgOhneM(c).dat,collectTimeForCorrMatPreAvgOhneM(c)); % m c mode.

end %c
end %m

        saveStr=[saveDir '/phiVec[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '.mat'];
        %save(saveStr,'corrMatRavg','-v7.3');
        save(saveStr,'phiVec','-v7.3');
        toc
end % fc

