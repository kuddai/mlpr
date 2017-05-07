function [Lp, dLp_dk] = nlm_loglike(kk, xx, yy)
    %nlm - noisy labels model
    %kk - ww + epsilon -> (D+1)x1 
    %xx - NxD
    %yy - Nx1
    % Ensure labels are in {+1,-1}:
    yy  = (yy==1)*2 - 1;
    ww  = kk(1:end-1);
    eps = kk(end);

    sigmas = 1./(1 + exp(-yy.*(xx*ww))); % Nx1
    %probabilities
    pbs = (1-eps)*sigmas + 0.5*eps; % Nx1
    Lp = sum(log(pbs));

    if nargout > 1
        %inverse probabilities
        inv_pbs = 1./pbs; % Nx1
        dLp_dw   = (inv_pbs.*(1-eps).*(1-sigmas).*sigmas.*yy)' * xx; % 1xD
        dLp_deps = sum(inv_pbs.*(-sigmas + 0.5)); % 1x1
        dLp_dk   = [dLp_dw, dLp_deps]'; % (D+1)x1
    end
end