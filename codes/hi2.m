function hi2()
%opts=parforOptions(c);
%parfor (idx = 1:3,opts)
%parfor (idx = 1:3,opts)
%    fstr=['/home/miraba2/mTest/m' num2str(idx) '.txt']
%    fd=fopen(fstr,'w')
%    fprintf(fd,'%s%d','File was written by',idx)
%    %sprintf('%s%d','my current proc is',idx)
%    fclose(fd)
%end
gg='hi'
fst='/home/miraba2/mTest/ee.txt';
fi=fopen(fst,'w');
fprintf(fi,'%s%d','num nodes is:',gg);
fclose(fi);
end % fc
