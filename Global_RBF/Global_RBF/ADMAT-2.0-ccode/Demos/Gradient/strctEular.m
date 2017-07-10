%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Compare the performance of computing a gradient
%    by straightfoward reverse mode, dense block reverse
%    mode and sparse blocks method.  The testing problem is
%    as follows.
%
%    Eular method to solve the ODE
%           y' = F(y),
%    in the structured form metioned in Section 5.
%    Define a function z = f(x), that is
%        y0 = x
%        y_i = y_{i-1} + h*F(y_{i-1}}
%        z = || y_p - yT ||_2,
%    where i = 1....p.
%
%  
%                 Wei Xu
%              August 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z = strctEular(x, Extra)
%
% number of Eular steps
p = Extra.p ;
% function F on the right hand side of ODE
fun = Extra.fun;
% Eular method step size
h = Extra.h;
% desired final state yT
yT = Extra.yT;

y0 = x;
for i = 1 : p
    y1 = y0 + h*feval(fun, y0);
    y0 = y1;
end
z = norm(y1-yT);

