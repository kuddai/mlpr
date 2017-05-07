%launch via - tsk1_2_a(xtr_nf, ytr_nf)
function [] = tsk1_2_a(xtr_nf, ytr_nf)
    %I choose 5000 so plot doesn't look cluttered
    num_data_points = 5000; 
    x_left   = xtr_nf(1:num_data_points, end);
    x_above  = xtr_nf(1:num_data_points, end - 34);
    x_target = ytr_nf(1:num_data_points);
    
    figure;
    scatter3(x_left, x_above, x_target);
    xlabel('left pixel intensity');
    ylabel('above pixel intensity');
    zlabel('target pixel intensity');
    set(gca,'FontSize', 20);
    
    figure;
    histogram(ytr_nf,64);
    xlabel('target pixel intensity');
    set(gca,'FontSize', 20);
end