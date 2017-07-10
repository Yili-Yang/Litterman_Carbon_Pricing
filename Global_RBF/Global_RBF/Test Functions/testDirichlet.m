%% sample code for solving inverse Dirichlet problem
function testDirichlet()
    caseJacobian()
end

%% test jacobian computation
function caseJacobian()
    close all
    M = 16; Extra.M = M;
    [x,Extra.uT,Extra.A,Extra.b0] = prepareTestCase(M);
    plotTemp(Extra.uT,x,M); title('target solution');
    xt = x + (rand(4*M,1)-0.5)*max(x);
    figure; plotTemp(Extra.uT,xt,M); title('perturbed boundary');
    
    functions = cell(3,1);
    functions{1} = @boundaryValue;
    functions{2} = @interiorValue;
    functions{3} = @residual;
    
    dependency = cell(3,2);
	dependency(1,:) = {1, []};
	dependency(2:end,1) = {0};
    dependency(2:end,2) = num2cell([1;2]);
    
    res = zeros(4,1);
    for k = 1:4
       [r,J] = jacobianst(functions,xt,dependency,Extra); 
       res(k) = norm(r);
       xt = xt - J\r;
    end

    u = interiorValue(boundaryValue(xt,[]),Extra);
    figure; plotTemp(u,xt,M); title('solution interior and boundary');
end

%% prepare test case that A*u=b, where b = boundaryValue(x)
function [x,u,A,b0] = prepareTestCase(M)
    x = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
    b = boundaryValue(x,[]);
    A = laplaceMatrix(M);
    u  = A\b;
    idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
    b0 = sparse(idr,ones(4*M,1),zeros(4*M,1));
end

%% generate M-by-M Laplace matrix
function A = laplaceMatrix(M)
    d1 = -ones(M^2,1); d2 = d1; d2(M:M:end) = 0;
    d3 = 4*ones(M^2,1); d4 = [-1;d2(1:(end-1))];
    A = spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2);
end

%% convert boundary values to the right hand side of A*u=b
function b = boundaryValue(x,Extra)
    if isfield(Extra,'M')
        M = Extra.M;
    else
        M = numel(x)/4;
    end
    if isfield(Extra,'b0')
        idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        b = cons(Extra.b0,x);
        b(idr) = b(idr) + x;
    else
        idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        b = sparse(idr,ones(4*M,1),x);
    end
end

%% solve A*u=b
function u = interiorValue(b,Extra)
    u = Extra.A\b;
end

%% compute residual w.r.t. the target solution
function d = residual(u,Extra)
    d = Extra.uT - u;
end

%% plot the solution and boundary values
function plotTemp(u,x,M)
    u = vec2mat(u,M);
    U = [x(1:M)'; u; x((3*M+1):(4*M))'];
    col1 = [(x(M+1)+x(1))/2;x((M+1):(2*M));(x(2*M)+x(3*M+1))/2];
    col2 = [(x(2*M+1)+x(M))/2;x((2*M+1):(3*M));(x(3*M)+x(4*M))/2];
    U = [col1,U,col2];
    imagesc(U); caxis([0 1.5]);
end