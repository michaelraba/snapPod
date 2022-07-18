function xx=checkFileExist()

[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

%saveDir='/home/mi/lccPostFft/'; % this only works locally. cant use for lcc
for m=1:1
cSize=1 ; % this is the one need to change. dont make too big. then cc is its multiplier.
sprintf('%s%d','*****S[0]: m=',m)
%parfor c=1:30 % parfor works here for lcc and lcoal.
for c=1:cSize
%for c=(cc-1)*(cSize ) + 1 : (cc-1)*(cSize ) + cSize  % <-parfor
%for c=1:cSize
               % corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            [collectTimeForCorrMatPreAvgOhneMC]=initData2("ii1");

        %% form corrMat from doubly fourier transformed velo fluctuations
        for tBloc=1:blocLength
            % open blocfile
            saveDir2='/scratch/miraba2/fullRunJun29/' % lcc
            %saveDir2='/home/mi/lccPostFft/' % local

            saveStr=[saveDir2 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
           qq=open(saveStr);        
%xx=isfile(fullfile(saveStr))
xx=qq.xdirPostFft(1).RadialCircle(1).azimuth(1).dat(1)
        end
end
end
