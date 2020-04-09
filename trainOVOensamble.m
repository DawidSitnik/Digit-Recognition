function ovosp = trainOVOensamble(tset, tlab, htrain)
% Trains a set of linear classifiers (one versus one class)
% on the training set using trainSelect function
% tset - training set samples
% tlab - labels of the samples in the training set
% htrain - handle to proper function computing separating plane
% ovosp - one versus one class linear classifiers matrix
%   the first column contains positive class label
%   the second column contains negative class label
%   columns (3:end) contain separating plane coefficients

  labels = unique(tlab);
  
  % nchoosek produces all possible unique pairs of labels
  % that is exactly what we need for ovo classifier
  pairs = nchoosek(labels, 2);
  ovosp = zeros(rows(pairs), 2 + 1 + columns(tset));
  
  %first 2 arguments are labels of classes, than there are fp and fn
    errors = zeros(rows(pairs), 4);

  for i=1:rows(pairs)
  pairs(i, :)
	% store labels in the first two columns
    ovosp(i, 1:2) = pairs(i, :);
	  errors(i, 1:2) = pairs(i,:);

    lab_1 = find(tlab == pairs(i,1))(:);
    lab_2 = find(tlab == pairs(i,2))(:);

    lab_1_2 = [lab_1; lab_2]
    trainset = horzcat(tset(lab_1_2,:), tlab(lab_1_2))
    trainset(1:size(lab_1)(1),end) = 1;
    trainset(size(lab_1)(1)+1:end,end) = 0;
    trainset
	% train 5 classifiers and select the best one
    [sp fp fn] = trainSelect(trainset, 5, htrain);
	
    errors(i, 3:4) = [fp fn]

	% what to do with errors?
    % dodać dodatkowy argument odnośnie błędów
	% it would be wise to add additional output argument
	% to return error coefficients
	
    % store the separating plane coefficients (this is our classifier)
	% in ovo matrix
    ovosp(i, 3:end) = sp; 
  end
