function [] = show_rmse(t_train, y_train, t_test, y_test)
    [rmse_train, std_err_train] = cs_rmse(t_train, y_train);
    [rmse_test,  std_err_test]  = cs_rmse(t_test,  y_test);
    
    fprintf('rmse on training set %5.4f +/- %5.4f\n', rmse_train, std_err_train);
    fprintf('rmse on test set %5.4f +/- %5.4f\n', rmse_test, std_err_test);
end