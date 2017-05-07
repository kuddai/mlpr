function [rmse_est, std_err] = cs_rmse(t, y)
    %custom root mean square error
    diff = t - y;
    %mean square error
    sqr_diff = diff .* diff;
    mse_est = mean(sqr_diff);
    rmse_est = sqrt(mse_est);
    if nargout > 1
        %professor Chris Williams pointed out that
        %to produce some bounds on rmse:
        %mse = mse_est +/- mse_std_err
        %rmse = f(mse) = f(mse_est +/- mse_std_err) = sqrt(mse_est +/- mse_std_err)
        %f(u +/- h) ~= f(u) +/- f'(u)h = sqrt(u) +/- 0.5 * h/(sqrt(u)) %Taylor expansion
        S = numel(t);
        var_est = var(sqr_diff);
        mse_std_err = sqrt(var_est/S);
        std_err = 0.5 * mse_std_err / rmse_est;
    end
end

