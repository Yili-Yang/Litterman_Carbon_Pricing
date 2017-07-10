function [f]= heatfunValue(x,DM)

if size(x,1)==1
    x=x';
end

xheat_size = size(x);

M = DM.M;
N = DM.N;
u0 = DM.u0;
uT = DM.uT;

u = conductHeat(x,DM);
for k = 2:N
    u = conductHeat([x;u],DM);
end

%% get func
f=sum((uT-u).^2);

end