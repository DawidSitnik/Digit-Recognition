comp_count = 40; 

[tvec tlab tstv tstl] = readSets(); 

% let s look at the first digit in the training set
imshow(transpose(1-reshape(tvec(1,:), 28, 28)));

% let s check labels in both sets
[transpose(unique(tlab)); transpose(unique(tstl))]

% compute and perform PCA transformation
[mu trmx] = prepTransform(tvec, comp_count);
tvec = pcaTransform(tvec, mu, trmx);
tstv = pcaTransform(tstv, mu, trmx);

% lets shift labels by one to use labels directly as indices
tlab += 1;
tstl += 1;

% To successfully prepare ensemble you have to implement perceptron function
% I would use 10 first zeros and 10 fisrt ones 
% and only 2 first primary components
% It ll allow printing of intermediate results in perceptron function

%lab_1 = find(tlab == 1)(1:500);
%lab_2 = find(tlab == 2)(1:500);

%lab_1_2 = [lab_1; lab_2];
%tset = horzcat(tvec(lab_1_2,1:2), tlab(lab_1_2));
%tset(1:size(lab_1)(1),end) = 0;
%tset(size(lab_1)(1)+1:end,end) = 1;
%tset;

%[sepplane fp fn] = perceptron(tset, 5, 0.1)
tvec = expandFeatures(tvec);

%training of the whole ensemble
ovo = trainOVOensamble(tvec, tlab, @perceptron);

%check your ensemble on train set
clab = unamvoting(tvec, ovo);
cfmx = confMx(tlab, clab);
compErrors(cfmx);

%x = clock
%save(strcat('./variables/ovo_lr_0.00005_epochs_200_', datestr(x)));
%load('./variables/ovo_ext_e_50_a_0.00001');

%repeat on test set
tstv = expandFeatures(tstv)
clab = unamvoting(tstv, ovo);
cfmx = confMx(tstl, clab);
compErrors(cfmx);

%training of the whole ensemble
ovr = trainOVRensamble(tvec, tlab, @perceptron);
clab = unamvoting_ovr(tvec, ovr);
cfmx = confMx(tlab, clab);
compErrors(cfmx);
%x = clock
%%save(strcat('./variables_ovr_e_50_a_0.00001_', datestr(x)))

repeat on test set
clab = unamvoting(tstv, ovo);
cfmx = confMx(tstl, clab);
compErrors(cfmx);

model = svmtrain(tlab, tvec);
[predict_label, accuracy, dec_values] = svmpredict(tstl, tstv, model);