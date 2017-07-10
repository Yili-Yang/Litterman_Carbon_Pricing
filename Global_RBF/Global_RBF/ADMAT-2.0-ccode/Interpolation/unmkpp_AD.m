function [breaks,coefs,l,k,d]=unmkpp_AD(pp)
%UNMKPP Supply details about piecewise polynomial.
%   [BREAKS,COEFS,L,K,D] = UNMKPP(PP) extracts from the piecewise polynomial
%   PP its breaks, coefficients, number of pieces, order and dimension of its
%   target.  PP would have been created by SPLINE or the spline utility MKPP.
%
%   See also MKPP, SPLINE, PPVAL.

%   Carl de Boor 7-2-86
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 5.13 $  $Date: 2002/04/09 00:14:28 $
global tape;
if ~isstruct(pp) % for backward compatibility, permit the former way
                 % of encoding the ppform
   if pp(1)==10
      d = pp(2); l=pp(3); breaks=reshape(pp(3+(1:l+1)),1,l+1);
      k=pp(5+l); coefs=reshape(pp(5+l+(1:d*l*k)),d*l,k);
   else
      error('The input array does not seem to describe a pp function.')
   end
else
   if pp.form=='pp'
      d = pp.dim; l = pp.pieces; breaks = pp.breaks; coefs = pp.coefs;
      k = pp.order;
   else
      error('The input structure does not seem to describe a pp function.')
   end
end

