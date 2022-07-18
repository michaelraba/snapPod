%function qq=cM(collectTimeForCorrMatPreAvgOhneMC)
function [collectTimeForCorrMatPreAvgOhneMCtemp]=cM3(c,m,tBloc,timeStep,collectTimeForCorrMatPreAvgOhneMCtemp)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
saveDir2='/scratch/miraba2/fullRunJun29/'; % lcc
saveDir2='/home/mi/lccPostFft/'; % local
            saveStr=[saveDir2 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'       ];
            qq=myOp(saveStr);
            %[collectTimeForCorrMatPreAvgOhneMCtemp]=initData2("ii1");

            %qq=open(saveStr);
            sprintf('%s%s%s%s%s%s', 'S[1]: tBloc', num2str(tBloc), 'Form Corrmat: c',num2str(c),'m',num2str(m))
            % mir jul15: this was oiriginally here:
            %[corrMatPreAvgOhneMC]=initData2("ii2");  % corrMatPreAvgOhneMC
            % bv needs to be initialized.
            %bv = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            %az = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
            %parfor r=1:ss %<-parfor
            for r=1:ss %<-parfor
                %for t=1:ntimesteps
                    aa = qq.xdirPostFft(timeStep).RadialCircle(r).azimuth(m).dat(c,1);
                    %collectTimeForCorrMatPreAvgOhneMC(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa; % for u
                    collectTimeForCorrMatPreAvgOhneMCtemp(r).dat =aa; % for u

                %end %t
                %if tBloc==blocLength
                %    corrMatPreAvgOhneMC(r).dat=collectTimeForCorrMatPreAvgOhneMC(r).dat*ctranspose(collectTimeForCorrMatPreAvgOhneMC(r).dat);
                %end % if t
            end %r
end % fc
