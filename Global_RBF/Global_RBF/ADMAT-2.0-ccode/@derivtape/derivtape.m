function s= derivtape(a,b)
%
%
% DERIVTAPE  --  Construct DERIVTAPE Objects
%
%   S=derivtape(a) constructs the object S, of class derivtape from a.
%   If the input argument is a numerical scalar or matrix, the
%   result is a deriv object having the same value.
%   Derivtape objects are constructed in preparation for the reverse
%   mode of Automatic Differentiation, where we need to store the
%   intermediate values. These objects get assigned a unique
%   idenitifer number, in order to effectively store them on tape.
%
%   If input is a derivtape object, it is returned as it is.
%
%   Also see getval, getydot, deriv, derivspj, derivsph
%
%
%   March, 2007 -- save the derivtape object to the tape only when 
%                  nargin == 2, which avoids the implicit recursion
%                  when calling class(s, 'derivtape')
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;
global tape_begin;
% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end

%
%
if nargin==0   
    s.val=0;
    s.varcount=varcounter;
    s=class(s,'derivtape');
else
    if isempty(a)
        s.val=[];
        s.varcount=varcounter;
        s=class(s,'derivtape');       
    else
        if isa(a,'derivtape')
            s=a;
        else
            if isa(a,'derivtapeH')
                error('Cannot be derivtapeH variable');
            else
                s.val=a;
                s.varcount=varcounter;
                s=class(s,'derivtape');
            end
        end
    end
end

if nargin == 2
    if b == 1
        tape_begin = varcounter;
    end
    savetape(' ', s, 0,0);
end
