function d = checkgrad(f, X, e, varargin);
%CHECKGRAD check gradients with finite differences
%
% checkgrad checks the derivatives in a function, by comparing them to finite
% differences approximations. The partial derivatives and the approximation
% are printed and the norm of the difference divided by the norm of the sum is
% returned as an indication of accuracy.
%
% usage: checkgrad(f, X, e, P1, P2, ...)
%
% f  name or pointer to the function
% X  argument, an array, struct, or cell array
% e  small perturbation used for the finite differences, e.g. 1e-5
%    if f is analytic e can be complex, 1e-9i will approach machine precision
% P1, P2, ... are optional additional parameters which get passed to f.
%
% The function f should be of the type 
%
% [fX, dfX] = f(X, P1, P2, ...)
%
% fX is the function value
% dfX are partial derivatives wrt X, dfX has the same type/shape as X

% Carl Edward Rasmussen, 2001-08-01.

% Modified by Iain Murray, 2015-10-22. Stole bits from recent minimize.m to:
%       1) allow f to be a handle, not just a string
%       2) allow X to be any type.
% Also
%       3) allowed the perturbation to be complex. More accurate for small e,
%          but function must be analytic. See:
%          http://blogs.mathworks.com/cleve/2013/10/14/complex-step-differentiation/

[y dy] = feval(f, X, varargin{:});             % get the partial derivatives dy

Z = unwrap(X);
dh = zeros(length(Z),1);
for j = 1:length(Z)
  dx = zeros(length(Z),1);
  if isreal(e)
    dx(j) = e;                                     % perturb a single dimension
    y2 = feval(f, rewrap(X,Z+dx), varargin{:});
    y1 = feval(f, rewrap(X,Z-dx), varargin{:});
    dh(j) = (y2 - y1)/(2*e);                      % standard finite differences
  else
    assert(real(e) == 0);
    dx(j) = 2*e;                                   % perturb a single dimension
    y3 = feval(f, rewrap(X,Z+dx), varargin{:});
    dh(j) = imag(y3)/(-2i*e);                    % complex-step differentiation
  end
end

disp([dy dh abs(dy-dh)])                                           % print the two vectors
d = norm(dh-dy)/norm(dh+dy);       % return norm of diff divided by norm of sum



% Extract the numerical values from "s" into the column vector "v". The
% variable "s" can be of any type, including struct and cell array.
% Non-numerical elements are ignored. See also the reverse rewrap.m. 

function v = unwrap(s)

v = [];   
if isnumeric(s)
  v = s(:);                        % numeric values are recast to column vector
elseif isstruct(s)
  v = unwrap(struct2cell(orderfields(s))); % alphabetize, conv to cell, recurse
elseif iscell(s)
  for i = 1:numel(s)             % cell array elements are handled sequentially
    v = [v; unwrap(s{i})];
  end
end                                                   % other types are ignored


% Map the numerical elements in the vector "v" onto the variables "s" which can
% be of any type. The number of numerical elements must match; on exit "v"
% should be empty. Non-numerical entries are just copied. See also unwrap.m.

function [s v] = rewrap(s, v)

if isnumeric(s)
  if numel(v) < numel(s)
    error('The vector for conversion contains too few elements')
  end
  s = reshape(v(1:numel(s)), size(s));            % numeric values are reshaped
  v = v(numel(s)+1:end);                        % remaining arguments passed on
elseif isstruct(s) 
  [s p] = orderfields(s); p(p) = 1:numel(p);      % alphabetize, store ordering  
  [t v] = rewrap(struct2cell(s), v);                 % convert to cell, recurse
  s = orderfields(cell2struct(t,fieldnames(s),1),p);  % conv to struct, reorder
elseif iscell(s)
  for i = 1:numel(s)             % cell array elements are handled sequentially 
    [s{i} v] = rewrap(s{i}, v);
  end
end                                             % other types are not processed
