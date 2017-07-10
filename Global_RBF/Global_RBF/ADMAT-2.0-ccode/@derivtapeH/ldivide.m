function sout = ldivide(s1,s2)
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

if ~isa(s1,'derivtapeH')            % s1 is not a derivtapeH object
    sout.val=s1.\s2.val;
    [m, n] = size(getval(sout.val));
     if m == 1 && n == 1           % s2.val is a scalar
        sout.deriv = (1./s1(:)) .* s2.deriv;
     else
         if m == 1 || n == 1       % s2.val is a vector
             tmp = 1./s1;
             if length(tmp) == 1         % s1 is a scalar
                 sout.deriv = tmp .* s2.deriv;
             elseif length(getval(s2)) == 1      % s2.val is a scalar
                 sout.deriv = repmat(tmp(:),1, globp) .* ...
                     repmat(s2.deriv, max(m,n), 1);
             else                                % both are vectors
                 sout.deriv = repmat(tmp(:),1, globp) .* s2.deriv;
             end
         else
             error('derivtapeH is not support matrix ldivide currently.');
         end
     end
elseif ~isa(s2, 'derivtapeH')            % s2 is not a derivtapeH object
    sout.val = s1.val.\s2;
    [m,n] = size(getval(sout.val));
    if m == 1 && n == 1                  % both are scalars
        sout.deriv = -(s2(:)./(s1.val(:).*s1.val(:))) .* s1.deriv;
    else
        if m == 1 || n == 1               % output is a vector
            tmp = -s2(:)./(s1.val(:) .* s1.val(:));
            if length(getval(s1)) == 1        % s1.val is a scalar 
                 sout.deriv = repmat(tmp,1, globp) .* ...
                     repmat(s1.deriv, max(m,n), 1);
            else                              % s1.val is a vector
                 sout.deriv = repmat(tmp,1, globp) .* s1.deriv;
             end
         else
             error('derivtapeH is not support matrix ldivide currently.');
        end
    end
else                    % both are derivtapeH objects
     sout.val = s1.val.\s2.val;
    [m,n] = size(getval(sout.val));
    if m == 1 && n == 1                % output is a scalar
        sout.deriv = (1./s1.val).*s2.deriv - ...
            (s2.val./(s1.val.*s1.val)) .* s1.deriv;
    else
        if m == 1 || n == 1           % output is a vector
             tmp1 = 1./s1.val;
             tmp2 = -s2.val(:)./(s1.val(:) .* s1.val(:));
             if length(tmp1) == 1         % s1.val is a scalar
                 sout.deriv = tmp1 .* s2.deriv + repmat(tmp2,1, globp).*...
                     repmat(s1.deriv, max(m,n), 1);
             elseif length(getval(s2)) == 1         % s2.val is a scalar
                 sout.deriv = repmat(tmp1(:),1, globp) .* ...
                     repmat(s2.deriv, max(m,n), 1) + ...
                     repmat(tmp2(:),1, globp) .* s1.deriv;
             else                            % both are vectors
                 sout.deriv = repmat(tmp1(:),1, globp) .* s2.deriv + ...
                     repmat(tmp2(:),1, globp) .* s1.deriv;
             end
         else
             error('derivtapeH is not support matrix ldivide currently.');
         end
    end       
end

sout=class(sout,'derivtapeH');
