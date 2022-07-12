 function [qq]=fftStepSmits(stepStr,preStr)
[ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();
  %[xcorrDoneAnticipate_cs]=initData2("xcorrDoneAnticipate_cs");
%ntimestepsX = 2*ntimesteps - 1; % number of offsets with xcorr.
% dont use.ntimestepsX = 2*ntimesteps - 1; % number of offsets with xcorr.
corrMethod="none";
%corrMethod="corrCoef"; % corrCoef or directMult
  if stepStr=="readDataAndFindVeloFluctuation"
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet"); % initialize avg struct
    [qMinusQbar]=initData2("qMinusQbar"); % initialize avg struct
    [myPreFft_noCsYet]=initData2("myPreFft_noCsYet");
    [avgPreFft_noCsYet]=initData2("avgPreFft_noCsYet");
    [xcorrDone]=initData2("azimuthDoneXcorrDone");
    [qMinusQbar_noCsYet]=initData2("qMinusQbar_noCsYet");
    [xdirNew]=initData2("xdirNew");
    [smitsXdir]=initData2("smitsXdir");
    [corrMatFuckYeah]=initData2("corrMatFuckYeah");
    [azimWithCs]=initData2("azimWithCs");
    [corrMatSmits]=initData2("corrMatSmits_noCs");
    [uXfft]=initData2("uXfft");
    [xdirPostFft]=initData2("xdirPostFft");
    [avgTimeEnd]=initData2("avgTimeEnd");
    radLength = 0.5;
    dr = 9.276438000000004e-04 + zeros(ss,1);
    rMat=0:dr:.50001; % [0, ...,0.5] with 540 elements %  needs checked
    for c = 1:ncs  % crosssection
    
    %% Step A) load a chonk into memory and read circles in.
    for timeBloc=1:blocLength
    parfor t = 1:ntimesteps % time % <-- nb, this is the parfor loop.
    myPreFft_noCsNoTimeYet=readCircles2(timeBloc*t,c);
    myPreFft_noCsYet(t).circle=myPreFft_noCsNoTimeYet;
    %sprintf('%s','pause')
    end % parfor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    parfor t = 1:ntimesteps % time % parfor
% load in time bloc again
        myPreFft_noCsNoTimeYet=readCircles2(timeSet(t),csSet(c));
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
    end % timeblock

    findAzimuthalModes6(t, c, qMinusQbar_noCsYet,corrMatSmits,"alias",rMat,dr,corrMethod);
    sprintf('%s','start azimuthal')
    end %c % yes, cross-section loop should indeed end here..
        end % if
for currentCrossSec=1:ncs % ? parfor?
%saveStr=[saveDir 'corrMatSmits[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];

qq=open(saveStr);
sprintf('%s','start azimuthal')
% now re-organize:
% almost essential, that t,t' just be an array instead of a matrix, for reorg that.
% okay save to reference array that nts x nts case, but then
% also save to array the vectorized form.

for m=1:azimuthalSetSize
   %myArray = reshape(qq.corrMatSmits(m).dat,[],1); % that creates a hard copy, inefficient.
   myArray = reshape(qq.postAzimuthFft_noCsYet(m).dat,[],1); % that creates a hard copy, inefficient.

for t=1:ntimesteps*ntimesteps %parfor % then operate on myArray
   sprintf('%s','hi')
  smitsXdir(m).t(t).dat(currentCrossSec,1) = myArray(t);
end % m
%end % r
end % t (little)
sprintf('%s%d%s%d%s','done filling in a crosssec for timeBloc=', timeBloc, ' and t=',t,'.')
end % c

for t1=1:ntimesteps % parfor
for t2=1:ntimesteps % parfor
for m=1:azimuthalSetSize
for cc=1:ncs
    tsWalkThroughArray = (t1-1)*ntimesteps + t2 ;
  aa = smitsXdir(m).t(tsWalkThroughArray).dat;
  ab = fft(aa);
  corrMatFuckYeah(m).x(cc).dat(t1,t2) = ab(cc,1);
  %hold on;
  %plot(real(ab));
  %pause(0.1)
end % xx
end % m
end % t (little)
end % t (little)

        sprintf('%s','saving final corrmat...')
        saveStr=[saveDir 'corrMatFuckYeah[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        save(saveStr,'corrMatFuckYeah','-v7.3');
        sprintf('%s%s','Saved xdirpostfft into file ',saveStr);
%%%%% % Time Averaging <- no!
%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%% aMat = zeros(ss,1);
%%%%% for t=1:ntimesteps
%%%%% for c=1:ncs
%%%%% for m=1:azimuthalSetSize
%%%%% for r=1:ss
%%%%%    aa = xdirPostFft(t).RadialCircle(r).azimuth(m).dat(c,1);
%%%%%    aMat(r) = r*aa;
%%%%%    %aMat(r) = (1-r)*aa; % because its flipped (-> at: ).. (maybe dont flip if feel uncomfortable with that).
%%%%%    %smits2016(t).cs(c).circle(m).dat(r,1) = r*aa; % R(t,t';k;m,r) and mult by r.
%%%%% end % r
%%%%% Rint = trapz(aMat);
%%%%% Rmat_avg(t).cs(c).circle(m)= Rint; % smits17.eq.below.eq.2.4 % needs checking.
%%%%%
%%%%% end % m
%%%%% end % c
%%%%% end % t (little)
%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%% %%%end % timeBloc
%%%%%
%%%%% % set back in radial direction and time avergae for all timesteps!

        %saveStr=[saveDir '/Ravg_r[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '.mat'];
        saveStr=[saveDir '/corrMatFuckYeah[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(c) '.mat'];
        save(saveStr,'corrMatFuckYeah','-v7.3');

% average in r smits2016

%   smits2016(t).cs(c).circle(m).dat(r,1) = aa; % R(t,t';k;m,r)
% just call trapz. then operate on t -> eig wrt .

%%%%% OPEN saveAzimuth[Case]etc, and take azimuthal fft.
%%%%%
for currentCrossSec=1:ncs
  % needs to open for each crossection and timeBloc. Reorganize. Take fft. Then save for each ((timebloc Only)).
saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'];
azimWithCs(currentCrossSec)=open(saveStr); % this should be different crosssection...
% azimWithCs(3).t(4).rad(ss).dat  
% qz.savePostAzimuthFft_noCsYet(4).circle(6).dat  
end

for timeBlocIt=1:blocLength
for t=1:ntimesteps
%postAzimuthFft_noCsYet = qq.savePostAzimuthFft_noCsYet;
for m=1:azimuthalSetSize
for r=1:ss
      tempCsVec = zeros(ncs,1);
for currentCrossSec=1:ncs
    % postAzimuthFft_noCsYet(4).circle(ss).dat  
  tempCsVec(currentCrossSec) = azimWithCs(currentCrossSec).savePostAzimuthFft_noCsYet(t).circle(r).dat(m);
  end % cc
  % take fft:
  fftVecc = fft(tempCsVec);
% then save this to uXfft, the last field should be like t (definitely).
  for currentCrossSec=1:ncs
      % nb this really ought to be in the x-direction. 
    uXfft(m).cs(currentCrossSec).rad(r).dat(t,1) = fftVecc(currentCrossSec);
  end % cc
  end % r
% save each time or timebloc
  end % m
end % t % error here.
% * toDo: save to file  uXfft for each timebloc.
end % current crosssection
saveStr= [saveDir '/uForPod[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '.mat']
save(saveStr,'uXfft','-v7.3');


pod(uXfft);
%%elseif typeStr=="corrCoef"
    % if its different ... would it be??? Yes, a little bit.
%%end
 end % f
