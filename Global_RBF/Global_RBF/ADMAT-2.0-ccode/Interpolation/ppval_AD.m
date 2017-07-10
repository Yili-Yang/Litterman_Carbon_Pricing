function v=ppval_AD(pp,xx)
%PPVAL_AD  Evaluate piecewise polynomial.
%
% Note that: Same functionality and interface with ppval.m in
% Matlab.
global tape;

if isstruct(xx) % we assume that ppval(xx,pp) was used
   temp = xx; xx = pp; pp = temp;
end

[mx,nx] = size(xx); lx = mx*nx; xs = reshape(xx,1,lx);
% if necessary, sort xx 
tosort=0;
if any(diff(xs)<0)
   tosort=1;[xs,ix]=sort(xs);
end

% take apart pp
[x,c,l,k,d]=unmkpp_AD(pp);

% for each data point, compute its breakpoint interval
[ignored,index] = sort([x(1:l) xs]);
index = max([find(index>l)-(1:lx);ones(1,lx)]);

% now go to local coordinates ...
xs = xs-x(index);

d = getval(d);
if d>1 % ... replicate xs and index in case pp is vector-valued ...
    lx = getval(lx);
   xs = reshape(xs(ones(d,1),:),1,d*lx);
   index = d*index; temp = [-d:-1].';
   
   index = reshape(1+index(ones(d,1),:)+temp(:,ones(1,lx)), d*lx, 1 );
end

% ... and apply nested multiplication:
   v = c(index,1).';
   for i=2:k
      v = xs.*v + c(index,i).';
   end

v = reshape(v,d,lx);
if tosort>0, v(:,ix) = v; end
v = reshape(v,d*mx,nx);
