%launch via:
% b)   tsk2_1_bc(x_train, y_train, x_test, y_test)
% c)   tsk2_1_bc(x_train, y_train, x_test, y_test, 1:100)
% c.2) tsk2_1_bc(x_train, y_train, x_test, y_test, 2:100)
function [] = tsk2_1_bc(x_train, y_train, x_test, y_test, varargin)
    MAX_LIN_SEARCHES = 8000;
    if length(varargin) == 0
       train_limits = 1:size(x_train, 1);
    else
       train_limits = varargin{1};
    end
    
    function [Lp, dLp_dw] = target_fun(ww, xx, yy)
        [Lp, dLp_dw] = lr_loglike(ww, xx, yy);
        Lp = -1 * Lp;
        dLp_dw = -1 * dLp_dw;
    end

    function ww = train(xx, yy)
        initial_ww = zeros(size(xx, 2), 1);
        ww = minimize(initial_ww, @target_fun, MAX_LIN_SEARCHES, xx, yy);
    end

    weights = train(x_train(train_limits, :), y_train(train_limits, :))
    report_lr(weights, x_train(train_limits, :), y_train(train_limits, :), 'training set');
    report_lr(weights, x_test, y_test, 'test set');
end