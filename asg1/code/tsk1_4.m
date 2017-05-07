%launch via - tsk1_4(xtr_nf, ytr_nf, xte_nf, yte_nf)
function [] = tsk1_4(x_train, t_train, x_test, t_test)
    %t - means target values
    %train (it will add bias term automatically)
    [w, predictor] = cs_linear_regression(x_train, t_train);
    show_rmse(t_train, predictor(x_train), t_test, predictor(x_test));
end