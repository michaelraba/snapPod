clear all;
n = 2; 
%s(n) = struct();
for ii = 1:n
    for jj = 1:n
        s(ii).a(jj) = rand();%this is just building the original struct
    end
end

%s(n) = struct();
for ii = 1:n
    for jj = 1:n
        for kk = 1:n
        ss(ii).a(jj).b(kk) = rand();%this is just building the original struct
        end
    end
end

%s(n) = struct();
for ii = 1:n
    for jj = 1:n
        for kk = 1:n
              for ll = 1:n
        sz(ii).a(jj).b(kk).c(ll) = rand();%this is just building the original struct
              end
        end
    end
end

tic
for ii = 1:n
    for jj = 1:n
        val = s(ii).a(jj);
        s2(jj).a(ii) = val;% do the loop like you have
    end
end
toc


tic
tmp = cell2mat(squeeze(struct2cell(s))).';
tmp2=mat2cell(tmp,ones(1,n),[n]);
s3 = cell2struct(tmp2,fieldnames(s),4);
toc




%%
tic
tmo = cell2mat(squeeze(squeeze((struct2cell(ss))))).';
tmp2=mat2cell(tmo,ones(1,n),[n]);
ss3 = cell2struct(tmp2,fieldnames(s),4);  % 4 does not seem to matter.
toc

tic
tmz = cell2mat(squeeze(struct2cell(sz))).';
tmz2=mat2cell(tmz,ones(1,n),[n]);
sz3 = cell2struct(tmz2,fieldnames(s),4);  % 4 does not seem to matter.
toc



tic
tmp = cell2mat(squeeze(struct2cell(s))).';
tmp2=mat2cell(tmp,ones(1,n),[n]);
s3 = cell2struct(tmp2,fieldnames(s),4);  % 4 does not seem to matter.
toc


% and let's do a loop to ensure s2 and s3 are the same
s_diff = zeros(n);
for ii = 1:n
    for jj = 1:n
        s_diff(ii,jj) = s2(ii).a(jj)-s3(ii).a(jj);
    end
end
if max(abs(s_diff(:)))==0
    disp('success') %I got success
else
    disp('failure')
end