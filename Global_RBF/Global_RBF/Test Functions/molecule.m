function [ f, g, TrH] = molecule( x,DM )

n=length(x);
f=0;
TrH=zeros(n);
for i=1:n-1
    for j=i+1:n
        f=f+((x(i)-x(j))^2-DM(i,j))^2;
    end
end

if (nargout==3)
    g=0;
    for i=1:n
        for j=1:n
            TrH(i,i)=TrH(i,i)+12*(x(i)-x(j))^2-4*DM(i,j);
        end
    end
end

end

