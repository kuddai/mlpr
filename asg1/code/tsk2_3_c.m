%launch via - tsk2_3_c(samples, x_test, y_test)
function [] = tsk2_3_c(samples, x_test, y_test)
    function [] = performance(wws, yy, xx)
        %D - dimensionality of data points
        %N - number of instances
        %S - number of samples
        %wws D x S
        %xx  N x D
        %yy  N x 1
        %repmat(yy, [1, S]) N x S
        %xx * wws  N x S
        S = size(wws, 2);
        sigmas = 1./(1 + exp(-repmat(yy, [1, S]) .* (xx*wws)));%N x S
        probs = mean(sigmas, 2); % assemble samples
        log_probs = log(probs); 
        accuracy = probs > 0.5;
        
        fprintf('test accuracy = %s \n', errorbar_str(accuracy));
        fprintf('test log probability = %s \n', errorbar_str(log_probs));
    end

    weights  = samples(1:end - 2, :);
    performance(weights, y_test, x_test);
end