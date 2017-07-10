%% prepare sample conductivity and temperature for testing
function [c,u0,uT] = prepareTestCaseHeat(M,N)
    u0 = rand(M+2,1);
    c = rand(3*M,1);
    Extra.M = M; Extra.N = N; Extra.u0 = u0;
    u = conductHeat(c,Extra);
    for k = 2:N
        u = conductHeat([c;u],Extra);
    end
    uT = u;
end

%% approximate temperature at next time step by fininte difference
function y = conductHeat(X,Extra)
    M = Extra.M;
    a = X(1:M); b = X((M+1):2*M); c = X((2*M+1):3*M);
    if length(X) == (3*M)
        u = Extra.u0;
    else
        u = [Extra.u0(1); X((3*M+1):end); Extra.u0(end)];
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
function plotTemp(u0, uT, uP, u)
    a = u0(1); b = u0(end);
    subplot(3,1,1); plot([a;uT;b],'-mo'); title('target temperature'), axis([0 25 -10 200])
    subplot(3,1,2); plot([a;uP;b],'-mo'); title('perturbed temperature'), axis([0 25 -10 200])
    subplot(3,1,3); plot([a;u;b],'-mo');  title('solved temperature'), axis([0 25 -10 200])
end