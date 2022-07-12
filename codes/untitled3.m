sz=100
a=randi([-9 9],1,sz)*1e-2
[b,lags]=xcorr(a,"normalized")
plot(lags(end/2:end),b(end/2:end))
title('Correlation of a random signal generated with function randi()','FontName','capitana','FontSize',12,'interpreter','latex')