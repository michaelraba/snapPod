% reads x,y coordinates of snapshot's crosssection and plots that.
function plCont() % redo for parfor loop.
[ntimesteps, rMin ,rMax, ss ,ncs ,plotOn ,azimuthalSet, azimuthalSetSize ,printStatus, lags]=constants();
    gnuP = '/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/fluctuationContourPlotJun24/';
    opStr = [gnuP '01.dat'];
    cte=540*10;
     % formatSpec = '%f';
     % a=fopen(opStr, 'r');
     % importedData = fscanf(a,formatSpec);
    qq = readmatrix(opStr);
    xx=qq(1:cte,1);
    yy=qq(1:cte,2);
    zz=qq(1:cte,3);

    [X,Y]=meshgrid(1:cte,1:cte);
    Z=griddata(xx,yy,zz,X,Y);
    surf(X,Y,Z)
end % fc
