% Generate dummy data
a = 10; % your big number
b = 11; % another of your your big number
for i=1:a
    for j=1:b
        STRUCTA.A(i).B(j) = i*j + 1e-3*rand();
    end
end
% Undo the thing to getback numerical array
a = length(STRUCTA.A);
b = length(STRUCTA.A(1).B);
AB=reshape([STRUCTA.A.B],[b,a]); % deepest nested length first, ... 
% Simply work on the array, that how MATLAB should be used
% If you want to swap a/b dimension, transpose AB, no need for
% the ugly double for-loop as you do. 
val2 = fft(AB,[],2)