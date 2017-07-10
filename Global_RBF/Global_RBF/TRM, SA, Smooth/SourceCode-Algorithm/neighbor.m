function xnew = neighbor(x, sr, lb, ub)

% function xnew = neighbor(x, sr, lb, ub)
% Given a point x, neighbor returns a point, xnew, in its neighborhood
% in the range x(i)-sr <= xnew <= x(i)+sr 
% for all i. X and XNEW are vectors of continuous variables. 
% NEIGHBOR also makes sure that the returning point 
% is not out-of-bound ( LB(i) <= X(i) <= UB(i) for all i).
%

xnew = x + (rand(size(x)) * 2) .* sr - sr;
xnew = min(max(xnew,lb),ub);
% 
%  a = rand(size(x));
%  xnew = lb+(ub-lb).*a; 