function [f] = volafunValue(x,DM)

M = DM.M;
N = DM.N;
u0 = DM.u0;
uT = DM.uT;
K = DM.K;

x = getval(x);

if size(x,1)==1
    x=x';
end

c = num2cell(reshape(x,3*M,N), 1)';

u = nextOptionValue(c{1},DM);
for k = 2:N
    u = nextOptionValue([c{k};u],DM);
end

%% get func
f=sum((uT-u).^2);

end