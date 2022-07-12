% nb this function should only take azimuthal mode ...
function [qq]=findAzimuthalModesMultWay(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr)
% [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags]=constants();
  [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir]=constants();

  [postAzimuthFft_noCsYet]=initData2("postAzimuthFft_noCsYet");


if aliasStr=="noAlias"
elseif aliasStr=="alias"
    % do fft for the first half of the circle, then copy the result ot the other half.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% begin azimuthal -> NEW and Needs a little changing (came after xcorr)
% Note: need to adjust aa= name etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%for timeBloc = 1:blocLength% time
timeBloc=1; % set htat temporarily.
    for t = 1:ntimesteps % time % parfor
        %for  r = 1:1079 % 1079 because of xcorr has 2x-1 entries..
        for  r = 1:540
            vec = zeros(1080,1);
            vec2 = zeros(1080,1);
            for zz=1:1080 % there are currently 1080 azimuthal modes.
                  % need to get data from fluctuation from qminusqbar, take fft azimuthally, then save to ....
                  %aa = qMinusQbar_noCsYet(t).circle(m).dat(r,1);
            % old aa=xcorrDone(t).circle(zz).dat(r); % this can perhaps be truncated to 540, then duplicated for the second half, too prevent aliasing.!
            aa=qMinusQbar_noCsYet(t).circle(zz).dat(r,1); % this can perhaps be truncated to 540, then duplicated for the second half, too prevent aliasing.!
            vec(zz)= aa;
            end % for zz
            aa=fft(vec);
            %bb = flip(aa);
            cc = zeros(1080,1);
            for i=1:540
              cc(i) =aa(i);
              cc(1080 - i + 1 ) = aa(i); % get all 1080
            end % i
            postAzimuthFft_noCsYet(t).circle(1,r).dat=cc;
        end % r...
    end % parfor t


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load in the correct qMinusqBar..
% Xcorr (new Placement, after azimuthal fft, but needs changing still (5-15-22...))
% nb, before, this was before everything; hence, the timeBloc is created here. So, move the timeBloc to new location..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%$%$   % Temporarily /comment out...:/ <- re-enabled.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear qMinusQbar_noCsYet; % yes, clear this..
%$%$    for timeBloc = 1:blocLength% time % disable; already declared above in fftAzimuth
        saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        load(saveStr,'qMinusQbar_noCsYet');
    ordStr="xcorrNow";
%    if ordStr=="xcorrNow" % remove that.
        %parfor t=1:ntimesteps% %
        sprintf('%s%f','$$ For xcorr, c is',currentCrossSec)

        %for t=1:ntimesteps% %
        %for r=1:540% % change the outermost loop to r, not t. innermost is t now
        for r=1:1080% % change the outermost loop to r, not t. innermost is t now

            %vec = zeros(1,540); % collect radial points..
            vec = zeros(1,ntimesteps); % collect radial points..
                for m=1:540
                for t=1:ntimesteps% %
                %for r=1:540% size xcorr
                  aa = postAzimuthFft_noCsYet(t).circle(m).dat(r,1);
                  vec(t) = aa;
                end % t
                %% bb should be size 2*ntimesteps - 1 .. ,, check that.
                  [bb, lags] = xcorr(vec,"normalized"); % bb is 1079 because of xcorr ! <- new annotat.
                  %sprintf('%s','check graph')
                  %for t=1:2*ntimesteps-1% % % add this sfor t-corr
                  for t=1:ntimesteps% % % add this sfor t-corr

                xcorrDone(t).circle(m).dat(r,1)=bb((ntimesteps+1)/2 + t); % only save half
                end % t
                end % m
        end % r
 wsaveStr=[saveDir 'xcorrDone[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
   save(saveStr,'xcorrDone','-v7.3');

% end % timeBloc % end timebloc here .. (updated order..) remove this timebloc.
%qq = postAzimuthFft_noCsYet; % asign qq and exi
qq = xcorrDone; % asign qq and exi
end % fc
