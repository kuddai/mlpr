function [w, predictor] = cs_linear_regression(x_train, t_train)
    %custom linear regression
    %it inserts bias term automatically %Ruslan Burakov
    
    %adding bias term
    calc_Phi = @(x)[ones(size(x, 1), 1), x];
    
    %computing weights
    w = pinv(calc_Phi(x_train)) * t_train;
    
    predictor = @(x_test)calc_Phi(x_test) * w; 
end