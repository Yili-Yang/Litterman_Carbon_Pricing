function y = Exp_DS(x, Extra)
%
%  expended function of one step Euler method
%  for ODE
%         y' = y
%
%     F1 = u1 - G(x, u0) 
%     F2 = u2 - G(x, u1) 
%         :
%         :
%     F3 = uM - G(x, u^{M-1}) 
%       F = uM 
%
% where u^{k+1} = G(x, uk) = uk - h*uk
%
%
%   INPUT
%        x -- input value of expanded function
%    Extra -- parameters of expended function
%
%   OUTPUT
%        y -- function value of expended function

n = length(x);      % n = N*(M+1)
N = Extra.N;
M = Extra.M;
fx = Extra.fkt;
h = Extra.h;

x0 = x(1:N);
u0 = x0;
y = zeros(n,1);

for j = 1 : M
    u1 =  x(j*N+1:(j+1)*N);
    y((j-1)*N+1:j*N) = u1 - u0 - h*feval(fx, u0, Extra);
    u0 = u1;
end
y(M*N+1 : (M+1)*N) = u0;
    