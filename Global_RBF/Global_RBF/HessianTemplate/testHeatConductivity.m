%% sample code for solving heat conductivity heat inverse problem
function testHeatConductivity()
caseJacobian()
%caseHessianNewton()
end

%% test jacobian computation
function caseJacobian()
rng('default'); rng(13);
dt = 0.1; dx = 0.05; delta = dt/dx^2;
T = 1; N = T/dt; Extra.N = N;
L = 1; M = L/dx; Extra.M = M;
[c, Extra.u0, Extra.uT] = prepareTestCase(M,N);

functions = cell(N+1,1);
functions(1:N) = {@conductHeat};
functions{end} = @residual;

dependency = cell(N+1,2);
dependency(1,:) = {1, []};
dependency(2:(end-1),1) = {1};
dependency(end,1) = {0};
dependency(2:end,2) = num2cell((1:N)');

%% Gauss-Newton to solve heat conductivity inverse problem

t = (rand(numel(c),1)-0.5)*max(c)*0.8; ct = c + t; res = zeros(8,1);
r = cell(8,1);
for k = 1:8
    [r{k},J] = jacobianst(functions,ct,dependency,Extra);
    res(k) = norm(r{k});
    ct = ct - J\r{k};
end
r{end}
close all
plotTemp(Extra.u0, Extra.uT, Extra.uT-r{1}, Extra.uT-r{end});
assert(res(1)*1e-8>res(end))
end

%% test hessian and newton template
function caseHessianNewton()
lambda = 0.1;
dt = 0.1; dx = 0.1; delta = dt/dx^2;
T = 1; N = T/dt; Extra.N = N;
L = 1; M = L/dx; Extra.M = M;
[c, Extra.u0, Extra.uT] = prepareTestCase(M,N);

functions = cell(N+1,1);
functions(1:N) = {@conductHeat};
functions{end} = @squaredError;

dependency = cell(N+1,2);
dependency(1,:) = {1, []};
dependency(2:(end-1),1) = {1};
dependency(end,1) = {0};
dependency(2:end,2) = num2cell((1:N)');

ct = c + rand(numel(c),1)*max(c);

% first run to obtain sparsity pattern
[z,grad,H,Extra] = hessianst(functions,ct,dependency,Extra);
clear global; startup
tic
[zH,gradH,H] = hessianst(functions,ct,dependency,Extra);
sH = -(H+lambda*eye(M+2))\grad';
tH = toc;
clear globa; startup
tic
[zN,gradN,sN] = newtonst(functions,ct,dependency,Extra,lambda);
tN = toc;
assert(1e-8>norm(sH-sN));
end

%% prepare sample conductivity and temperature for testing
function [c,u0,uT] = prepareTestCase(M,N)
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