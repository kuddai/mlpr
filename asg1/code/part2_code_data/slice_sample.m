function samples = slice_sample(N, burn, logdist, xx, widths, step_out, varargin)
%SLICE_SAMPLE simple axis-aligned implementation of slice sampling for vectors
%
%     samples = slice_sample(N, burn, logdist, xx, widths, step_out, P1, P2, ...)
%
% Originally based on pseudo-code in David MacKay's text book p375.
% Start there for more detail on how this function works.
%
% Inputs:
%             N  1x1  Number of samples to gather
%          burn  1x1  after burning period of this length
%       logdist  @fn  handle to a function evaluating the log density of
%                     your target distribution up to a constant.
%                     This function will be called like this:
%                     Lpstar = logdist(xx, P1, P2, ...);
%                     where P1, P2, ... are any optional arguments you
%                     passed to slice_sample. In Matlab, put an @ in front of a
%                     function name to create a handle to it.
%            xx  Dx1  initial state (can be any array with D elements)
%        widths  Dx1  or 1x1, initial bracket widths for slice sampler
%      step_out bool  set to true if widths may sometimes be far too small
%        P1, P2, ...  any extra arguments are passed on to logdist
%
% Outputs:
%      samples  DxN   samples stored in columns (regardless of original shape)

% Iain Murray May 2004, tweaks June 2009, a diagnostic added Feb 2010.
% Tweaked progress output and documentation, October 2014.

% startup stuff
D = numel(xx);
samples = zeros(D, N);
if numel(widths) == 1
    widths = repmat(widths, D, 1);
end
log_Px = feval(logdist, xx, varargin{:});

% Main loop
num_props = 0;
for ii = 1:(N+burn)
    fprintf('Sweep iteration %d, #props/update = %2.1f\r', ii - burn, num_props/D);
    num_props = 0;
    % Sweep through axes (simplest thing)
    for dd = 1:D
        log_uprime = log(rand) + log_Px;

        x_l = xx;
        x_r = xx;
        xprime = xx;

        % Create a horizontal interval (x_l, x_r) enclosing xx
        rr = rand;
        x_l(dd) = xx(dd) - rr*widths(dd);
        x_r(dd) = xx(dd) + (1-rr)*widths(dd);
        if step_out
            % Typo in early editions of book. Book said compare to u, but it should say u'
            while (feval(logdist, x_l, varargin{:}) > log_uprime)
                x_l(dd) = x_l(dd) - widths(dd);
            end
            while (feval(logdist, x_r, varargin{:}) > log_uprime)
                x_r(dd) = x_r(dd) + widths(dd);
            end
        end

        % Inner loop:
        % Propose xprimes and shrink interval until good one found
        while 1
            num_props = num_props + 1;
            xprime(dd) = rand()*(x_r(dd) - x_l(dd)) + x_l(dd);
            log_Px = feval(logdist, xprime, varargin{:});
            if log_Px > log_uprime
                break % this is the only way to leave the while loop
            else
                % Shrink in
                if xprime(dd) > xx(dd)
                    x_r(dd) = xprime(dd);
                elseif xprime(dd) < xx(dd)
                    x_l(dd) = xprime(dd);
                else
                    error('BUG DETECTED: Shrunk to current position and still not acceptable.');
                end
            end
        end
        xx(dd) = xprime(dd);
    end

    % Record samples
    if ii > burn
        samples(:, ii - burn) = xx(:);
    end
end
fprintf('\n');

