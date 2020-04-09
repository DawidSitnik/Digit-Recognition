function [ovrsp errors] = trainOVRensamble(tset, tlab, htrain)
% Trains a set of linear classifiers (one versus rest class)
% on the training set using trainSelect function
% tset - training set samples
% tlab - labels of the samples in the training set
% htrain - handle to proper function computing separating plane
% ovosp - one versus one class linear classifiers matrix
%   the first column contains positive class label
%   the second column contains negative class label
%   columns (2:end) contain separating plane coefficients

  labels = unique(tlab);
  
  %in this case we just need columns for one class and bias+weights
  ovrsp = zeros(size(labels), 1 + 1 + columns(tset));
  
  %first 1 argument is label of classes, than there are fp and fn
    errors = zeros(size(labels), 3);
  
  for i=1:size(labels)
  %for i=1:1
	% store label in the first two column
    ovrsp(i, 1) = i;
	  errors(i, 1) = i;
    %get ids of the one class and rest
    the_one_labels = find(tlab == labels(i))(:);
    rest_labels = find(tlab != i)(:);

    tlab_copy = tlab;
    %change labels of classes to 1 and 0
    tlab_copy(the_one_labels) = 1;
    tlab_copy(rest_labels, :) = 0;

    %merge tset and labels
    trainset = horzcat(tset, tlab_copy);

	% train 5 classifiers and select the best one
    [sp fp fn] = trainSelect_ovr(trainset, 5, htrain);
	
    errors(i, 2:3) = [fp fn];
	
    % store the separating plane coefficients (this is our classifier)
	% in ovr matrix
    ovrsp(i, 2:end) = sp; 
  end
