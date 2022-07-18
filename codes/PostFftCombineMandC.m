% this version does parallel m and loops to optimize processors. 
%function [qq]=fftStepContinueAfterPrePODCrash3()
function xx=PostFftCombineMandC()
%clear all;
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
[qq.xdirPostFft]=initData2("xdirPostFft");
%[avgTimeEnd]=initData2("avgTimeEnd");
%[corrMatRavgOhneM]=initData2("cmRaoM");
%[corrMatPreAvgOhneM]=initData2("cmPaoM");
%[collectTimeForCorrMatPreAvgOhneM]=initData2("ctfcmpaoM");

 saveDir2='/scratch/miraba2/fullRunJun29/' % lcc
 %saveDir2='/home/mi/lccPostFft/' % local

%[corrMatRavgOhneMC]=initData2("ii3");

aMat = zeros(ss,1);
corrMat = zeros(ntimesteps*blocLength,ntimesteps*blocLength);

%for m=1:azimuthalSetSize
for m=1:2
cSize=9 ; % this is the one need to change. dont make too big. then cc is its multiplier.
sprintf('%s%d','*****S[0]: m=',m)
for c=1:3 % parfor works here for lcc and lcoal.
%for c=1:cSize
%for c=(cc-1)*(cSize ) + 1 : (cc-1)*(cSize ) + cSize  % <-parfor
%for c=1:cSize
               % corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            [collectTimeForCorrMatPreAvgOhneMC]=initData2("ii1");

        %% form corrMat from doubly fourier transformed velo fluctuations
        for tBloc=1:blocLength
            % open blocfile

           
            saveStr=[saveDir2 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
            qq=myOp(saveStr);
            %qq=open(saveStr);
            sprintf('%s%s%s%s%s%s', 'S[1]: tBloc', num2str(tBloc), 'Form Corrmat: c',num2str(c),'m',num2str(m))
            [corrMatPreAvgOhneMC]=initData2("ii2");  % corrMatPreAvgOhneMC
            % bv needs to be initialized.
            %bv = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            %az = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            %parfor r=1:ss %<-parfor
            parfor r=1:ss %<-parfor
                for t=1:ntimesteps
                    aa = qq.xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
                    collectTimeForCorrMatPreAvgOhneMC(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa; % for u
                end %t
                if tBloc==blocLength           
                    corrMatPreAvgOhneMC(r).dat=collectTimeForCorrMatPreAvgOhneMC(r).dat*ctranspose(collectTimeForCorrMatPreAvgOhneMC(r).dat);
                end % if t
            end %r
        end %tB

% end %c
% end %m
% end %fc

         %% find average in r-direction. smits2016.eq.2.5.after. This seems really slow with triple loop;.
         corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
         for timeBloc=1:blocLength
             parfor t=1:ntimesteps % <- parfor % eg rows.
                 tempRow = zeros(1,ntimesteps);
                 %parfor tPr=1:ntimesteps*blocLength % <- orig was parfor
                 for tPr=1:ntimesteps*blocLength % <- orig was parfor

                     aMat = zeros(ss,1);
                     for r=1:ss
                         %aa=corrMatPreAvgOhneMC(r).dat(ntimesteps*(timeBloc-1)+t,ntimesteps*(timeBloc-1)+tPr);
                         aa=corrMatPreAvgOhneMC(r).dat(ntimesteps*(timeBloc-1)+t,tPr);

                         aMat(r) = rMat(r)*aa; % aa should be tt correlation
                     end % r
                     Rint = trapz(aMat);
                     %tempRow(1,tPr*timeBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
                     tempRow(1,tPr)= Rint; % smits17.eq.below.eq.2.4 % needs checking.

                 end % tPr (little)
                 corrMatRavgOhneMC(ntimesteps*(timeBloc-1)+t,:) = tempRow ;
                 %tS(tBloc).dat(t,:) = tempRow ;

             end % t (little)
         end % timeBloc
         saveStr=[saveDir 'res/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[Azimuth]' num2str(m) '.mat'];

         sprintf('%s%s%s%s','[2] POD: c',num2str(c),'bloc', num2str(timeBloc))
         [phiVec(c).m(m).PODmode]=snapshotPodCrash3(m,c,corrMatRavgOhneMC,collectTimeForCorrMatPreAvgOhneMC); % m c mode.

     end %c
 end %m
%end % fc <- take out if needed.
 saveStr=[saveDir2 '/res/phiVec[Case]C' num2str(ncs) 'T' num2str(ntimesteps) 'BS' num2str(blocLength) 'cSize' num2str(cSize) '.mat'];
 save(saveStr,'phiVec','-v7.3');
% toc
% %phiVec(1).m(5).PODmode(1).dat  
 sprintf('%s','[3] fertig:')

xx= 1
 end % fc
