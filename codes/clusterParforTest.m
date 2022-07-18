function cc = clusterParforTest()
cluster = parcluster;
%cluster = c;

values = [3 3 3 7 3 3 3];
parfor (i=1:numel(values),cluster)
    out(i) = norm(pinv(rand(values(i)*1e3)));
end
cc = 'hi'
end % fc