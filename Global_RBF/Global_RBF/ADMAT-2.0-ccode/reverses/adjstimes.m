function adjstimes(i)
%
%
%  04/2007 -- consider the case for row vectors
%  04/2007 -- correct the computation of derivative
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

[m,n]=size(tape(i).val);

if ~isempty(tape(i).arg3vc)
    if tape(i).arg3vc==-1
        x = tape(i).arg1vc;
        if (length(x)==1)
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                tape(i).arg1vc.*tape(i).W;
        elseif (length(tape(tape(i).arg2vc).val)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(x(:).*tape(i).W);
            else
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(sum(x.*tape(i).W));
            end
        else                  % neither is a scalar
            if (m==1) || (n==1)
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tape(i).W .* x(:);
            else
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    tape(i).W .* x;
            end
        end
    else                           % tape(i).arg3vc == -2
        y = tape(i).arg2vc;
        if (length(tape(tape(i).arg1vc).val)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(y(:).*tape(i).W);
            else
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    sum(sum(y.*tape(i).W));
            end
        elseif (length(y)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    y(:).*tape(i).W;
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    y.*tape(i).W;
            end
        else                   % neither is a scalar
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tape(i).W.*y(:);
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tape(i).W .* y;
            end
        end
    end

else                            % both are derivtape objects
    
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    if (length(x)==1)             % x is a scalalr
        if (m==1) || (n==1)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ....
                sum(y(:).*tape(i).W);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                x.*tape(i).W;
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                sum(sum(y.*tape(i).W));
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                x .* tape(i).W;
        end
    elseif (length(y)==1)
        if (m==1) || (n==1)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                y.*tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(x(:).*tape(i).W);
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                y.*tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(sum(x .* tape(i).W));
        end
    else                    % neither is a scalar
        if (m==1) || (n==1)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W.*y(:);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tape(i).W .* x(:);
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W .* y;
            tape(tape(i).arg2vc).W  = tape(tape(i).arg2vc).W + ...
                tape(i).W.*x;
        end
    end
end
