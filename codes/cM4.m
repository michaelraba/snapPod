%function qq=cM(collectTimeForCorrMatPreAvgOhneMC)
function cM4(c,m,tBloc,saveStrAdditive)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();
%saveDir2='/scratch/miraba2/fullRunJun29/'; % lcc
saveDir2='/home/mi/lccPostFft/'; % local
          % if tBloc~=1
            saveStrAdditive=[saveDir2 'res/collectTime[cs]' num2str(c) '[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'];
            tmp=myOp(saveStrAdditive);
            collectTimeForCorrMatPreAvgOhneMCadditive = tmp.collectTimeForCorrMatPreAvgOhneMCadditive;
           %elseif tBloc==1
           % yy=collectTimeForCorrMatPreAvgOhneMC
           % end % if
            saveStr=[saveDir2 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '[TimeBloc]' num2str(tBloc) '.mat'];
           %saveStr=[saveDir2 'xdirPostFft[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(ncs) '.mat'       ];
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
                for t=1:ntimesteps
                    aa = qq.xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
                    %collectTimeForCorrMatPreAvgOhneMC(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa; % for u
                    %collectTimeForCorrMatPreAvgOhneMCtemp(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa; % for u
                    collectTimeForCorrMatPreAvgOhneMCadditive(r).dat(ntimesteps*(tBloc - 1) + t,1)=aa  ;
                end %t
                %if tBloc==blocLength
                %    corrMatPreAvgOhneMC(r).dat=collectTimeForCorrMatPreAvgOhneMC(r).dat*ctranspose(collectTimeForCorrMatPreAvgOhneMC(r).dat);
                %end % if t
            end %r
           save(saveStrAdditive,'collectTimeForCorrMatPreAvgOhneMCadditive','-v7.3');

end % fc
