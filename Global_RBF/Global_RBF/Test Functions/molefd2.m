function[val,grad,H] = molefd2(xx,DM)
%MOLE Test function
%
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
%   val -The value of the distance function:
%      Sum over (i,j) in DM: [(x(i)-x(j))^2 +(y(i)-y(j))^2 -dist^2]^2 and
%      add the term (x(1))^2) +(y(1))^2  + (x(2)-1)^2 +(y(2)-1)^2
%      to force (x(1),y(1)) to zero, (x(2),y(2)) to 1. 
%      It is assumed that DM(1,2) = DM(2,1) = 1;
%      and thereby remove the singularity due to translation/'rotation..
%   grad -  The gradient of the distance function. 
%
%   Evaluate the distance function.
[r,s] = size(xx);
if r<s
    xx=xx';
end
nn=length(xx); n = nn/2;
    x= xx(1:n,1); y = xx(n+1:nn,1);
    [I,J,dist] = find(DM);
    term1x = x(I) -x(J); term1y = y(I)-y(J);
    term2x = term1x.*term1x; term2y = term1y.*term1y;
    dd = dist.*dist;
    term3= term2x+term2y-dd;
    %term3 = term2 - dist.*dist;
    val = term3'*term3;
   val = val + (x(1))^2 + (y(1))^2 +(x(2)-1)^2 +(y(2)-1)^2;
  %   val = val + (x(1)^2+ y(1)^2)^2 +((x(2)-1)^2+(y(2)-1)^2)^2;

%
%   Determine the gradient (update edge by edge
if nargout > 1
    ndist = length(dist); 
    grad = zeros(nn,1);
       for k = 1:ndist
           i = I(k); j = J(k);
           if i > j
              grad(i) = grad(i) +  4*term3(k)*term1x(k);
              grad(j) = grad(j) - 4*term3(k)*term1x(k);
              grad(n+i) = grad(n+i) + 4*term3(k)*term1y(k);
              grad(n+j) = grad(n+j) - 4*term3(k)*term1y(k);
           end
       end
      grad(1) = grad(1) + 2*(x(1)); grad(n+1) = grad(n+1) + 2*(y(1));
      grad(2) = grad(2) +2*(x(2)-1); grad(n+2) = grad(n+2)+ 2*(y(2)-1);
%        grad(1) = grad(1) + 2*(x(1)^2+ y(1)^2)*2*x(1); 
%        grad(n+1) = grad(n+1) + 2*(x(1)^2+ y(1)^2)*2*y(1);
%        grad(2) = grad(2) +2*((x(2)-1)^2+(y(2)-1)^2)*2*(x(2)-1); 
%        grad(n+2) = grad(n+2)+ 2*((x(2)-1)^2+(y(2)-1)^2)*2*(y(2)-1); 
    end 
    
  % Evaluate hessian
  if nargout > 2
      term1sq = term1x.*term1x;
      n=length(x);ndist = length(dist);
      H = sparse(n,n) ;
      for k = 1:ndist
          i = I(k); j = J(k);
          if i > j
              H(i,j) = H(i,j) -8*term1sq(k)-4*term3(k);
              H(j,i) = H(i,j);
              H(i,i) = H(i,i) + 8*term1sq(k) + 4*term3(k);
              H(j,j) = H(j,j) + 8*term1sq(k) + 4*term3(k); 
          end ;
      end ;
      H(1,1)=H(1,1)+2;
      
  end

  

   
end