%launch via - tsk2_1_c_investigation(x_train, y_train)
function [] = tsk2_1_c_investigation(x_train, y_train)
    y = y_train(1:100);
    x = x_train(1:100, :);
    
    [newmat,indexFirst] = unique(x,'rows','first');  
    repeatedIndexFirst  = setdiff(1:size(x,1), indexFirst);
    [newmat,indexLast]  = unique(x,'rows','last');  
    repeatedIndexLast   = setdiff(1:size(x,1), indexLast);
    repeated = [repeatedIndexFirst; repeatedIndexLast] 
    
    is_x_1_equal_x_21  = isequal(x(1, :), x(21, :))
    is_y_1_equal_y_21  = isequal(y(1), y(21))
    is_x_10_equal_x_81 = isequal(x(10, :),x(81, :))
    is_y_10_equal_y_81 = isequal(y(10),y(81))
    
    y_1  = y(1)
    y_21 = y(21)
    y_10 = y(10)
    y_81 = y(81)
end