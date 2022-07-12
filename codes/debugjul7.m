  function debugjul7() %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
  %[ntimesteps ,~ ,~, ~ ,ncs ,~ ,~, azimuthalSetSize ,printStatus, ~]=constants();
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();

corrMatRavgOhneMC = zeros(ntimesteps*blocLength,ntimesteps*blocLength);
        for timeBloc=1:blocLength
            for t=1:ntimesteps % <- parfor
                tempRow = zeros(1,ntimesteps*blocLength);
                for tPr=1:ntimesteps
                    aMat = zeros(ss,1);
                    for r=1:ss
                        aa=corrMatPreAvgOhneMC(r).dat(ntimesteps*(timeBloc-1)+t,ntimesteps*(timeBloc-1)+tPr);
                        aMat(r) = rMat(r)*aa; % aa should be tt correlation
                    end % r
                    Rint = trapz(aMat);
                    tempRow(1,tPr*timeBloc)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
                end % tPr (little)
                %corrMatRavgOhneMC(t,:) = tempRow ; 
            end % t (little)
        end % timeBloc
        %saveStr=[saveDir '/corrMatRavg[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[Azimuth]' num2str(m) '.mat'];

        sprintf('%s%s%s%s','POD: c',num2str(c),'bloc', num2str(timeBloc))

  end