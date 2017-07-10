function [y,g,H] = shubert(xx,varargin)
x1 = xx(1);
x2 = xx(2);
sum1 = 0;
sum2 = 0;
sumg1=0;
sumg2=0;
sumh1=0;
sumh2=0;
for ii = 1:5
	new1 = ii * cos((ii+1)*x1+ii);
	new2 = ii * cos((ii+1)*x2+ii);
	sum1 = sum1 + new1;
    sumg1=sumg1-ii*sin((ii+1)*x1+ii)*(ii+1);
    sumh1=sumh1-ii * cos((ii+1)*x1+ii)*(ii+1)^2;
	sum2 = sum2 + new2;
    sumg2=sumg2-ii*sin((ii+1)*x2+ii)*(ii+1);
    sumh2=sumh2-ii * cos((ii+1)*x2+ii)*(ii+1)^2;
end

y = sum1 * sum2;
[fc, gc] = fcost(xx);
% w = y/fc;
% fc = w*fc;
% gc = w*gc;
y = fc+y;


if (nargout >= 2)
    g=zeros(2,1);
    g(1)=sum2*sumg1;
    g(2)=sum1*sumg2;
    g = gc+g;
end


if (nargout >= 3)
    H=zeros(2);
    H(1,1)=sum2*sumh1;
    H(1,2)=sumh1*sumh2;
    H(2,1)=H(1,2);
    H(2,2)=sum1*sumh2;
end
end
