%function lcc()
clear;clc

allNames = parallel.clusterProfiles()
%parallel.defaultClusterProfile(allNames{1});
parallel.defaultClusterProfile(allNames{1});

rehash toolbox
configCluster
%/usr/local/MATLAB/R2019
c=parcluster;

% how specify 'LCC R2019a' cluster profile?
c.AdditionalProperties.WallTime = '0:20:0';
%c.AdditionalProperties.QueueName = 'CAC48M192_L';
c.AdditionalProperties.QueueName = 'SKY32M192_L';


c.AdditionalProperties.AccountName = 'col_cbr285_uksr';
%https://www.hpc.iastate.edu/guides/using-matlab-parallel-server nodes
c.AdditionalProperties.NumNodes = 2;
c.AdditionalProperties.ProcsPerNode = 20; 
c.AdditionalProperties.NumWorkers = 40;
%c.AdditionalProperties.EmailAddress='miraba2@uky.edu'
%c.AdditionalProperties.AccountName = 'col_vgazu2_uksr';
c.saveProfile
c.AdditionalProperties
%c.AdditionalSubmitArgs = '-N 18 -n 200'
%end

