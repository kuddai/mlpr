function [] = report_lr(ww, xx, yy, type_str)
    %report logistic regression 
    sigmas = 1./(1 + exp(-yy.*(xx*ww))); %logistic regression function
    accuracy = sigmas > 0.5;
    log_sigmas = log(sigmas); 
    
    fprintf('%s median of log prob = %5.4f\n', type_str, median(log_sigmas));
    fprintf('%s standard deviation of log prob = %5.4f\n', type_str, std(log_sigmas));
    fprintf('%s accuracy = %s \n',type_str ,errorbar_str(accuracy));
    fprintf('%s log probability = %s \n',type_str, errorbar_str(log_sigmas));
end