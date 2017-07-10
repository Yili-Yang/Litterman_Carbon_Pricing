function sout = power(s1,s2)
%
%
% 05/2007 -- limited the case that input, 's1' is a scalar or vector. 
%            The matrix case will involve 4-dimensional arrary in the
%            computation, which is not supported in 'reverse' folder.
% 05/2007 -- seperatet the cases for one of s1 and s2 is not  a derivtapeH
%            object.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if ~isa(s1,'derivtapeH')
    sout.val = s1.^s2.val;
    [m,n] = size(getval(sout.val));
    val2 = sout.val.*log(s1);
    if m == 1 && n == 1
        sout.deriv = val2 .* ...
                s2.deriv;
    elseif (m==1) || (n==1)
        tmp = val2(:);
        if length(s2.val) == 1       % s2.val is a scalar
            sout.deriv =  repmat(tmp, 1,globp).* ...
                repmat(s2.deriv, length(sout.val),1);
        else
            sout.deriv = repmat(tmp, 1,globp) .* s2.deriv;
        end
    else
        if length(s1)==1
            for i=1:globp
                sout.deriv(:,:,i)= val2.*s2.deriv(:,:,i);
            end
        elseif length(s2.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val2.*s2.deriv(i);
            end

        else
            sout.deriv=val2.*s2.deriv;
        end
    end

elseif ~isa(s2,'derivtapeH')
    sout.val=s1.val.^s2;
    [m,n]=size(getval(sout.val));
    [m2,n2]=size(getval(s1.val));
    val1=s2.*(s1.val.^(s2-1));

    if m == 1 && n == 1
        sout.deriv = val1.*s1.deriv;
    elseif (m==1) || (n==1)            % sout.val is a vector
        val1 = val1(:);
        if (m2>1) || (n2>1)
            sout.deriv=repmat(val1,1,globp).*s1.deriv;
        else                   % s1.val is a scalar
            sout.deriv = repmat(val1,1, globp) .* ...
                repmat(s1.deriv, length(s2),1);
        end
    else                          % sout.val is a matrix
        if length(s1.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(i);
            end
        elseif length(s2)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i);
            end
        else
            sout.deriv=val1.*s1.deriv;
        end
    end
    
else                           % both s1 and s2 are derivtapeH
    sout.val=s1.val.^s2.val;
    [m,n]=size(getval(sout.val));
    
    val1=s2.val.*(s1.val.^(s2.val-1));
    val2=sout.val.*log(s1.val);
    if m == 1 && n == 1
         sout.deriv = val1 .* s1.deriv + ...
                val2 .* s2.deriv;
    elseif (m==1) || (n==1)          % sout.val is a vector
        val1 = val1(:);
        val2 = val2(:);
        m1 = length(s1.val);
        m2 = length(s2.val);
        if m1 == 1              % s1.val is a scalar
            sout.deriv = repmat(val1, 1, globp) .* repmat(s1.deriv, m2,1) + ...
                repmat(val2, 1, globp) .* s2.deriv;
        elseif m2 == 1
            sout.deriv = repmat(val1, 1, globp) .* s1.deriv + ...
                repmat(val2, 1, globp) .* repmat(s2.deriv,m1,1);
        else
             sout.deriv = repmat(val1, 1, globp) .* s1.deriv + ...
                repmat(val2, 1, globp) .* s2.deriv;
        end

    else                         % sout.val is a matrix
        if length(s1.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(i)+...
                    val2.*s2.deriv(:,:,i);
            end
        elseif length(s2.val)==1
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i)+...
                    val2.*s2.deriv(i);
            end
        else
            for i=1:globp
                sout.deriv(:,:,i)=val1.*s1.deriv(:,:,i)+...
                    val2.*s2.deriv(:,:,i);
            end
        end
    end
end

sout=class(sout,'derivtapeH');
