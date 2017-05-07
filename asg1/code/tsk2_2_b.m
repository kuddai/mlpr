%launch via - tsk2_2_b(x_train, y_train, x_test, y_test)
function [] = tsk2_2_b(x_train, y_train, x_test, y_test)
    %default parameters
    MAX_LIN_SEARCHES = 8000;
    sigma = @(x) 1/(1 + exp(-x));
    
    function [Lp, dLp_dq] = target_fun(qq, xx, yy)
        a = qq(end);
        eps = sigma(a);
        kk = qq(:);%copy original array
        kk(end) = eps;
        
        [Lp, dLp_dk] = nlm_loglike(kk, xx, yy);
        Lp = -Lp;
        %augmenting derivative
        dLp_dq = -dLp_dk(:);%copy original array
        dLp_dq(end) = dLp_dq(end) * eps * (1 - eps);
    end
    
    function qq = train(xx, yy)
        initial_qq = zeros(size(xx, 2) + 1, 1);% plus one to account parameter a
        qq = minimize(initial_qq, @target_fun, MAX_LIN_SEARCHES, xx, yy);
    end

    qq = train(x_train, y_train);
    weights = qq(1:end-1)
    final_a = qq(end)
    epsilon = sigma(final_a) % report it for the task
    report_lr(weights, x_train, y_train, 'training set');
    report_lr(weights, x_test,  y_test,  'test set');
end