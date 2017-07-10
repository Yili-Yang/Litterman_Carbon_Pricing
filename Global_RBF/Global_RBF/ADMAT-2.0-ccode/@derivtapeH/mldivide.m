function sout = mldivide(s1,s2)
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
    sout.val = s1\s2.val;
    n1 = size(s1,2);
    [m2,n2] = size(getval(s2));
    if m2 == 1 &&  n2 == 1   % s2.val is a scalar
        sout.deriv = s1\s2.deriv;
    elseif m2 == 1          % s2.val is a row vector
        if n1 == 1          % s1 is a scalar
            sout.deriv = derivtape(zeros(n2, globp),0);
            for i = 1 : globp
                tmp = s1\(s2.deriv(:,i)');
                sout.deriv(:,i) = tmp';
            end
        else               % s1 is a row vector
            sout.deriv = derivtape(zeros(n1,n2, globp),0);
            for i = 1 : globp
                sout.deriv(:,:,i) = s1\(s2.deriv(:,i)');
            end
        end
    elseif n2 == 1          % s2.val is a column vector
        if n1 == 1          % s1 is a column vector
            sout.deriv = s1\s2.deriv;
        else                % s1 is a matrix
            sout.deriv = s1\s2.deriv;
        end
    else                     % s2.val is a matrix
        error('derivtapeH does not support matrix structure currently.');
    end
elseif ~isa(s2, 'derivtapeH')
    sout.val = s1.val\s2;
    [m1,n1] = size(getval(s1));
    n2 = size(s2,2);
    if m1 == 1 && n1 == 1        % s1.val is a scalar
        if n2 == 1               % s2 is a scalar
            sout.deriv = -s1.val\(s1.deriv * sout.val);
        else                     % s2 is a row vector
            tmp = repmat(sout.val,globp,1);
            tmp = tmp' .* repmat(s1.deriv,length(getval(sout.val)),1);
            sout.deriv = -s1.val.\tmp;
        end
    elseif m1 == 1             % s1.val is a row vector
        if n2 == 1             % s2 is a scalar
            sout.deriv = -s1.val\(sout.val'*s1.deriv);
        else                   % s2 is a row scalar
            sout.deriv = derivtape(zeros(n1,n2,globp),0);
            for i = 1 : globp
                sout.deriv(:,:,i) = -s1.val\(s1.deriv(:,i)'*sout.val);
            end
        end
    elseif n1 == 1             % s1.val is a column vector
        if n2 == 1             % s2 is a column vector
            sout.deriv = -s1.val\(sout.val * s1.deriv);
        else                   % s2 is a matrix
            sout.deriv = -s1.val\(sout.val') * s1.deriv;
        end
    else                       % s1.val is a matrix
          error('derivtapeH does not support matrix structure currently.');
    end
else                          % both are derivtapeH objects
    sout.val = s1.val\s2.val;
    [m1,n1] = size(getval(s1.val));
    n2 = size(getval(s2.val),2);
    if m1 == 1 && n1 == 1       % s1.val is a scalar
        if n2 == 1              % s2.val is a scalar
            sout.deriv = s1.val\s2.deriv - s1.val\(s1.deriv * sout.val);
        else                    % s2.val is a row vector
            tmp = repmat(sout.val, globp,1);
            tmp = tmp' .* repmat(s1.deriv,length(getval(sout.val)),1);
            sout.deriv = -s1.val.\tmp;
            for i = 1 : globp
                tmp = s1.val\(s2.deriv(:,i)');
                sout.deriv(:,i) = sout.deriv(:,i) + tmp';
            end
        end
    elseif m1 == 1             % s1.val is a row vector
        if n2 == 1             % s2.val is a scalar
            sout.deriv = s1.val\s2.deriv - ...
                s1.val\(sout.val'*s1.deriv);
        else                   % s2.val is a row scalar
            sout.deriv = derivtape(zeros(n1,n2,globp),0);
            for i = 1 : globp
                sout.deriv(:,:,i) = s1.val\(s2.deriv(:,i)') - ...
                    s1.val\(s1.deriv(:,i)'*sout.val);
            end
        end
    elseif n1 == 1             % s1.val is a column vector
        if n2 == 1             % s2.val is a column vector
            sout.deriv = s1.val\s2.deriv - s1.val\(sout.val * s1.deriv);
        else                   % s2.val is a matrix
            error('derivtapeH does not support matrix structure currently.');
        end
    else                       % s1.val is a matrix
          error('derivtapeH does not support matrix structure currently.');
    end
end
        
sout = class(sout, 'derivtapeH');