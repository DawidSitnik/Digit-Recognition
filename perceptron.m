function [sepplane fp fn] = perceptron(tset, epochs=5, alpha=0.0001)
% Computes separating plane (linear classifier) using
% perceptron method.

% Output:
% fp - false positive count (i.e. number of misclassified samples of pclass)
% fn - false negative count (i.e. number of misclassified samples of nclass)

  pclass = tset(tset(:,end==1))
  nclass = tset(tset(:,end==0))

  nPos = rows(pclass) % number of positive samples
  nNeg = rows(nclass) % number of negative samples
  
  weights = rand(1, size(tset)(2)) - 0.5;
  error = 0
  for epoch = 1:epochs
      for j = 1:size(tset)(1)
          prediction = predict(tset(j,:), weights);
          error += (tset(j,end) - prediction);
          if mod(j, 50) == 0
            weights += alpha * error * [1 tset(j, 1:end-1)];
            error = 0;
          end
      end
  end

  pset = zeros(size(tset)(1), size(tset)(2)+1);
  pset(:,1:end-1) = tset;
  sepplane = weights

  for i = 1:size(pset)(1)
      pset(i,end) = predict(pset(i,1:end-1), sepplane);
  end

  fp_1 = find(pset(:,end-1) == 1);
  fp_2 = find(pset(:,end) != 1);
  fp = numel(intersect(fp_1, fp_2));

  fn_1 = find(pset(:,end-1) == 0);
  fn_2 = find(pset(:,end) != 0);
  fn = numel(intersect(fn_1, fn_2));

