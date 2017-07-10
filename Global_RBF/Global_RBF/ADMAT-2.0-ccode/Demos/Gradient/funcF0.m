%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    z = norm(y-yT), where yT is known.  
%
%
%                   Wei Xu
%                August 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z = funcF0(y, Extra)
%
% value of yT
yT = Extra.yT;

z = norm(y-yT);