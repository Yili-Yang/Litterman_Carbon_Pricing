function [f, g] = volafunAD(x,DM)

if size(x,1)==1
    x=x';
end

M=DM.M;
N=DM.N;
x = getval(x);

n = length(x);
myfun = ADfun('volafunValue', 1);
options = setgradopt('forwprod', n);
[f, g] = feval(myfun, x, DM, options);

g = g';

% functions = cell(N+1,1);
% functions(1:N) = {@nextOptionValue};
% functions{end} = @residual;
% 
% dependency = cell(N+1,2);
% dependency(1,:) = {1, []};
% dependency(2:(end-1),1) = num2cell(2:N)';
% dependency(2:end,2) = num2cell(1:N)';
% 
% [~,g] = jacobianstX(functions,Ct,dependency,DM);
% g=g'*f;

jx_size = size(g)

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