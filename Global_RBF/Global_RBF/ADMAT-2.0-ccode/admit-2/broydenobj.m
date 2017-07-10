function [F, J] = broydenobj(x)
% evaluate teh Broyden nonlinear equations test function.
% get the vector size
n = length(x);
sqrtn = floor(sqrt(n));
m = length(broyden(x));
fun = 'broyden';
TildeF = 'broyden';
BarF = 'broyden';
JPI = getjpi(fun, m);
G = numgrid('S', sqrtn+2);
K = delsq(G);
Ax = full(K);

for i = 1 : n
    A(:,i) = Ax(:,i) * x(i);
end

% consruct tildeJ and barJ
[y1, tildeJ] = evalj(TildeF, x, [], [], JPI);
y2 = A \ y1;
[F, barJ] = evalj(BarF, y2, [], [], JPI);

% construct Axy
for i = 1 : n
    Axy2(:,i) = Ax(:,i) * y2(i);
end

% construct J 
 J = barJ*inv(A)*(tildeJ-Axy2);
