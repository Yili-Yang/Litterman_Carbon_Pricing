function sout=plus(s1,s2)
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
    sout.val=s1+s2.val;
    [m,n]=size(getval(sout.val));
    [m2, n2] = size(getval(s2.val));
    if (m==1) || (n==1)                 % sout.val is a vector
        % sout.deriv = derivtapeH(zeros(length(sout.val), globp),0);
        if m2 == 1 && n2 == 1           % s2.val is a scalar
            sout.deriv=repmat(s2.deriv,length(getval(sout.val)),1);
        else
            sout.deriv=s2.deriv + 0;
        end
    else                         % sout.val is a matrix 
        if length(s1) == 1       % s1 is a scalar
            sout.deriv = s2.deriv + 0;
        elseif length(getval(s2.val)) == 1     % s2.val is a scalar
            for i=1:globp
                sout.deriv(:,:,i) = repmat(s2.deriv(i), m, n);
            end
        else                    % s2.val is a matrix
            sout.deriv=s2.deriv + 0;
        end
    end
    
elseif ~isa(s2,'derivtapeH')
    sout.val=s1.val+s2;
    [m,n]=size(getval(sout.val));
    [m1,n1] = size(getval(s1.val));
    if (m==1) || (n==1)                   % sout.val is a vector
        if m1 == 1 && n1 == 1             % s1.val is a scalar
            sout.deriv = repmat(s1.deriv,length(getval(sout.val)),1);
        else
            sout.deriv = s1.deriv + 0;
        end
    else                        % sout.val is a matrix
        if length(s2)==1        % s2 is a scalar
            sout.deriv = s1.deriv;
        elseif length(getval(s1.val))==1   % s1.val is a scalar
            for i=1:globp
                sout.deriv(:,:,i) = repmat(s1.deriv(i),m,n);
            end
        else                    % s1.val is a matrix
            sout.deriv = s1.deriv + 0;
        end
    end
    
else                     % both are derivtapeH objects
    
    sout.val=s1.val+s2.val;

    [m,n] = size(getval(sout.val));
    m1 = length(getval(s1));
    m2 = length(getval(s2));

    if (m==1) || (n==1)            % sout.val is a vector
        if m1 == 1    % s1.val is a scalar
            sout.deriv = repmat(s1.deriv,m2,1) + ...
                s2.deriv;
        elseif m2 == 1   % s2.val is a scalar
            sout.deriv = s1.deriv + repmat(s2.deriv,m1,1);
        else                % both are vectors
            sout.deriv = s1.deriv + s2.deriv;
        end
    else                        % sout.val is a matrix
        if m1 == 1              % s1.val is a scalar
            for i=1:globp
                sout.deriv(:,:,i)=s1.deriv(i)+s2.deriv(:,:,i);
            end
        elseif m2 == 1          % s2.val is a scalar
            for i=1:globp
                sout.deriv(:,:,i)=s1.deriv(:,:,i)+s2.deriv(i);
            end
        else                    % both are matrices
            sout.deriv=s1.deriv+s2.deriv;
        end
    end

end

sout=class(sout,'derivtapeH');
