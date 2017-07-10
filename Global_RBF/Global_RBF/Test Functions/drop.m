function [y,g,H] = drop(xx,varargin)

x1 = xx(1);
x2 = xx(2);


frac1 = 1 + cos(12*sqrt(x1^2+x2^2));
frac2 = 0.5*(x1^2+x2^2) + 2;

y = -frac1/frac2;

g=zeros(2,1);
S=x1^2+x2^2;
S1=2*x1;
S2=2*x2;

if (nargout >= 2)
    g(1)=-1/(frac2)^2*(-6*sin(12*sqrt(S))*S^(-1/2)*S1*frac2-1/2*S1*frac1);
    g(2)=-1/(frac2)^2*(-6*sin(12*sqrt(S))*S^(-1/2)*S2*frac2-1/2*S2*frac1);
end
if (nargout >= 3)
    H=zeros(2);
%     H(1,1)=-1/(frac2)^2*(-6*sin(12*sqrt(S))*S^(-1/2)*S1*frac2-1/2*S1*frac1);
%     H(1,2)=-1/(frac2)^2*(-6*sin(12*sqrt(S))*S^(-1/2)*S2*frac2-1/2*S2*frac1);
%     H(2,1)=H(1,2); 
%     H(2,2)=0;
end
end
