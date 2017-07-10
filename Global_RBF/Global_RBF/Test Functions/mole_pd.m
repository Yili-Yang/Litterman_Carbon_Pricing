function[val,grad] = mole_pd(xx,DM)
%MOLE Test function p-dimension
%objective function is 1-norm
%   Evaluate the distance function and gradient
%   the molecule problem (p-dimensional). length(xx) = pn. n is the
%   number of atoms
%
%   INPUT:
%   xx - Current positions of the atoms (in plane).xx(1:n) - first coordinates,
%        xx(n+1:2n) the 2nd coordinates...... xx((p-1)n+1:pn) the last coordinates 
%   DM - Sparse `distance matrix' containing the known distances.
%        
%   OUTPUT:
%   val - The value of the distance function:
%   grad -  The gradient of the distance function. 


[r,s] = size(xx);
if r<s
    xx=xx';
end
nn=length(xx); 
[d1,~]=size(DM);
n=d1; % number of atoms
p=nn/n; % number of dimension

w=zeros(n,p);%each column is the position of each dimension
for l=1:p
    w(:,l)=xx((l-1)*n+1:l*n);
end
% w=reshape(xx,n,p);

[I,J,dist] = find(DM); % I,J, dist are column vectors
% len=length(dist);
% term1=zeros(len,p);
% for l=1:p
%     term1(:,l)=w(I,l)-w(J,l);
% end

term1=w(I,:)-w(J,:);
 term2=term1.^2;% matrix, len*p
dd = dist;
term22=sum(term2,2); % row sum, termm22 is column vector
term3= term22.^(1/2)-dd;
val = term3'*term3;

%   Determine the gradient (update edge by edge
if nargout > 1
    ndist = length(dist);
    grad = zeros(nn,1);
    for k = 1:ndist
        i = I(k); j = J(k);
        if i > j
            for l=1:p
                grad((l-1)*n+i)=grad((l-1)*n+i)+ 4*term3(k)*term22(k)^(-1/2)*term1(k,l);
                grad((l-1)*n+j)=grad((l-1)*n+j)- 4*term3(k)*term22(k)^(-1/2)*term1(k,l);
            end
        end
    end
end

