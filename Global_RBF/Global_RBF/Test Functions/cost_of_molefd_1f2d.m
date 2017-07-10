function[val,grad,H] = molefd_1f2d(xx,DM)
%MOLE Test function 
%objective function is 1-norm
%   Evaluate the distance function and gradient
%   the molecule problem (2-dimensional). length(xx) = 2n. n is the
%   number of atoms
%   See ?? for more details on this molecular minimization problem.
%
%   INPUT:
%   xx - Current positions of the atoms (in plane).xx(1:n) - first coordinates,
%        xx(n+1:2n) the 2nd coordinates.
%   DM - Sparse `distance matrix' containing the known distances.
%        
%   OUTPUT:
%   val - The value of the distance function:
%      Sum over (i,j) in DM: [((x(i)-x(j))^2 +(y(i)-y(j))^2)^1/2 -dist]^2 and
%      add the term (x(1))^2) +(y(1))^2  + (x(2)-1)^2 +(y(2)-1)^2
%      to force (x(1),y(1)) to zero, (x(2),y(2)) to 1. 
%      It is assumed that DM(1,2) = DM(2,1) = 1;
%      and thereby remove the singularity due to translation/'rotation..
%   grad -  The gradient of the distance function. 
%   H   -  Hessian matrix

[r,s] = size(xx);
if r<s
    xx=xx';
end
nn=length(xx); n = nn/2;
x= xx(1:n,1); y = xx(n+1:nn,1);
[I,J,dist] = find(DM);
term1x = x(I) -x(J); term1y = y(I)-y(J);
term2x = term1x.*term1x; term2y = term1y.*term1y;
dd = dist;
term22=term2x+term2y;
term3= term22.^(1/2)-dd;
val = term3'*term3;
% val = val + x(1)^2 + y(1)^2 +(x(2)-1)^2 +(y(2)-1)^2;

[fc, gc] = fcost(xx);
w = .01*val/fc;
fc = w*fc;
gc = w*gc;
val = fc+val;

%   Determine the gradient (update edge by edge
if nargout > 1
    ndist = length(dist);
    grad = zeros(nn,1);
    for k = 1:ndist
        i = I(k); j = J(k);
        if i > j
                grad(i) = grad(i) +  4*term3(k)*term22(k)^(-1/2)*term1x(k);
                grad(j) = grad(j) - 4*term3(k)*term22(k)^(-1/2)*term1x(k);
                grad(n+i) = grad(n+i) + 4*term3(k)*term22(k)^(-1/2)*term1y(k);
                grad(n+j) = grad(n+j) - 4*term3(k)*term22(k)^(-1/2)*term1y(k);
        end
    end
%     grad(1) = grad(1) + 2*(x(1)); grad(n+1) = grad(n+1) + 2*(y(1));
%     grad(2) = grad(2) +2*(x(2)-1); grad(n+2) = grad(n+2)+ 2*(y(2)-1);
grad = grad+gc;
end

% Evaluate hessian
if nargout > 2
    term1sq = term1x.*term1x;
    term1sqy = term1y.*term1y;
    H = zeros(nn,nn) ;
    for k = 1:ndist
        i = I(k); j = J(k);
        if i > j
            H(i,i) = H(i,i)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sq(k))...
                +4*(term22(k)^(-1/2)*term1x(k)).^2;
            H(i,j) = H(i,j) +...
                4*term3(k)*(-term22(k)^(-1/2)+term22(k)^(-3/2)*term1sq(k))...
                -4*(term22(k)^(-1/2)*term1x(k)).^2;    
            H(i,n+i)=H(i,n+i)+4*term1x(k)*...
                (term22(k)^(-1)*term1y(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1y(k));
            H(i,n+j)=H(i,n+j)+4*term1x(k)*...
                (-term22(k)^(-1)*term1y(k)+term3(k)*term22(k)^(-3/2)*term1y(k));
                     
%             H(j,j) = H(j,j) - ...
%                 2*term3(k)*(-term22(k)^(-1/2)+term22(k)^(-3/2)*term1sq(k))...
%                 +2*(term22(k)^(-1/2)*term1x(k)).^2;
            H(j,j)=H(j,j)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sq(k))...
                +4*(term22(k)^(-1/2)*term1x(k)).^2;
            H(j,i) =  H(j,i) +...
                4*term3(k)*(-term22(k)^(-1/2)+term22(k)^(-3/2)*term1sq(k))...
                -4*(term22(k)^(-1/2)*term1x(k)).^2;   
            H(j,n+i)=H(j,n+i)+4*term1x(k)*...
                (-term22(k)^(-1)*term1y(k)+term3(k)*term22(k)^(-3/2)*term1y(k));
            H(j,n+j)=H(j,n+j)+4*term1x(k)*...
                (term22(k)^(-1)*term1y(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1y(k));            
%             H(j,n+i)=H(j,n+i)-2*term1x(k)*...
%                 (term22(k)^(-1)*term1y(k)+term3(k)*(-1/2)*term22(k)^(-3/2)*term1y(k));
%             H(j,n+j)=H(i,n+j)+2*term1x(k)*...
%                 (term22(k)^(-1)*term1y(k)+term3(k)*(-1/2)*term22(k)^(-3/2)*term1y(k));
            
            H(n+i,i)=H(n+i,i)+4*term1y(k)*...
                (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
            H(n+i,j)=H(n+i,j)+4*term1y(k)*...
                (-term22(k)^(-1)*term1x(k)+term3(k)*term22(k)^(-3/2)*term1x(k));
            H(n+i,n+i) = H(n+i,n+i)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                +4*(term22(k)^(-1/2)*term1y(k)).^2;
            H(n+i,n+j) = H(n+i,n+j) -...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                -4*(term22(k)^(-1/2)*term1y(k)).^2;
            
            H(n+j,i)=H(n+j,i)-4*term1y(k)*...
                (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
            H(n+j,j)=H(n+j,j)+4*term1y(k)*...
                (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
            H(n+j,n+i)=H(n+j,n+i) -...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                -4*(term22(k)^(-1/2)*term1y(k)).^2;
            H(n+j,n+j)= H(n+j,n+j)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                +4*(term22(k)^(-1/2)*term1y(k)).^2;
            
            
        end 
    end 
%     H(1,1)=H(1,1)+2;
%     H(2,2)=H(2,2)+2;
%     H(n+1,n+1)=H(n+1,n+1)+2;
%     H(n+2,n+2)=H(n+2,n+2)+2;
end
