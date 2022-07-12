function strTest3()
% Gen data
a = 3; % 
b = 5; % 
c = 7; % 
for i=1:a
    for j=1:b
        for k=1:c
        %STRUCTA.A(i).B(j) = i*j;
        STRUCTA.A(i).B(j).C(k) = i*j*k;
        end
    end
end
% Undo
a = length(STRUCTA.A);
b = length(STRUCTA.A(1).B);
c = length(STRUCTA.A(1).B(1).C); 

%AB=reshape([STRUCTA.A.B],[b,a]); % this works

AB = [STRUCTA.A.B];
ABC = reshape([AB.C],[c b a]);

%ABC=reshape([STRUCTA.A.B.C],[c,b,a]); % this produces error 

val2 = fft(ABC,[],2)
end