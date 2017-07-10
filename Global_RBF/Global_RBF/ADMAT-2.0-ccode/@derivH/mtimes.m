function sout=mtimes(s1,s2)
%
% 
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  March, 2007 -- reorganized the program for readibility
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val = getval(s1)*getval(s2);


if ~isempty(sout.val)
    [m1,n1]=size(getval(s1));
    [m2,n2]=size(getval(s2));   
    
    if (~isa(s1,'derivH'))              % s1 doesn't belong to derivH
        if ((m1>1)&&(n1>1))             % s1 is a matrix
            sout.derivH = s1*s2.derivH;
        elseif ((m2>1)&&(n2>1))         % s2.val is a matrix
            sout.derivH = s2.derivH'*s1';
        else
            if ((length(s1)==1) || (length(s2.val)==1))       % either s1 or s2.val is a scalar
                q=s1.*s2.derivH;
                sout.derivH=q(:);
            elseif (m1 == 1)                  
                %Inner product
                sout.derivH=s1*s2.derivH;
            else
                %outer product
                sout.derivH=s1*s2.derivH';
            end
        end


    elseif  (~isa(s2,'derivH'))        % s2 doesn't belong to derivH
        if ((m1>1) && (n1>1))          % s1.val is a matrix
            sout.derivH = s1.derivH*s2;
        elseif ((m2>1) && (n2>1))      % s2 is a matrix
            sout.derivH = s2' * s1.derivH;
        else
            if ((length(s1.val)==1) || (length(s2)==1))         % either s1.val or s2 is a scalar 
                p=s2.*s1.derivH;
                sout.derivH=p(:);
            elseif (m1 == 1)
                %Inner product
                sout.derivH=s2'*s1.derivH;
            else
                %outer product
                sout.derivH=s1.derivH*s2;
            end
        end
        
    else                             % both s1 and s2 belong to derivH    
        s1val = getvalue(s1);
        s2val = getvalue(s2);
        if ((m1>1) && (n1>1))        % s1.val is a matrix
            sout.derivH=s1.derivH*s2val + s1val*s2.derivH;
        elseif ((m2>1) && (n2>1))    % s2.val is a matrix
            sout.derivH=s2val'* s1.derivH + s2.derivH'*s1val';
        else
            if ((length(s1.val)==1) || (length(s2.val)==1))      % either s1.val or s2.val is a scalar
                p=s2val.*s1.derivH;
                q=s1val.*s2.derivH;
                sout.derivH=p(:)+q(:);
            elseif (m1 == 1)
                %Inner product
                sout.derivH=s2val'*s1.derivH+s1val*s2.derivH;
            else
                %outer product
                sout.derivH=s1.derivH*s2val+s1val*s2.derivH';
            end
        end
    end
end

sout = class(sout, 'derivH');
