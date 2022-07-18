% this version factors m, and factor out c -> out around l112 to avoid crashes.
%function [qq]=fftStepContinueAfterPrePODCrash3()
function xx=playAround2()
%clear all;
tic
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

saveDir2=saveDir
%saveDir2='/miraba2/scratch/fullRunJun29/'



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
[qq.xdirPostFft]=initData2("xdirPostFft");
%[avgTimeEnd]=initData2("avgTimeEnd");
%[corrMatRavgOhneM]=initData2("cmRaoM");
%[corrMatPreAvgOhneM]=initData2("cmPaoM");
%[collectTimeForCorrMatPreAvgOhneM]=initData2("ctfcmpaoM");


%[corrMatRavgOhneMC]=initData2("ii3");

aMat = zeros(ss,1);
corrMat = zeros(ntimesteps*blocLength,ntimesteps*blocLength);

%for m=1:azimuthalSetSize
for m=1:3
cSize=1 ; % this is the one need to change. dont make too big. then cc is its multiplier.
sprintf('%s%d','*****S[0]: m=',m) 
for c=1:cSize % parfor works here for lcc and lcoal. %for c=1:cSize %for c=(cc-1)*(cSize ) + 1 : (cc-1)*(cSize ) + cSize  % <-parfor %for c=1:cSize % corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength); [collectTimeForCorrMatPreAvgOhneMC]=initData2("ii1"); [collectTimeForCorrMatPreAvgOhneMC_temp]=initData2("ii1t2"); % mir: jul 15 this was orig initialized in body of parfor loop.
       [corrMatPreAvgOhneMC]=initData2("ii2");  % corrMatPreAvgOhneMC
        %% Task1a : Prepare correlation 
        [collectTimeForCorrMatPreAvgOhneMCadditive]=initData2("ii1_additiveRead");

        saveDir2='/home/mi/lccPostFft/'; % local
        saveStrAdditive=[saveDir2 'res/collectTime[cs]' num2str(c) '[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'       ];
        save(saveStrAdditive,'collectTimeForCorrMatPreAvgOhneMCadditive','-v7.3');

        
        parfor tBloc=1:blocLength % <- want to parfor here but need to refactor >..jul15. 
        saveStr=[saveDir2 '/res/collectTime[Case]C' num2str(ncs) 'T' num2str(ntimesteps) 'BS' num2str(blocLength) 'blocNum' num2str(tBloc) '.mat'];
           sprintf('%s%d%','S[22], tBloc=',tBloc)
        cM4(c,m,tBloc,saveStr) % collect time for corrmat by reading files

        end %tB
%% Task 1a compute actual correlation: 
% * load in full tBloc*ntimestep data file first 
saveStrAdditive=[saveDir2 'res/collectTime[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
tmp=open(saveStrAdditive);
collectTimeForCorrMatPreAvgOhneMCadditive = tmp.collectTimeForCorrMatPreAvgOhneMCadditive;
for r=1:ss
corrMatPreAvgOhneMC(r).dat=collectTimeForCorrMatPreAvgOhneMCadditive(r).dat*ctranspose(collectTimeForCorrMatPreAvgOhneMCadditive(r).dat);
end % r
 % save corrmat for each c.
 saveStrAdditive=[saveDir2 'res/corrMat[cs]' num2str(c) '[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
 save(saveStrAdditive,'corrMatPreAvgOhneMC','-v7.3');
 end %c
% end %m    
% end %fc

%% Task 2: r-Averaging
for c=1:cSize %
 saveStrAdditive=[saveDir2 'res/corrMat[cs]' num2str(c) '[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
 tmp=open(saveStrAdditive);
 corrMatPreAvgOhneMC=tmp.corrMatPreAvgOhneMC ;
         %corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
         corrMatRavgOhneMC = zeros(ntimesteps,ntimesteps*blocLength);
         [corrMatPreAvgOhneMCStack]=initData2("RavStack");  % corrMatPreAvgOhneMC

         %% find average in r-direction. smits2016.eq.2.5.after. This seems really slow with triple loop;.
         parfor timeBloc=1:blocLength
         corrMatRavgOhneMC = zeros(ntimesteps,ntimesteps*blocLength);

         corrMatRavgOhneMC=rAv2(timeBloc, corrMatPreAvgOhneMC,corrMatRavgOhneMC)
         corrMatPreAvgOhneMCStack(timeBloc).dat = corrMatRavgOhneMC;
         end % timeBloc
%% Task 2b: 
corrMatRavgOhneMC_long = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
% organize into single matrix..
for timeBloc=1:blocLength
  tRangeA=(timeBloc-1)*ntimesteps;
  tRangeB=(timeBloc)*ntimesteps;
  %corrMatRavgOhneMC_long(timeBloc,:) =corrMatPreAvgOhneMCStack(timeBloc).dat ;
  tRangeAa = tRangeA+1;
  corrMatRavgOhneMC_long(tRangeAa:tRangeB,:)=corrMatPreAvgOhneMCStack(timeBloc).dat
end % tBloc
         
         saveStr=[saveDir 'res/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[Azimuth]' num2str(m) '.mat'];

         %sprintf('%s%s%s%s','POD: c',num2str(c),'bloc', num2str(timeBloc))
         %[phiVec(c).m(m).PODmode]=snapshotPodCrash3(m,c,corrMatRavgOhneMC,collectTimeForCorrMatPreAvgOhneMC); % m c mode.
 %% Task 3 A and B       
         [phiVec(c).m(m).PODmode]=snapshotPodCrash3(m,c,corrMatRavgOhneMC,collectTimeForCorrMatPreAvgOhneMCadditive); % m c mode.

     end %c
 end %m
%end % fc <- take out if needed.
 saveStr=[saveDir2 '/res/phiVec[Case]C' num2str(ncs) 'T' num2str(ntimesteps) 'BS' num2str(blocLength) 'cSize' num2str(cSize) '.mat'];
 save(saveStr,'phiVec','-v7.3');
% toc
% %phiVec(1).m(5).PODmode(1).dat  
xx= 1
 end % fc
