function s= derivH(a,V)
%
% DERIVH Class 
%
%        Constructor of DERIVH Class
%
%      There are three fields in the derivH class, val of the function,
%   its first derivative and its second derivatives.
%      .val -- value of the function
%      .derivH -- an instance of deriveH class.
%             .derivH.val -- first derivative of the function
%             .derivH.derivS -- second derivative of the function.
% 
%   when computing the first and second derivatives of the function, we
%   compute the first derivative of the function with the input as an
%   instance of derivS class. 
%
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  March, 2007 -- documentation was added
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin==0
    s.val=0;
    s.derivH = derivS;
    s=class(s,'derivH');
else
    if isempty(a)
        s.val=[];
        s.derivH=derivS([]);
        s=class(s,'derivH');
    elseif isa(a,'derivH')
        s=a;
    else
        s.val=a;
        m=size(a);
        if (length(m)==2)
            n=m(2);
            m=m(1);
            if ((m==1) && (n==1))
                s.derivH=derivS(0);
            elseif (m==1)
                s.derivH=derivS(zeros(n,1));
            elseif (n==1)
                s.derivH=derivS(zeros(m,1));
            else
                s.derivH=derivS(zeros(m,n));
            end

        else
            s.derivH=derivS(zeros(m));
        end
        s=class(s,'derivH');
    end
    if nargin==2
        s.derivH=derivS(V);
    end
end
