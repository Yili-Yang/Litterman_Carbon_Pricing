%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This script compares the performance of one step of raw Newton
%     computation and the structured Newton computation of function
%     F(A^{-1}F2(x)), where F and F2 are Broyden functions and the 
%     structure of A based on 5-point Laplacian defined on a square
%     sqrt(n+2)-by-sqrt(n+2) grid.
%   
%     Source code of Example 6.2.2 in section 6.2 in the manual
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% number of sample problmes
k = 13;
% initial value of CPU time array
tNew = zeros(k,1);
tExp = zeros(k,1);
% 
%   start k testing problem
for i = 1 : k
    % problem size
    n = (5+i)^2;
    % initial value of x
    x0 = rand(n,1);
    m = length(broyden(x0));
    
    % get the structure of A
    sqrtn = sqrt(n);
    G = numgrid('S', sqrtn+2);
    Ax = delsq(G);

    t = cputime;
    %
    % one step of raw Newton computation by forward AD
    %
    x = deriv(x0, eye(n));
    y = OriFun(x, n, Ax);
    % get the Jacobian
    J = getydot(y);
    fval = getval(y);
    % Newton step
    sN = J\fval;
    x1 = x0 -  sN;
    tNew(i) = cputime - t;
    %
    % one step of structured Newton computation
    %
    % get the sparsity pattern of Jacobian 'broyden'
    JPI = getjpi('broyden', m);

    t = cputime;
    [y1, J1] = evalj('broyden', x0, [], [], JPI);
    % construct A
    A = Ax .* x0(:,ones(1,n))';

    y2 = A\y1;
    [fval, J2] = evalj('broyden', y2, [], [], JPI);
    % construct Axy
    Axy = Ax .* y2(:,ones(1,n))';
    % construct JE
    JE = [-J1, eye(n), zeros(n,n);
        Axy, -eye(n), A;
        zeros(n,n), zeros(n,n), J2];

    sN = sparse(JE)\[zeros(2*n,1); -fval];
    x2 = x0 + sN(1:n);
    tExp(i) = cputime - t;
end
%
%  plot the CPU time of raw Newton and structured Newton computations
%
hold on
plot(tNew, '+');
plot(tExp, 'o');
