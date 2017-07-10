function output = spline_AD(x,y,xx)
%SPLINE_AD Cubic spline data interpolation.
%
% Note that: Same functionality and interface with spline.m in Matlab.

global tape;

output=[];
n=length(x);
if n<2, error('There should be at least two data points.'), end

if any(diff(x)<0), [x,ind]=sort(x); else, ind=1:n; end

x=x(:); dx = diff(x);
if all(dx)==0, error('The data abscissae should be distinct.'), end

[yd,yn] = size(y); % if Y happens to be a column matrix, change it to 
                   % the expected row matrix.
if yn==1, yn=yd; y=reshape(y,1,yn); yd=1; end

if yn==n
   notaknot = 1;
elseif yn==n+2
   notaknot = 0; endslopes = y(:,[1 n+2]).'; y(:,[1 n+2])=[];
else
   error('Abscissa and ordinate vector should be of the same length.')
end

yi=y(:,ind).'; dd = ones(1,yd);
dx = diff(x); divdif = diff(yi)./dx(:,dd);
if n==2
   if notaknot, % the interpolant is a straight line
      pp=mkpp_AD(x.',[divdif.' yi(1,:).'],yd);
   else         % the interpolant is the cubic Hermite polynomial
      divdif2 = diff([endslopes(1,:);divdif;endslopes(2,:)])./dx([1 1],dd);
      pp = mkpp_AD(x,...
      [(diff(divdif2)./dx(1,dd)).' ([2 -1]*divdif2).' ...
                                           endslopes(1,:).' yi(1,:).'],yd);
   end
elseif n==3&notaknot, % the interpolant is a parabola
   yi(2:3,:)=divdif;
   yi(3,:)=diff(divdif)/(x(3)-x(1));
   yi(2,:)=yi(2,:)-yi(3,:)*dx(1);
   pp = mkpp_AD([x(1),x(3)],yi([3 2 1],:).',yd);
else % set up the sparse, tridiagonal, linear system for the slopes at  X .
   b=zeros(n,yd);
   b(2:n-1,:)=3*(dx(2:n-1,dd).*divdif(1:n-2,:)+dx(1:n-2,dd).*divdif(2:n-1,:));
   if notaknot
      x31=x(3)-x(1);xn=x(n)-x(n-2);
      b(1,:)=((dx(1)+2*x31)*dx(2)*divdif(1,:)+dx(1)^2*divdif(2,:))/x31;
      b(n,:)=...
      (dx(n-1)^2*divdif(n-2,:)+(2*xn+dx(n-1))*dx(n-2)*divdif(n-1,:))/xn;
   else
      x31 = 0; xn = 0; b([1 n],:) = dx([2 n-2],dd).*endslopes;
   end
   c = spdiags([ [dx(2:n-1);xn;0] ...
        [dx(2);2*[dx(2:n-1)+dx(1:n-2)];dx(n-2)] ...
        [0;x31;dx(1:n-2)] ],[-1 0 1],n,n);

   % sparse linear equation solution for the slopes
   mmdflag = spparms('autommd');
   spparms('autommd',0);
   s=c\b;
   spparms('autommd',mmdflag);
   % convert to pp form
   c4=(s(1:n-1,:)+s(2:n,:)-2*divdif(1:n-1,:))./dx(:,dd);
   c3=(divdif(1:n-1,:)-s(1:n-1,:))./dx(:,dd) - c4;
   pp=mkpp_AD(x.', ...
      reshape([(c4./dx(:,dd)).' c3.' s(1:n-1,:).' yi(1:n-1,:).'], ...
               (n-1)*yd,4),yd);
end
if nargin==2
   output=pp;
else
   output=ppval_AD(pp,xx);
end

