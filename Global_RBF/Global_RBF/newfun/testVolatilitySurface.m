%% sample code for solving volatility surface inverse problem
function testVolatilitySurface()
    caseJacobian()
end

%% test jacobian computation
function caseJacobian()
    rng('default'); rng(13);
    dt = 0.1; dx = 0.05; delta = dt/dx^2; K = 0.5;
    T = 1; N = T/dt; Extra.N = N;
    L = 1; M = L/dx; Extra.M = M;
    Extra.K = K; % strike price
    [C, Extra.u0, Extra.uT] = prepareTestCase(M,N,K);
    
    functions = cell(N+1,1);
	functions(1:N) = {@nextOptionValue};
	functions{end} = @residual;
    
    dependency = cell(N+1,2);
	dependency(1,:) = {1, []};
	dependency(2:(end-1),1) = num2cell(2:N)';
    dependency(2:end,2) = num2cell(1:N)';
    
    %% Gauss-Newton to solve heat conductivity inverse problem
    D = num2cell((rand(3*M,N)-0.5)*max(cell2mat(C)), 1)';
    Ct = C + D;
    res = zeros(8,1);
    r = cell(8,1);
    for k = 1:8
       [r{k},J] = jacobianstX(functions,Ct,dependency,Extra); 
       res(k) = norm(r{k});
       Ct = Ct + num2cell(reshape(-J\r{k},3*M,[]),1)';
    end
    close all
    plotTemp(Extra.u0, Extra.uT, Extra.uT-r{1}, Extra.uT-r{end},C,D,Ct);
    assert(res(1)*1e-8>res(end))
end

%% prepare sample volatility surface for testing
function [C,u0,uT] = prepareTestCase(M,N,K)
    u0 = K-(0:(M+1))'/(M+1); u0(u0<0) = 0;  % strike option value w.r.t. stock price
    C = num2cell(rand(3*M,N), 1)';
    Extra.M = M; Extra.N = N; Extra.u0 = u0;
    u = nextOptionValue(C{1},Extra);
    for k = 2:N
        u = nextOptionValue([C{k};u],Extra);
    end
    uT = u; % current option value w.r.t. stock price
end

%% approximate option price at next time step by fininte difference
function y = nextOptionValue(x,Extra)
    M = Extra.M;
    a = x(1:M); b = x((M+1):2*M); c = x((2*M+1):3*M);
    if length(x) == (3*Extra.M)
        u = Extra.u0;
    else
        u = [Extra.u0(1); x((3*Extra.M+1):end); Extra.u0(end)];
    end
    y = a.*u(1:(end-2)) + b.*u(2:(end-1)) + c.*u(3:end);
end

%% calculate residual w.r.t. terminal temperature
function d = residual(u,Extra)
    d = Extra.uT - u;
end

%% calculate squared error w.r.t. terminal temperature
function y = squaredError(u,Extra)
    d = Extra.uT - u;
    y = d'*d;
end

%% plot target, perturbed and solution temperature
function plotTemp(u0, uT, uP, u, C, C0, CT)
    a = u0(1); b = u0(end);
    subplot(4,1,1); plot(u0,'-mo'); title('strike value'), axis([0 25 min(u0) max(u0)])
    subplot(4,1,2); plot([a;uT;b],'-mo'); title('current option value'), axis([0 25 min(uT) max(uT)])
    subplot(4,1,3); plot([a;uP;b],'-mo'); title('perturbed option value'), axis([0 25 -min(uP) max(uP)])
    subplot(4,1,4); plot([a;u;b],'-mo');  title('solved option value'), axis([0 25 min(u) max(u)])
end