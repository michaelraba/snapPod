% chnages how data in post azimuthal is  saved

function findAzimuthalModes6(currentTime, currentCrossSec, qMinusQbar_noCsYet,corrMatSmits,aliasStr,radVec,dr,corrMethod)
  [ntimesteps, rMin, rMax, ss, ncs, plotOn, azimuthalSet ,azimuthalSetSize ,printStatus ,lags, blocLength, saveDir,csSet,timeSet]=constants();
  [postAzimuthFft_noCsYet]=initData2("postAzimuthFft_noCsYet");
  [savePostAzimuthFft_noCsYet]=initData2("savePostAzimuthFft_noCsYet");
  [uu]=initData2("uu");
if aliasStr=="noAlias"
elseif aliasStr=="alias"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% begin azimuthal ->
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

for timeBlocIt=1:blocLength

saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBlocIt) '.mat'       ];
qq=open(saveStr);
qMinusQbar_noCsYet = qq(1).qMinusQbar_noCsYet;

    for t = 1:ntimesteps % time % parfor
        for  r = 1:ss %
            vec = zeros(1080,1);
            vec2 = zeros(1080,1);
            for zz=1:1080 % \exists 1080 azimuthal modes.
            aa=qMinusQbar_noCsYet(t).circle(zz).dat(r,1); %
            vec(zz)= aa;
            end % for zz
            aa=fft(vec);
            %bb = flip(aa);
            cc = zeros(1080,1);
            for i=1:ss
              cc(i) =aa(i);
              cc(1080 - i + 1 ) = aa(i); % get all 1080
            end % i
            postAzimuthFft_noCsYet(t).circle(1,r).dat=cc; % there are indeed ss circles.
            for i=1:azimuthalSetSize  % save to file only the certain modes
              saveKey = azimuthalSet(i);
              dd(i) = cc(saveKey);
              % m, t
            savePostAzimuthFft_noCsYet(t).circle(r).dat=dd; % needs r..
            end %i
        end % r % radial
    end % parfor t
        % this is a particular cross section.
        saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBlocIt) '.mat'       ];
        %save(saveStr,'savePostAzimuthFft_noCsYet','-v7.3');
        save(saveStr,'postAzimuthFft_noCsYet','-v7.3');

end % blocLength
    
clear qMinusQbar_noCsYet; % yes, clear this..
%$%$    for timeBloc = 1:blocLength% time % disable; already declared above in fftAzimuth
        %saveStr=[saveDir 'qMinusQbar[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBlocIt) '.mat'       ];
       % load(saveStr,'qMinusQbar_noCsYet');
        sprintf('%s%f','$$ For xcorr, c is',currentCrossSec)
%$5$5$5$5$
if corrMethod=="directMult"

 for timeBloc=1:blocLength


  % this method cooks up a ntimestep by ntimestep matrix containing the
  % correlation coefficients via: Direct Multiplication.
  % This is a symmetric matrix and is found by multiplying u * u^H, then averaging over r
  % via numerical integration trapz(result * r,dr).
  % this is computed for each azimuthal mode m.
         for m=1:azimuthalSetSize % restrict to this set now.
         mmm = azimuthalSet(m);
            for iii=1:ntimesteps
            for jjj=1:ntimesteps
        % vec should hold each r for each ti tj
        vec = zeros(1,ss); % collect radial points..
        vecShowSymmetry= zeros(1,ss);
        dr = 1/ss + zeros(1,ss); % forms array of constants
        for r=1:ss% %
            aaa = postAzimuthFft_noCsYet(iii).circle(mmm).dat(r,1);
            bbb = ctranspose(postAzimuthFft_noCsYet(jjj).circle(mmm).dat(r,1));
            vec(r) = radVec(r)*aaa*bbb; % prepare to trapz that.
        end % r
        % this can be made a sum instead since dr is cte.
        ddd=trapz(vec,dr); % integrate over r. dr needs to be correct. dr = 1/ss. diff r_{i+1} - r_{i}
        ddE = trapz(vecShowSymmetry,dr);
        % we dont really need a matrix yet --- just the lag. but whatever.
        corrMatSmits(m).dat(iii,jjj) = ddd;
        corrMatSmitsSymmetry(m).dat(iii,jjj) = ddE;
            end % jjj
            end % iii 
                end % m
 saveStr=[saveDir 'corrMatSmits[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
   save(saveStr,'corrMatSmits','-v7.3');
   qq = corrMatSmits; % asign qq and exit

 end % timebloc

elseif corrMethod=="corrCoef"
     
    
 for timeBlocIt=1:blocLength
        %uu(m).dat = zeros(ntimesteps*blocLength,1);
        %vv(m).dat = zeros(ntimesteps*blocLength,1);
        saveStr=[saveDir 'postAzimuth[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
        qq= open(saveStr);
        postAzimuthFft_noCsYet = qq.postAzimuthFft_noCsYet;


  for m=1:azimuthalSetSize % restrict to this set now.
         mmm = azimuthalSet(m);
        for r=1:ss% %
   
        for tt=1:ntimesteps
          uu(m).dat(tt * timeBlocIt) = postAzimuthFft_noCsYet(tt).circle(mmm).dat(r,1);
          sprintf('%s%f','m,r',m)
        end % tt
    end % r
         ay = xcorr(uu(m).dat,uu(m).dat,"normalized"); % this is t,t' correlation     
         corrCoefStore(r).dat = ay(ceil(end/2):end); % this is t,t' correlation
         end % m

 end %%%%% adding timebloc end here! 
hold on;
plot(real(corrCoefStore(r).dat))
pause(0.05)



elseif corrMethod=="none"
qq=postAzimuthFft_noCsYet; % whatever just empty.
end % if direct mult


end
%        for tt=1:ntimesteps
%          rVV = zeros(ss,1);
%        for r=1:ss% %
%           rVV(r) = radVec(r) * corrCoefStore(r).dat(tt);
%        end % r % avergae in r
%         %intResult=trapz(rVV,dr);
%         intResult=sum(rVV);
%
%        integratedCorr(m).dat(tt) = intResult ;
%        end % tt
%         %m=2;
%        for ii=1:ntimesteps
%        for jj=1:ntimesteps
%          if jj>= ii
%              diffNb = jj - ii;
%          corrMatSmits(m).dat(ii,jj) = integratedCorr(m).dat(  jj - ii + 1    );
%          else
%              diffNb = ii - jj;
%          corrMatSmits(m).dat(ii,jj) = integratedCorr(m).dat(  ii - jj + 1  );
%          end % if
%        end % jj
%        end % i
%                end % m
%   saveStr=[saveDir 'corrMatSmits[Case]C' num2str(ncs) 'T' num2str(ntimesteps) '[crossSec]' num2str(currentCrossSec) '[TimeBloc]' num2str(timeBloc) '.mat'       ];
%   save(saveStr,'corrMatSmits','-v7.3');
%                qq = corrMatSmits;
%
%         end % if
   end % fc
