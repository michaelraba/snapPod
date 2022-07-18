%function lcc()
clear;clc

allNames = parallel.clusterProfiles()
%parallel.defaultClusterProfile(allNames{1});
%.defaultClusterProfile(allNames{1});

rehash toolbox
configCluster
%/usr/local/MATLAB/R2019
c=parcluster;

% how specify 'LCC R2019a' cluster profile?
c.AdditionalProperties.WallTime = '24:20:0';
c.AdditionalProperties.QueueName = 'CAC48M192_L';
%c.AdditionalProperties.QueueName = 'SKY32M192_L';


c.AdditionalProperties.AccountName = 'col_cbr285_uksr';
%https://www.hpc.iastate.edu/guides/using-matlab-parallel-server nodes
% c.AdditionalProperties.NumNodes = 2;  % this config works with regular
% parfor loops.
% c.AdditionalProperties.ProcsPerNode = 20; 
% c.AdditionalProperties.NumWorkers = 40;

nn = 1;
pp = 48;
c.AdditionalProperties.NumNodes = nn;
c.AdditionalProperties.ProcsPerNode = pp; 
c.AdditionalProperties.NumWorkers = pp*nn;
%c.AdditionalProperties.EmailAddress='miraba2@uky.edu'
c.saveProfile
%% matlab suggestion : c.AdditionalProperties.AdditionalSubmitArgs = '-N 18 -n 200'
%end
