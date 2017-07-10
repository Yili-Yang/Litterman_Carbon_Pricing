function [f,g,H] = griewank( x , varargin )

n=length(x);
quad=0;
tri=1;
g=zeros(n,1);
H=zeros(n);
p=varargin{1};
for i=1:n
    quad=quad+p*x(i)*x(i);
    tri=tri*cos(x(i)/sqrt(i));
end
f = 1 + quad - tri;

if (nargout >= 2)
    for i=1:n
        g(i,1) = 2*x(i)*p + 1/sqrt(i)*tri*tan(x(i)/sqrt(i));
    end
end

if (nargout == 3)
    for i=1:n
        for j=i:n
            if(i==j)
                H(i,j)=2*p+tri/i;
            else
                H(i,j)=-tri*tan(x(i)/sqrt(i))*tan(x(j)/sqrt(j))/sqrt(i*j);
                H(j,i)=H(i,j);
            end
        end
    end
end

end