%launch via - samples = tsk2_3_sampler(x_train, y_train)
function [samples] = tsk2_3_sampler(x_train, y_train)
    function [log_posterior] = target_fun(zz, xx, yy)
        ww  = zz(1:end-2); %Dx1
        eps = zz(end-1);
        log_lmb = zz(end); %log of lambda
        lmb = exp(log_lmb);
        
        D = numel(ww); %dimensionality of weights
        
        %give zero chances to impossible cases
        if not(0 <= eps && eps <= 1)
            log_posterior = -Inf;
            return;
        end
        
        kk = zz(1:end-1);
        nlm_L = nlm_loglike(kk, xx, yy);
        
        log_posterior = nlm_L - lmb*dot(ww,ww) + 0.5*D*log_lmb;
    end
    
    D = size(x_train, 2);
    S = 700; %number of samples
    burn = 300; %number of iterations to burn out
    %initial point
    %so initial result correspond to the posteriror of 0.5
    ww0 = zeros(D, 1); %weights
    log_lmb0 = 0; %log of lambda = 0 -> lambda = 1
    eps0 = 0; %epsilon
    
    zz = [ww0; eps0; log_lmb0;];
    %in David MacKay's text book p377 it is said that shrinkage has log complexity
    %in contrast to expansion which takes linear time
    %I take big width for all variables, except for eps because 1 is more
    %then enough for it
    width = ones(D + 2, 1) * 10;
    width(D + 1) = 1.0;%eps
    samples = slice_sample(S, burn, @target_fun, zz, width, true, x_train, y_train);
end

