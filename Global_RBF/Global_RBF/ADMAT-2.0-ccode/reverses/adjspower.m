function adjspower(i)
%
%
%  04/2007 -- rearrage the program for readibilty
%  04/2007 -- correct the computation of derivative
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

% 
global tape;

[m,n]=size(tape(i).val);

if ~isempty(tape(i).arg3vc)
    if tape(i).arg3vc == -1
        x = tape(i).arg1vc;
        tmp = tape(i).val.*log(x);
        if (length(x)==1)
            if (m==1) || (n==1)
                   tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                       tmp(:).*tape(i).W;
            else                  % output is a matrix
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    tmp.*tape(i).W;
            end
        elseif (length(tape(tape(i).arg2vc).val)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                    sum(tmp(:).*tape(i).W);
            else
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(sum(tmp.*tape(i).W));
            end
        else        % neither is a scalar
            if (m==1) || (n==1)
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tape(i).W.*tmp(:);
            else
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    tape(i).W.*tmp;
            end
        end
    else
        tmp = tape(i).arg2vc.*tape(tape(i).arg1vc).val.^(tape(i).arg2vc-1);
        if (length(tape(tape(i).arg1vc).val)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
                   sum(tmp(:).*tape(i).W);
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(sum(tmp.*tape(i).W));
            end
        elseif (length(tape(i).arg2vc)==1)
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+ ...
                    tmp(:).*tape(i).W;
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tmp.*tape(i).W;
            end
        else                   % neither is a scalar
            if (m==1) || (n==1)
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tape(i).W.*tmp(:);
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tape(i).W.*tmp;

            end

        end
    end
else                      % both are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    tmp1 = tape(i).val.*log(x);
    tmp2 =  y.*x.^(y-1);
    if (length(x)==1)
        if (m==1) || (n==1)           % y is a vector
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(tmp2(:).*tape(i).W);
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tmp1(:).*tape(i).W;
        else            % y is a matrix
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                sum(sum(tmp2.*tape(i).W));
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tmp1.*tape(i).W;
        end
    elseif (length(tape(tape(i).arg2vc).val)==1)
        if (m==1) || (n==1)         % x is a vector
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tmp2(:).*tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ....
                sum(tmp1(:).*tape(i).W);
        else                 % x is a matrix
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tmp2.*tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(sum(tmp1.*tape(i).W));
        end
    else   % neither is a scalar 
        if (m==1) || (n==1)
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W .* tmp2(:);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tape(i).W .* tmp1(:);
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W .* tmp2;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tape(i).W .* tmp1;
        end
    end
end


