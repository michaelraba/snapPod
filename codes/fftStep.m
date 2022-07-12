 function [qq]=fftStep(stepStr,preStr)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

 dr = 9.276438000000004e-04 + zeros(ss,1);
     [phiVec]=initData2("snapshotPhiVec");
     [phiVecNormalized]=initData2("snapshotPhiVec");


 rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked
  if stepStr=="readDataAndFindVeloFluctuation"
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet"); % initialize avg struct
    [qMinusQbar]=initData2("qMinusQbar"); % initialize avg struct
    [myPreFft_noCsYet]=initData2("myPreFft_noCsYet");
    [avgPreFft_noCsYet]=initData2("avgPreFft_noCsYet");
    [xcorrDone]=initData2("azimuthDoneXcorrDone");
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet");
    [xdirNew]=initData2("xdirNew");
    [xdirPostFft]=initData2("xdirPostFft");
    [avgTimeEnd]=initData2("avgTimeEnd");



    for c = 1:ncs  % crosssection
    %% Step A) load a chonk into memory and read circles in.
    for timeBloc=1:blocLength
    parfor t = 1:ntimesteps % time % <-- nb, this is the parfor loop.
    myPreFft_noCsNoTimeYet=readCircles2(timeBloc*t,c);
    myPreFft_noCsYet(t).circle=myPreFft_noCsNoTimeYet;
    sprintf('%s','pause')
    end % parfor
    % after each block is done, find the average
    for t = 1:ntimesteps % time % <-- nb, this is the parfor loop.
      if timeBloc==blocLength && t==ntimesteps
        lastStr="last";
      else
        lastStr="notLast";
      end
    [avgPreFft_noCsYet]=findQbar(t,c,myPreFft_noCsYet,avgPreFft_noCsYet,lastStr); % find temporal average.
    end % end little t
    end % timeBloc

    for timeBloc=1:blocLength
    for t = 1:ntimesteps % time % parfor
% load in time bloc again
        myPreFft_noCsNoTimeYet=readCircles2(timeBloc*t,c);
        myPreFft_noCsYet(t).circle=myPreFft_noCsNoTimeYet;
        % for each loaded timebloc, find qMinusQbar..
        [ qMinusQbar_noCsYet(t) ]=FindqMinusQbar(t,c,myPreFft_noCsYet(t),avgPreFft_noCsYet,qMinusQbar_noCsYet(t),"efficient");
    end % parfor t
    % this should be saved to disk immediately, for each timeBloc...
        sprintf('%s','saving qMinusQbar...')
        saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        save(saveStr,'qMinusQbar_noCsYet','-v7.3');
        sprintf('%s%s','Saved velocity fluctuations into file ',saveStr);

    qq = qMinusQbar_noCsYet(t);
    findAzimuthalModes4(t,c, qMinusQbar_noCsYet,xcorrDone,"alias",timeBloc)
    end % timeblock
    sprintf('%s','start azimuthal')
    %qq = xcorrDone;
    end %c % yes, cross-section loop should indeed end here..
        %elseif stepStr=="azimuth"
        end % if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x-dir fft
% read in one of the saved xcorrDone
for timeBloc=1:blocLength
for currentCrossSec=1:ncs
saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
qq=open(saveStr);
sprintf('%s','start azimuthal')
% now re-organize:
for t=1:ntimesteps %parfor
for r=1:540 % 
    azimCounter=1;
for m=1:azimuthalSetSize
  %aa=qq.xcorrDone(t).circle(m).dat(r,1); % that creates a hard copy, inefficient.
  aa=qq.postAzimuthFft_noCsYet(t).circle(r).dat(m,1); % that creates a hard copy, inefficient.
%qq.postAzimuthFft_noCsYet(4).circle(540).dat(1080)  
  xdirNew(t).RadialCircle(r).azimuth(azimCounter).dat(currentCrossSec,1) = aa;
  azimCounter=azimCounter+1;
end % m
end % r
end % t (little)
sprintf('%s%d%s%d%s','done filling in a crosssec for timeBloc=', timeBloc, ' and t=',t,'.')
end % c
% begin fft x-dir
for t=1:ntimesteps % parfor
for r=1:540 % this should be 540..................
for m=1:azimuthalSetSize
  aa = xdirNew(t).RadialCircle(r).azimuth(m).dat;
  %ab = fft(aa(end/2:end));
  ab = fft(aa);
  xdirPostFft(t).RadialCircle(r).azimuth(m).dat = ab;
end % m
end % r
end % t (little)
        sprintf('%s','saving xdirPostFft...')
        saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        save(saveStr,'xdirPostFft','-v7.3'); % save this ito something else such as cs or az.
        sprintf('%s%s','Saved xdirpostfft into file ',saveStr);
% radial averaging
%%
end % timebloc 

aMat = zeros(540,1);

% form corrmat before averginng in r 
corrMat = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
for tBloc=1:blocLength
% open blocfile
sprintf('%s%s%s%s','Form Corrmat: c',num2str(c),'m',num2str(m))
saveStr=[saveDir 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
qq=open(saveStr);
xdirPostFft=qq.xdirPostFft;
for c=1:ncs
for m=1:azimuthalSetSize
for r=1:540
for t=1:ntimesteps
aa = xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
collectTimeForCorrMatPreAvg(m).c(c).r(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa;
end %t
if t==ntimesteps & tBloc==blocLength
az=collectTimeForCorrMatPreAvg(m).c(c).r(r).dat;
corrMatPreAvg(m).c(c).r(r).dat=az*ctranspose(az);
end % if t 
end %r
end %m
end %c
end %tB

%% r-average.
for timeBloc=1:blocLength
for c=1:ncs
for m=1:azimuthalSetSize

for t=1:ntimesteps
for tPr=1:ntimesteps

for r=1:540
   %aa = xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
   aa=corrMatPreAvg(m).c(c).r(r).dat(ntimesteps*(timeBloc-1)+t,ntimesteps*(timeBloc-1)+tPr);
   aMat(r) = rMat(r)*aa; % aa should be tt correlation
end % r
Rint = trapz(aMat);
%Rmat_avg(t).cs(c).circle(m)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
corrMatRavg(m).c(c).dat(t*tBloc,tPr*tBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
end % tPr (little)
end % t (little)
%% end % timeBloc
        saveStr=[saveDir '/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '.mat'];
        save(saveStr,'corrMatRavg','-v7.3');
qq = xdirPostFft;
[phiVec,phiVecNormalized]=snapshotPod(m,c,corrMatRavg(m).c(c).dat,collectTimeForCorrMatPreAvg(m).c(c),phiVec,phiVecNormalized); % m c mode.
end %m
end %c
 end % bloc
 end %fc
