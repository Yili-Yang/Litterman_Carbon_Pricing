function adjssubsref(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
if ~isempty(tape(i).arg2vc)
    [m,n]=size(tape(i).val);
    [m2,n2]=size(tape(tape(i).arg1vc).val);
    if isempty(tape(i).arg3vc)
        len=length(tape(i).arg2vc);
        if (m2==1)
            m2=n2;
        end
        if (max(tape(i).arg2vc) <= m2) || (strcmp(tape(i).arg2vc,':') )
            if ischar(tape(i).arg2vc) && strcmp(tape(i).arg2vc,':')
                tape(tape(i).arg1vc).W = ...
                    tape(tape(i).arg1vc).W + ...
                    reshape(tape(i).W,size(tape(tape(i).arg1vc).W));
            else
                for j=1:len
                    tape(tape(i).arg1vc).W(tape(i).arg2vc(j),:) = ...
                        tape(tape(i).arg1vc).W(tape(i).arg2vc(j),:)+tape(i).W(j,:);
                end
            end
        else
            I=tape(i).arg2vc;
            for j=1:length(I)
                jindex=ceil(I(j)/n2);
                iindex=I(j)-m2*(jindex-1);
                tape(tape(i).arg1vc).W(iindex,jindex,:) = ...
                    tape(tape(i).arg1vc).W(iindex,jindex,:)+tape(i).W(j,:);
            end

        end
    else
        if (ndims(tape(i).W)==3)
            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc) = ...
                tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W;
        else
            if (ndims(tape(tape(i).arg1vc).W)==3)
                if (m==1) && (n~=1)
                    tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)=...
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W';
                else
                    tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)=...
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W;
                end
            else
                if ~strcmp(tape(i).arg2vc,':') && ~strcmp(tape(i).arg3vc,':')
                    if (m==1) && (n~=1)
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc) = ...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W';
                    else
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc) = ...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W;
                    end
                elseif ~strcmp(tape(i).arg2vc,':')
                    p = size(tape(tape(i).arg1vc).val, 1);
                    if p==1
                        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
                    else
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,:) = ...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,:) + ...
                            reshape(tape(i).W,size(tape(tape(i).arg1vc).W(tape(i).arg2vc,:)));
                    end
                else

                    %                     tape(tape(i).arg1vc).W(tape(i).arg3vc) = ...
                    %                         tape(tape(i).arg1vc).W(tape(i).arg3vc) +tape(i).W;
                    if length(tape(tape(i).arg1vc).val) == 1
                        tape(tape(i).arg1vc).W=...
                            tape(tape(i).arg1vc).W+tape(i).W;
                    else

                        tape(tape(i).arg1vc).W(:,tape(i).arg3vc)=...
                            tape(tape(i).arg1vc).W(:,tape(i).arg3vc)+tape(i).W;
                    end
                end

            end

        end

    end
end
