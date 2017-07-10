function [s,val,posdef,itfun2,lambda] = trust3(g,H,delta)
%TRUST	Exact soln of trust region problem
%
% [s,val,posdef,count,lambda] = TRUST(g,H,delta) Solves the trust region
% problem: min{g^Ts + 1/2 s^THs: ||s|| <= delta}. 
% INITIALIZATION
posdef=0;
tol = 10^(-12); 
tol2 = 10^(-8);
toleig=.0001;
toleq=.0001;
key = 0; 
itbnd = 50;
lambda = 0;
n = length(g); 
coeff(1:n,1) = zeros(n,1);
H = full(H);
[V,D] = eig(H); 
itfun=0;
itfun2=0;
eigval = diag(D); 
[mineig,jmin] = min(eigval);
vmin=V(:,jmin);
alpha = -V'*g;
tol_zero=eps;
%tol_zero=1e-2
%sig = sign(alpha(jmin)) + (alpha(jmin)==0



% POSITIVE DEFINITE CASE
if mineig > 0
   %s=-H\g;
   RR=chol(H);
   st=RR'\g;
   s=-RR\st;
   itfun2=itfun2+1;
   nrms = norm(s);
   posdef=1;
   if nrms <= 1.2*delta
      key = 1;
      lambda = 0;
   else 
       key = 2;
      laminit = 0;
      % compute newton step
      strial=s;
      lamnewt=0;
      nrmst=nrms;
      fval=(1/delta)-(1/nrmst);
      i=0;
     while (fval>toleq) & (i<10)
          sx=strial/nrmst;
         % numx=sx'*(H\sx);
         ssx=RR'\sx;
         stx=RR\ssx;
         numx=sx'*stx;
          dx=-numx/nrmst;
          step=(1/nrmst-1/delta)/dx;
          lamnewt=step+lamnewt;
          %strial=-(H+lamnewt*eye(n))\g;
          HH= H+lamnewt*eye(n);
          R=chol(HH);
          st= -R'\g;
          strial=R\st;
          ifun2=itfun2+1;
          nrmst=norm(strial);
          fval=(1/delta)-(1/nrmst);
          i=i+1;
     end
      I=i;
      FVAL=fval;
      %
      %[b,c,itfun]=rfzero2('seceqn2',0,itbnd,delta,g,H,tol_zero);
      %lambda=b;
      lambda=lamnewt;
      newlam = lambda;
     % s=-(H+lambda*eye(n))\g;
     s=strial;
   end
else
   laminit = -mineig; 
   posdef = 0;
end

% INDEFINITE CASE
if key == 0
    laminit=-mineig + 100*toleig;
    %laminit=-5*mineig +toleig;
    %ss=-(H+laminit*eye(n))\g;
    HH= H+laminit*eye(n);
          R=chol(HH);
          st= R'\g;
          ss=-R\st;
          itfun2=itfun2+1;
    if norm(ss) > delta
      % compute newton step
      strial = ss;
      lamnewt=laminit;
      nrmss=norm(ss);
      nrmst=nrmss;
      fval=(1/delta)-(1/nrmst);
      i=0;
      while (fval>toleq) & (i<10)
          sx=strial/nrmst;
          stx=R'\sx;
          sttx=R\stx;
          numx=sx'*sttx;
          dx=-numx/nrmst;
          step=(1/nrmst-1/delta)/dx;
          lamnewt=lamnewt+step;
          %strial=-(H+lamnewt*eye(n))\g;
          HH= H+lamnewt*eye(n);
          R=chol(HH);
          st= -R'\g;
          strial=R\st;
          itfun2=itfun2+1;
          nrmst=norm(strial);
          fval=(1/delta)-(1/nrmst);
          i=i+1;
      end
      I=i;
      FVAL=fval;
      %
        
        %[b,c,itfun]=rfzero2('seceqn2',laminit,itbnd,delta,g,H,tol_zero);
        %lambda = b;
        lambda=lamnewt;
        oldlam=laminit;
        newlam=lambda;
        %s=-(H+lambda*eye(n))\g;
        s=strial;
        key = 3;
    else
        if g'*vmin>0
            vmin=-vmin;
        end
        tau=-ss'*vmin+sqrt((ss'*vmin)^2-(ss'*ss-delta^2));
        s = ss+tau*vmin;
        lambda=laminit;
        key = 4;
    end
end
val = g'*s + (.5*s)'*(H*s);
