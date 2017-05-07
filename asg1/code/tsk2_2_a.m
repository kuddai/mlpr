function [] = tsk2_2_a()    
    %test case
    weights = [1; 1; 1]; % x1, x2, bias % Dx1 = 3x1
    epsilon = 0.2;
    k = [weights; epsilon]; % (D+1)x1 = 4x1
    x = [0, 0, 1; 2, 2, 1]; % x1, x2, bias % NxD = 2x3 
    y = [-1; 1]; % Nx1 = 2x1
    h = 0.1; % so the error should be no more 0.001
    
    %show not perturbed values
    [Lp, dLp_dk] = nlm_loglike(k, x, y)
    
    fprintf('checkgrad output:\n');
    fprintf('derivative    finite difference\n');
    accuracy = checkgrad(@nlm_loglike, k, h, x, y)
end