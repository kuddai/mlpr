%launch via - tsk1_5_a(net, xtr_nf, ytr_nf, xte_nf, yte_nf)
function [] = tsk1_5_a(net, x_train, t_train, x_test, t_test)
    %t - means target values
    show_rmse(t_train, mlpfwd(net, x_train), t_test, mlpfwd(net, x_test));
end