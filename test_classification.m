%tvec = [1 2; 1.5 2; 2 2; 4 1; 5 1; 4.5 1; 5 5; 4 4; 6 6;];
%tlab = [1; 1; 1; 2; 2; 2; 3; 3; 3;];


%ovr = trainOVRensamble(tvec, tlab, @perceptron);

clab = unamvoting_ovr(tvec, ovr);

cfmx = confMx(tlab, clab);

compErrors(cfmx);