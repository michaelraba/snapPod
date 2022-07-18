function corrMatPreAvgOhneMC=rAv(timeBloc, corrMatPreAvgOhneMC)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();


dr = 9.276438000000004e-04 + zeros(ss,1);
rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked

             %%%% make into function!
             for t=1:ntimesteps % <- parfor % eg rows.
                 sprintf('%s%d%s%d','S[3], tB: ',timeBloc,',ts: ',t )
                 tempRow = zeros(1,ntimesteps);
                 %parfor tPr=1:ntimesteps*blocLength % <- orig was parfor
                 for tPr=1:ntimesteps*blocLength % <- orig was parfor

                     aMat = zeros(ss,1);
                     corrMatR = zeros(ntimesteps,ntimesteps);
                     for r=1:ss
                         corrMatR = corrMatPreAvgOhneMC(r).dat;
                         aa=corrMatR(ntimesteps*(timeBloc-1)+t,tPr);

                         %aa=corrMatPreAvgOhneMC(r).dat(ntimesteps*(timeBloc-1)+t,tPr);

                         aMat(r) = rMat(r)*aa; % aa should be tt correlation
                     end % r
                     Rint = trapz(aMat);
                     %tempRow(1,tPr*timeBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
                     tempRow(1,tPr)= Rint; % smits17.eq.below.eq.2.4 % needs checking.

                 end % tPr (little)
                 corrMatRavgOhneMC(ntimesteps*(timeBloc-1)+t,:) = tempRow ;
                 %tS(tBloc).dat(t,:) = tempRow ;

             end % t (little)
end % function % timeBloc







%end
