%% prepare test case that A*u=b, where b = boundaryValue(x)
function [x,u,A,b0] = prepareTestCase(M)
    x = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
    b = boundaryValue(x,[]);
    A = laplaceMatrix(M);
    u  = A\b;
    idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
    b0 = full(sparse(idr,ones(4*M,1),zeros(4*M,1)));
end

%% generate M-by-M Laplace matrix
function A = laplaceMatrix(M)
    d1 = -ones(M^2,1); d2 = d1; d2(M:M:end) = 0;
    d3 = 4*ones(M^2,1); d4 = [-1;d2(1:(end-1))];
    A = full(spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2));
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