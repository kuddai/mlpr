%launch via: 
%tsk1_3_a(xtr_nf, ytr_nf, 5:5:30)
%tsk1_3_a(xtr_nf, ytr_nf, 1:20)
function [] = tsk1_3_a(x_all, t, num_rbfs)
    %t - means target values
    get_adjacent_pixels = @(x) [x(:, end), x(:, end - 34)];
    x = get_adjacent_pixels(x_all);
    
    opt = foptions;
    opt(1)  = 1; % Display EM training
    opt(14) = 5; % number of iterations of EM
    dim     = 2; % left_pixel, above_pixel in our case
    
    function regf = create_rbf_regf(num_rbf)
        function y_test = rbf_reg(x_train, t_train, x_test)
            net = rbf(dim, num_rbf, 1, 'gaussian');
            net = rbftrain(net, opt, x_train, t_train);
            y_test = rbffwd(net, x_test);
        end
        regf = @rbf_reg;
    end
    
    rmse_records = zeros(1, length(num_rbfs));
    
    for i = 1:length(num_rbfs)
        num_rbf = num_rbfs(i);
        regf = create_rbf_regf(num_rbf);
        %default CV 10 folds 
        cvMse = crossval('mse', x, t,'predfun',regf);
        rmse_records(i) = sqrt(cvMse);
    end
    
    plot(num_rbfs, rmse_records)
    hold on;
    plot(num_rbfs, rmse_records, 'r*');
    xlabel('number of rbf used');
    ylabel('Root Mean Square Error');
    set(gca,'FontSize', 18);
end