function sout = times(s1,s2)
%
%
% 05/2007 -- limited the case that input, 's1' is a scalar or vector. 
%            The matrix case will involve 4-dimensional arrary in the
%            computation, which is not supported in 'reverse' folder.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if ~isa(s1,'derivtapeH')
    sout.val=s1.*s2.val;
    [m,n]=size(getval(sout.val));
    m1 = length(s1);
    m2 = length(s2.val);
    
    if (m==1) || (n==1)         % sout.val is a vector
        tmp = s1(:);
        if m1 == 1
            sout.deriv = tmp .* s2.deriv;
        elseif m2 == 1
            sout.deriv = repmat(tmp, 1, globp) .* ...
                repmat(s2.deriv, m1, 1);
        else
            sout.deriv = repmat(tmp,1, globp) .* ...
                s2.deriv;
        end
    else                       % sout.val is a matrix
        if length(s1)==1
            sout.deriv = s1.*s2.deriv;
        elseif length(getval(s2))==1
            for i=1:globp
                sout.deriv(:,:,i) = s1.*s2.deriv(i);
            end
        else
            sout.deriv = repmat(s1,[1 1 globp]) .* s2.deriv;
        end
    end

elseif ~isa(s2,'derivtapeH')
    
    sout.val=s1.val.*s2;
    [m,n]=size(getval(sout.val));
     m1 = length(s1.val);
     m2 = length(s2);
    if (m==1) || (n==1)              % sout.val is a vector
       tmp = s2(:);
        if m2 == 1
            sout.deriv = tmp .* s1.deriv;
        elseif m1 == 1
            sout.deriv = repmat(tmp, 1, globp) .* ...
                repmat(s1.deriv, m2, 1);
        else
            sout.deriv = repmat(tmp,1, globp) .* ...
                s1.deriv;
        end
    else                           % sout.val is a matrix
        if length(getval(s1.val))==1
            for i=1:globp
                sout.deriv(:,:,i) = s2.*s1.deriv(i);
            end
        elseif length(s2)==1
            sout.deriv = s2.*s1.deriv;
        else
            sout.deriv=repmat(s2,[1 1 globp]).*s1.deriv;
        end
    end

else            %  both are derivtapeH objects
    sout.val=s1.val.*s2.val;
    [m,n]=size(getval(sout.val));
    m1 = length(getval(s1.val));
    m2 = length(getval(s2.val));
    
    if ((m==1) || (n==1))    % sout.val is a vector
        val1 = s1.val(:);
        val2 = s2.val(:);
        if m1 == 1           % s1.val is a scalar
            sout.deriv = repmat(val2, 1,globp) .* repmat(s1.deriv, m2,1) + ...
                s1.val .* s2.deriv;
        elseif m2 == 1       % s2.val is a scalar
             sout.deriv = s2.val .* s1.deriv + ...
                repmat(val1, 1, globp) .* repmat(s2.deriv, m1,1);
        else                 % both are vectors
%             if m == 1 && n>2   % row vectors
%                 sout.deriv = repmat(val2,globp,1) .* s1.deriv + ...
%                 repmat(val1, globp,1) .* s2.deriv;
%             else
            sout.deriv = repmat(val2,1, globp) .* s1.deriv + ...
                repmat(val1, 1, globp) .* s2.deriv;
            % end
        end
    else                 % sout.val is a matrix
        if length(getval(s1))==1
            for i=1:globp
                sout.deriv(:,:,i)=s2.val.*s1.deriv(i)+...
                    s1.val.*s2.deriv(:,:,i);
            end
        elseif length(getval(s2))==1
            for i=1:globp
                sout.deriv(:,:,i)=s2.val.*s1.deriv(:,:,i)+...
                    s1.val.*s2.deriv(i);
            end
        else
            for i=1:globp
                sout.deriv(:,:,i)=s2.val.*s1.deriv(:,:,i)+...
                    s1.val.*s2.deriv(:,:,i);
            end
        end
    end
end

sout=class(sout,'derivtapeH');
