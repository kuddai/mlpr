function [Lp, dLp_dw] = lr_loglike(ww, xx, yy)
%LR_LOGLIKE log-likelihood and gradients of logistic regression
%
%     [Lp, dLp_dw] = lr_loglike(ww, xx, yy);
%
% Inputs:
%          ww Dx1 logistic regression weights
%          xx NxD training data, N feature vectors of length D
%          yy Nx1 labels in {+1,-1} or {1,0}
%
% Outputs:
%          Lp 1x1 log-probability of data, the log-likelihood of ww
%      dLp_dw Dx1 gradients: partial derivatives of Lp wrt ww

% Iain Murray, October 2014, August 2015

% Ensure labels are in {+1,-1}:
yy = (yy==1)*2 - 1;

sigmas = 1./(1 + exp(-yy.*(xx*ww))); % Nx1
Lp = sum(log(sigmas));

if nargout > 1
    dLp_dw = (((1-sigmas).*yy)' * xx)';
end

% WARNING: The sigmas can numerically saturate to 1 for large weights. (Or zero,
% if the weights are a terrible explanation of the data). The gradient signal
% (1-sigmas) will then evaluate to zero. We could stave off problems for a
% little longer using Lp=-sum(log1p(exp(...))), and computing (1-sigmas) as
% 1./(1 + exp(yy.*(xx*ww))); However, it doesn't matter how careful we are,
% eventually the gradient *will* underflow for big enough weights. Netlab clips
% the input to the sigmoid functions to prevent total saturation, which could be
% considered. However, the way the computation is arranged here, nothing too bad
% happens (? -- at least we don't get NaNs!). The *real* problem is that models
% with sigmoids that can saturate so much are unrealistically confident. If we
% get numerical problems, our attention should really be on changing the models,
% so we can't get physically unrealistic probabilities in the first place.

