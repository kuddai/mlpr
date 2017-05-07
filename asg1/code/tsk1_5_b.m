%launched via - tsk1_5_b(xtr_nf, ytr_nf, xte_nf, yte_nf)
function [] = tsk1_5_b(x_train, t_train, x_test, t_test)
    %t - means target values
    nhid = 10; % number of hidden units
    
    % Set up vector of options for the optimiser.
    options = zeros(1,18);
    %options(1)  = 1; % This provides display of error values.
    %options(9)  = 1; % Check the gradient calculations.
    options(14) = 200; % Number of training cycles.
    
    function [] = launch_NN(seed)
        rng(seed,'twister');
        net = mlp(size(x_train,2), nhid, 1, 'linear');
        [net, tmp] = netopt(net, options, x_train(1:5000,:), t_train(1:5000,:), 'scg');
        
        fprintf('seed %4.0f:\n', seed);
        show_rmse(t_train, mlpfwd(net, x_train), t_test, mlpfwd(net, x_test));
    end
    
    seeds  = 2015:1:2019;
    
    for i = 1:length(seeds)
        seed = seeds(i)
        launch_NN(seed);
    end
end