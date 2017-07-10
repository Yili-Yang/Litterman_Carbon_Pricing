function[val,grad,H] = molefd_1f1d(x,DM)
%MOLE Test function. 1-D , objective function is 1-norm
%
%   Evaluate the distance function and gradient
%   the molecule problem (1-dimensional)
%   See ?? for more details on this molecular minimization problem.
%
%   INPUT:
%   x - Current positions of the atoms (on real line)
%   DM - Sparse `distance matrix'.
%        
%   OUTPUT:
%   val -The value of the distance function:
%      Sum over (i,j) in DM: [abs(x(i)-x(j)) -dist]^2 and
%      add the term abs(x(1)-1)) to force x(1) to 1 (arbitrarily)
%      and thereby remove the singularity due to translation.
%   grad -  The gradient of the distance function. 
%
%   Evaluate the distance function.
[r,s] = size(x);
if r<s
    x=x';
end
[I,J,dist] = find(DM);
ndist = length(dist); 
term1 = x(I) -x(J);
term2=zeros(length(term1),1);
for k = 1:ndist
    if term1(k)>0
        term2(k)= term1(k);
    else
        term2(k)= -term1(k);
    end
end
% term2 = abs(term1);
dd = dist;
term3= term2-dd;
%term3 = term2 - dist.*dist;
val = term3'*term3;
% val = val + (x(1)-1)^2;
%
%   Determine the gradient (update edge by edge
if nargout > 1
    ndist = length(dist); n = length(x);
    grad = zeros(n,1);
    for k = 1:ndist
        i = I(k); j = J(k);
        if i > j
            if term1(k)>0
                grad(i) = grad(i) +  4*term3(k);
                grad(j) = grad(j) - 4*term3(k);
            elseif term1(k)<=0
                grad(i) = grad(i) - 4*term3(k);
                grad(j) = grad(j) + 4*term3(k);
            end
        end
    end
%     grad(1) = grad(1) + 2*(x(1)-1);
end

%   Evaluate hessian
if nargout > 2
    n=length(x);ndist = length(dist);
    H = zeros(n,n) ;
    for k = 1:ndist
        i = I(k); j = J(k);
        if i>j
            if term1(k)>0
                H(i,j) = H(i,j) -4;
                H(j,i) = H(j,i) -4;
                H(i,i) = H(i,i) + 4;
                H(j,j) = H(j,j) + 4;
            elseif term1(k)<=0
                H(i,j) = H(i,j) -4;
                H(j,i) = H(j,i) -4;
                H(i,i) = H(i,i) + 4;
                H(j,j) = H(j,j) + 4;
            end
        end
    end ;
    %     H(1,1)=H(1,1)+2;
    
end

%   
% 
%    
% end
