function sout=mtimes(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;


if ~isa(s1, 'derivtapeH')
    sout.val = s1 * s2.val;
    [m1,n1] = size(s1);
    [m2,n2] = size(getval(s2.val));
    if ((m1>1) && (n1>1))            % s1 is a matrix
        if m2 > 1 && n2 == 1        % s2.val is a scalar
            sout.deriv = s1 * s2.deriv;
        else
            error('derivtapeH does not support matrix operation currently');
        end
    elseif m1 > 1 && n1 == 1         % s1 is a column vector
        if m2 == 1 && n2 == 1        % s2.val is a scalar
            sout.deriv = s1 * s2.deriv;
        else                   % s2.val is a row vector
            error('derivtapeH does not support outer productor currently');
        end
    elseif m1 == 1 && n1 > 1         % s1 is a row vector
        if m2 == 1 && n2 == 1        % s2.val is a scalar
            sout.deriv = s1' * s2.deriv;
        elseif m2 > 1 && n2 == 1     % inner product
            sout.deriv = s1 * s2.deriv;
        else                         % s2.val is a matrix
            error('derivtapeH does not support matrix operation currently');
        end
    else                             % s1 is a scalar
        sout.deriv = s1 * s2.deriv;
    end
elseif ~isa(s2, 'derivtapeH')
    sout.val = s1.val * s2;
    [m1,n1] = size(getval(s1));
    [m2,n2] = size(s2);
    if m1 > 1 && n1 > 1             % s1.val is a matrix
        error('derivtapeH does not support matrix operation currently');
    elseif m1 > 1 && n1 == 1        % s1.val is a column vector
        if m2 == 1 && n2 == 1       % s2 is a scalar
            sout.deriv = s1.deriv * s2;
        else                        % s2 is a row vector
            error('derivtapeH does not support outer productor currently');
        end
    elseif m1 == 1 && n1 > 1        % s1.val is a row vector
        if m2 == 1 && n2 == 1       % s2 is a scalar
            sout.deriv = s1.deriv * s2;
        elseif m2 > 1 && n2 == 1       % s2 is a column vector
            sout.deriv = s2' * s1.deriv;
        else                        % s2 is a matrix
            sout.deriv = s2'*s1.deriv;
        end
    else                            % s1 is a scalar
        if m2 > 1 && n2 >1
            error('derivtapeH does not support outer productor currently');
        else
            s2 = s2(:);
            sout.deriv = repmat(s1.deriv, length(s2),1) .* ...
                repmat(s2, 1, globp);
        end
    end
else                                % both are derivtapeH objects
    sout.val = s1.val * s2.val;
    [m1,n1] = size(getval(s1));
    [m2,n2] = size(getval(s2));
    if m1 > 1 && n1 > 1             % s1.val is a matrix
        error('derivtapeH does not support matrix operation currently');
    elseif m1 > 1 && n1 == 1        % s1.val is a column vector
        if m2 == 1 && n2 == 1
            sout.deriv = s1.val * s2.deriv + s2.val * s1.deriv;
        else                    % outer product
            error('derivtapeH does not support outer productor currently');
        end
    elseif m1 == 1 && n1 > 1        % s1.val is a row vector
        if m2 == 1 && n2 == 1       % s2.val is a scalar
            sout.deriv = s1.val' * s2.deriv + s2.val * s1.deriv;
        elseif m2 > 1 && n2 == 1    % s2.val is a column vector
            sout.deriv = s1.val * s2.deriv + s2.val' * s1.deriv;
        else
            error('derivtapeH does not support matrix operation currently');
        end
    else                            % s1.val is a scalar
        if m2 == 1 && n2 == 1         % s2.val is a scalar
            sout.deriv = s1.val * s2.deriv + s2.val * s1.deriv;
        elseif m2 == 1 || n2 == 1     % s2.val is a vector
            sout.deriv = s1.val * s2.deriv + s2.val(:) * s1.deriv;
        else                       % s2.val is a matrix
            error('derivtapeH does not support matrix operation currently');
        end
    end

end

sout = class(sout, 'derivtapeH');