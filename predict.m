% help function for perceptron

function prediction = predict(row, weights)
    activation = weights(1) + [weights(2:end)] * transpose(row(1:end-1));
    if activation >= 0
        prediction = 1;
    else 
        prediction = 0;
    end
end