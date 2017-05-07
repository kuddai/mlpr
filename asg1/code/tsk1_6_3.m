%launch via - tsk1_6_3(xtr_nf, ytr_nf)
function [] = tsk1_6_3(x_all_train, t)
    %t - means target values
    
    function y_test = regf(x_train, t_train, x_test)
       [w, predictor] = cs_linear_regression(x_train, t_train);
       y_test = predictor(x_test);
    end
    
    max_distances = 2:17;
    rmse_records = zeros(length(max_distances), 1);
    
    for i = 1:length(max_distances)
        max_dist = max_distances(i)
        x = get_closest_pixels(x_all_train, max_dist);
        %to see complexity of the model
        size(x)
        %default 10 fold
        cvMse = crossval('mse', x, t,'predfun', @regf);
        rmse_records(i) = cvMse ^ 0.5;
    end
    
    plot(max_distances, rmse_records);
    hold on;
    plot(max_distances, rmse_records, 'r*');
    xlabel('maximum distance from target pixel');
    ylabel('Root Mean Square Error');
end
    