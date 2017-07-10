function [c, p] = blkprice(f, x, r, t, sig)
global tape;
%BLKPRICE Black's option pricing.
%
%   [C, P] = BLKPRICE(F, X, R, T, SIG)
%
%   Summary: 
%     This function uses Black's Model to determine the call and put option 
%     values on futures given a forward price, strike price, risk free interest 
%     rate, time to maturity, and volatility.
%
%   Inputs: 
%     F   - value for the forward price of the underlying asset at time zero
%     X   - value for the strike price of the call and put options
%     R   - value for the risk free interest rate (plus storage costs less
%           less any convenience yield)
%     T   - value for the time to maturity or expiry of the option
%     SIG - value for the volatility of the price of the underlying asset
%
%   Outputs: C - Price of the call option
%            P - Price of the put option
%
%   Notes: 
%     Make sure that R and T are of the same time base; that is, if  
%     R is an annualized rate, T must be expressed in years.  
%
%     Black's Model can be extended to value interest rate derivatives in
%     the form of call and put options embedded in bonds by deriving the
%     forward price as follows:
%
%     f = (B - I) * exp(R*t)
%
%     where
%                    
%     B - the face value of the bond
%     I - the present value of the coupons during the life of the option
%         (i.e. from time zero until expiry of the option)
%     R - the riskless rate (plus storage costs less any convenience yield)
%     t - time from time zero until expiry of the option
%
%
%   Example: 
%     [c, p] = blkprice(95, 98, 0.11, 3, 0.025)
%
%     returns:
%
%     c = 0.4162 (or $0.42)
%     p = 2.5729 (or $2.57)
%
%   See also BINPRICE, BLSPRICE.
%
% References: 1) John C. Hull, Options, Futures, and Other Derivative Securities, 
%                     2nd edition.  Formulas 15.7 and 15.8.
%             2) F. Black, "The Pricing of Commodity Contracts," Journal of Financial
%                     Economics, March 3, 1976, pp. 167-79.
%              

%   Author(s): C.F. Garvin and M. Reyes-Kattar, 12-26-95
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $   $Date: 2002/03/11 19:19:05 $
 
% Checking input arguments
if nargin < 5 
  error(sprintf('Missing one of F, X, R, T and SIG!')) 
end 

if any(f <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0) 
  error(sprintf('Enter F, X, and T > 0. Enter R and SIG >= 0!')) 
end 

%Get the size of all input arguments; scale up any scalars
sz = [size(f); size(x); size(r); size(t); size(sig)]; 

if (length(f) == 1)
     f = f * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(x) == 1)
     x = x * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(r) == 1)
     r = r * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(t) == 1)
     t = t * ones(max(sz(:,1)), max(sz(:,2))); 
end

if (length(sig) == 1)
     sig = sig * ones(max(sz(:,1)), max(sz(:,2)));
end


%Make sure all input arguments are of the same size and shape
if (checksiz([size(f); size(x); size(r); size(t); size(sig)], mfilename))
     return
end 


%Get the shape of the inputs in order to reshape the output
[RowSize, ColumnSize] = size(f);

% prevent divide by zero warning : the functions do the right thing
Warnstate = warning;
warning('off');

d1 = (log(f./x)+sig.^2.*t/2)./(sig.*sqrt(t));
d2 = d1 - sig.*sqrt(t);
c = exp(-r.*t).*(f.*normcdf(d1)-x.*normcdf(d2));
% p = exp(-r.*t).*(x.*normcdf(-d2)-f.*normcdf(-d1));


c = reshape(c, RowSize, ColumnSize);
% p = reshape(p, RowSize, ColumnSize);

% set warning state back
warning(Warnstate);

%end of function

