function pp=mkpp_AD(breaks,coefs,d)
%MKPP_D Make piecewise polynomial.  
%
% Note that: Same functionality and interface with mkpp.m in
% Matlab.
global tape;

if nargin==2, d = 1; end
coefs=coefs(:).';dlk=length(coefs);l=length(breaks)-1;k=fix(dlk/(d*l)+100*eps);
if (k<=0)|(d*l*k~=dlk)
   error(['Number of polynomial pieces, ' int2str(l) ', is incompatible with number of coefficients, ' int2str(dlk) '.'])
else
   pp.form = 'pp';
   pp.breaks = reshape(breaks,1,l+1);
   pp.coefs = reshape(coefs,d*l,k);
   pp.pieces = l;
   pp.order = k;
   pp.dim = d;
end
