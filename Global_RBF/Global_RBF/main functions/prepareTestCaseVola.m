function [X,C,u0,uT] = prepareTestCaseVola(M,N,K)

u0 = K-(0:(M+1))'/(M+1); u0(u0<0) = 0;  % strike option value w.r.t. stock price

X = rand(3*M*N,1);
C = num2cell(reshape(X,3*M,N), 1)';

Extra.M = M; Extra.N = N; Extra.u0 = u0;

u = nextOptionValue(C{1},Extra);
for k = 2:N
    u = nextOptionValue([C{k};u],Extra);
end
uT = u; % current option value w.r.t. stock price

end