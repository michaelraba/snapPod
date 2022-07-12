%central limit theorem says that, in certain conditions
%the mean of 'sufficiently large number of independent random variables'
%each with finite mean and variance will be approximated to gaussian or
%normal distribution
function centralLimitTheoremForLowestMode(currentTime, currentCrossSec, qMinusQbar_noCsYet,xcorrDone,aliasStr,currentBloc)

figure(4);
nz=1e5 % change this for finer x axis.
nTyp=1e2
  nStr=struct('dat',repmat({zeros(1,nz)}, [nTyp,1]));

for nt=1:nTyp
    %nStr(nt).dat = rand(1,nz);
    nStr(nt).dat = randi(1000,1,nz);

end

avVe = zeros(1,nz);
figure(4);
for nt=1:nTyp
  avVe = avVe + nStr(nt).dat ;
  % if mod(nt,100)==0
  histogram(avVe/nt)
  %pause(0.006)
  pause(0.6)

  title('hi')
   %end
end
avVe = avVe/nTyp;

%n1=rand(1,nz);
%n2=rand(1,nz);
%n3=rand(1,nz);
%n4=rand(1,nz);
%n5=rand(1,nz);
%n6=rand(1,nz);
%n7=rand(1,nz);
%n8=rand(1,nz);
%n9=rand(1,nz);
%n10=rand(1,nz);
%n=(n1+n2+n3+n4+n5+n6+n7+n8+n9+n10)/10;
%bar(hist(n));
%bar(hist(avVe));
histogram(avVe)
%%%Central limit theorem applied to uniformly distributed random variables
%%%% the bar graph shows a normal distribution or gaussian distribution

sprintf('%s',"operation finished.")
end
