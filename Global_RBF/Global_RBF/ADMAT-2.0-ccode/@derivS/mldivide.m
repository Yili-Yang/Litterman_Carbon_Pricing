function sout=mldivide(s1,s2)
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  04/2007 -- consider all case for matrix division.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=getval(s1)\getval(s2);

if ~isempty(sout.val)
    if ~isa(s1,'derivS')
        m2 = size(s2.val,1);
        if m2 == 1           % s2.val is a row vector
            sout.derivS = s1\s2.derivS;
        else
            sout.derivS = s1\s2.derivS;
        end
    elseif ~isa(s2,'derivS')
        m1 = size(s1.val,1);
        if m1 == 1
            sout.derivS=s1.val\(-s1.derivS'*sout.val);
        else
            sout.derivS=s1.val\(-s1.derivS*sout.val);
        end
    else                      % both s1 and s2 are instances of derivS
        m2=size(s2.val,1);
        if m2==1
            sout.derivS=s1.val\(s2.derivS'-s1.derivS'*sout.val);
        else
            sout.derivS=s1.val\(s2.derivS-s1.derivS*sout.val);
        end
    end
    sout=class(sout,'derivS');
else
    sout=[];
end
