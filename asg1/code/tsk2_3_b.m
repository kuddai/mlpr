%launch via - tsk2_3_b(samples)
function [] = tsk2_3_b(samples)
    epsilons = samples(end - 1, :);
    log_lmbs = samples(end, :);
    
    figure;
    plot(epsilons, log_lmbs, 'r*');
    xlabel('epsilon');
    ylabel('log of lambda');  
end

