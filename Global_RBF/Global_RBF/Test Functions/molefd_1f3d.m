function[val,grad,H] = molefd_1f3d(xx,DM)
%MOLE Test function 3-dimension
%objective function is 1-norm
%   Evaluate the distance function and gradient
%   the molecule problem (3-dimensional). length(xx) = 3n. n is the
%   number of atoms
%
%   INPUT:
%   xx - Current positions of the atoms (in plane).xx(1:n) - first coordinates,
%        xx(n+1:2n) the 2nd coordinates, xx(2*n+1:nn,1) the 3rd coordinates
%   DM - Sparse `distance matrix' containing the known distances.
%        
%   OUTPUT:
%   val - The value of the distance function:
%   grad -  The gradient of the distance function. 
%    H   -  Hessian matrix


[r,s] = size(xx);
if r<s
    xx=xx';
end
nn=length(xx); n = nn/3;
x= xx(1:n,1); y = xx(n+1:2*n,1);z = xx(2*n+1:nn,1);
[I,J,dist] = find(DM);
term1x = x(I) -x(J); term1y = y(I)-y(J); term1z=z(I)-z(J);
term2x = term1x.*term1x; term2y = term1y.*term1y; term2z=term1z.*term1z;
dd = dist;
term22=term2x+term2y+term2z;
term3= term22.^(1/2)-dd;
val = term3'*term3;

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
                grad(2*n+i) = grad(2*n+i) + 4*term3(k)*term22(k)^(-1/2)*term1z(k);
                grad(2*n+j) = grad(2*n+j) - 4*term3(k)*term22(k)^(-1/2)*term1z(k);
        end
    end
end

% Evaluate hessian
if nargout > 2
    term1sq = term1x.*term1x;
    term1sqy = term1y.*term1y;
     term1sqz = term1z.*term1z;
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
            H(i,2*n+i)=H(i,2*n+i)+4*term1x(k)*...
                (term22(k)^(-1)*term1z(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1z(k));
            H(i,2*n+j)=H(i,2*n+j)+4*term1x(k)*...
                (-term22(k)^(-1)*term1z(k)+term3(k)*term22(k)^(-3/2)*term1z(k));
                        
            H(j,j)=H(j,j)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sq(k))...
                +4*(term22(k)^(-1/2)*term1x(k)).^2;
            H(j,i)=H(i,j);
%             H(j,i) =  H(j,i) +...
%                 4*term3(k)*(-term22(k)^(-1/2)+term22(k)^(-3/2)*term1sq(k))...
%                 -4*(term22(k)^(-1/2)*term1x(k)).^2;   
            H(j,n+i)=H(j,n+i)+4*term1x(k)*...
                (-term22(k)^(-1)*term1y(k)+term3(k)*term22(k)^(-3/2)*term1y(k));
            H(j,n+j)=H(j,n+j)+4*term1x(k)*...
                (term22(k)^(-1)*term1y(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1y(k));  
            H(j,2*n+i)=H(j,2*n+i)+4*term1x(k)*...
                (-term22(k)^(-1)*term1z(k)+term3(k)*term22(k)^(-3/2)*term1z(k));
            H(j,2*n+j)=H(j,2*n+j)+4*term1x(k)*...
                (term22(k)^(-1)*term1z(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1z(k));  
                   
            H(n+i,i)=H(i,n+i);
            H(n+i,j)=H(j,n+i);
%             H(n+i,i)=H(n+i,i)+4*term1y(k)*...
%                 (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
%             H(n+i,j)=H(n+i,j)+4*term1y(k)*...
%                 (-term22(k)^(-1)*term1x(k)+term3(k)*term22(k)^(-3/2)*term1x(k));
            H(n+i,n+i) = H(n+i,n+i)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                +4*(term22(k)^(-1/2)*term1y(k)).^2;
            H(n+i,n+j) = H(n+i,n+j) -...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                -4*(term22(k)^(-1/2)*term1y(k)).^2;
            H(n+i,2*n+i)=H(n+i,2*n+i)+4*term1y(k)*...
                (term22(k)^(-1)*term1z(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1z(k));
            H(n+i,2*n+j)=H(n+i,2*n+j)+4*term1y(k)*...
                 (-term22(k)^(-1)*term1z(k)+term3(k)*term22(k)^(-3/2)*term1z(k));
            
          H(n+j,i)=H(i,n+j);
            H(n+j,j)=H(j,n+j);
            H(n+j,n+i)=H(n+i,n+j);
%             H(n+j,i)=H(n+j,i)-4*term1y(k)*...
%                 (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
%             H(n+j,j)=H(n+j,j)+4*term1y(k)*...
%                 (term22(k)^(-1)*term1x(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1x(k));
%             H(n+j,n+i)=H(n+j,n+i) -...
%                 4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
%                 -4*(term22(k)^(-1/2)*term1y(k)).^2;            
            H(n+j,n+j)= H(n+j,n+j)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqy(k))...
                +4*(term22(k)^(-1/2)*term1y(k)).^2;
            H(n+j,2*n+i)=H(n+j,2*n+i)-4*term1y(k)*...
                 (term22(k)^(-1)*term1z(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1z(k));
           H(n+j,2*n+j)=H(n+j,2*n+j)+4*term1y(k)*...
                (term22(k)^(-1)*term1z(k)+term3(k)*(-1)*term22(k)^(-3/2)*term1z(k));
            
            H(2*n+i,i)=H(i,2*n+i);
            H(2*n+i,j)=H(j,2*n+i);
            H(2*n+i,n+i)=H(n+i,2*n+i);
            H(2*n+i,n+j)=H(n+j,2*n+i);
            H(2*n+i,2*n+i) = H(2*n+i,2*n+i)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqz(k))...
                +4*(term22(k)^(-1/2)*term1z(k)).^2;
            H(2*n+i,2*n+j) = H(2*n+i,2*n+j) -...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqz(k))...
                -4*(term22(k)^(-1/2)*term1z(k)).^2;
     
            H(2*n+j,i)=H(i,2*n+j);
            H(2*n+j,j)=H(j,2*n+j);
            H(2*n+j,n+i)=H(n+i,2*n+j);
            H(2*n+j,n+j)=H(n+j,2*n+j);
            H(2*n+j,2*n+i)=H(2*n+i,2*n+j);
            H(2*n+j,2*n+j)= H(2*n+j,2*n+j)+...
                4*term3(k)*(term22(k)^(-1/2)-term22(k)^(-3/2)*term1sqz(k))...
                +4*(term22(k)^(-1/2)*term1z(k)).^2;

            
        end 
    end 
end

