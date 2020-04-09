function clab = unamvoting(tset, clsmx)
% prawdopodobnie można w ogóle nie zmieniać tej funkcji
% Simple unanimity voting function 
% 	tset - matrix containing test data; one row represents one sample
% 	clsmx - voting committee matrix
%   	the first column contains positive class label
%   	the second column contains negative class label
%   	columns (3:end) contain separating plane coefficients
% Output:
%	clab - classification result 

	% class processing
	labels = unique(clsmx(:, [1 2]));
	%oznaczenie decyzji wyminiającej
	reject = max(labels) + 1;

	% cast votes of classifiers
	votes = voting(tset, clsmx);

	maxvotes = rows(labels) - 1; % unanimity voting in one vs. one scheme

	[mv clab] = max(votes, [], 2);

	% reject decision 
	clab(mv ~= maxvotes) = reject;
