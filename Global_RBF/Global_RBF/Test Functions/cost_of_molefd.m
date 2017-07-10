function[val,grad,H] = molefd(x,DM)
%MOLE Test function
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
%      Sum over (i,j) in DM: [(x(i)-x(j))^2 -dist^2]^2 and
%      add the term (x(1)-1)^2) to force x(1) to 1 (arbitrarily)
%      and thereby remove the singularity due to translation.
%   grad -  The gradient of the distance function. 
%
%   Evaluate the distance function.
[r,s] = size(x);
if r<s
    x=x';
end
    [I,J,dist] = find(DM);
    term1 = x(I) -x(J);
    term2 = term1.*term1;
    dd = dist.*dist;
    term3= term2-dd;
    %term3 = term2 - dist.*dist;
    val = term3'*term3;
%     val = val + (x(1)-1)^2;
%
%   Determine the gradient (update edge by edge

[fc, gc] = fcost(x);
% w = val/fc;
w= 100;
fc = w*fc;
gc = w*gc;
val = fc+val;


if nargout > 1
    ndist = length(dist); n = length(x);
    grad = zeros(n,1);
       for k = 1:ndist
           i = I(k); j = J(k);
           if i > j
              grad(i) = grad(i) +  8*term3(k)*term1(k);
              grad(j) = grad(j) - 8*term3(k)*term1(k);
           end
        end
%         grad(1) = grad(1) + 2*(x(1)-1);
    grad = gc+grad;
end

    
  % Evaluate hessian
  if nargout > 2
      term1sq = term1.*term1;
      n=length(x);ndist = length(dist);
      H = zeros(n,n);
      for k = 1:ndist
          i = I(k); j = J(k);
          if i > j
              H(i,j) = H(i,j) -16*term1sq(k)-8*term3(k);
              H(j,i) = H(i,j);
              H(i,i) = H(i,i) + 16*term1sq(k) + 8*term3(k);
              H(j,j) = H(j,j) + 16*term1sq(k) + 8*term3(k);
          end ;
      end ;
%       H(1,1)=H(1,1)+2;
      
  end

  

   
end
