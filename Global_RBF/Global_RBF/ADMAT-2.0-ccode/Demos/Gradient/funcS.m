%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    function y_i = S(y_{i-1}) for the Eular method of
%    ODE  y' = F(y), that is
%
%          y_i = y_{i-1} + h*F(y_{i-1})
%
%                   Wei Xu
%                August 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = funcS(x, Extra)
%
%  function F on the right hand side of ODE
fun = Extra.fun;
%  step size of Eular method
h = Extra.h;

y = x + h * feval(fun, x);