function adjssubsasgn(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
[m,n]=size(tape(i).val);
if tape(i).arg1vc==0
    if isempty(tape(i).arg4vc)
        if ~isempty(tape(i).arg3vc)
            if (max(tape(i).arg3vc) <= m) || isequal(tape(i).arg3vc,':')
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W(tape(i).arg3vc,:);
            else
                I=tape(i).arg3vc;
                for j=1:length(I)
                    jindex=ceil(I(j)/n);
                    iindex=I(j)-m*(jindex-1);
                    tape(tape(i).arg2vc).W(j,:)= tape(tape(i).arg2vc).W(j,:) + ...
                        tape(i).W(iindex,jindex,:);
                end
            end
        end
    else
        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
            tape(i).W(tape(i).arg3vc,tape(i).arg4vc);
    end

else

    saveW=tape(tape(i).arg1vc).W;
    if isempty(tape(i).arg4vc)
        nnn=length(tape(tape(i).arg1vc).val);
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W(1:nnn,:);
        if ~isempty(tape(i).arg3vc)
            if (max(tape(i).arg3vc) <= length(tape(i).val)) || isequal(tape(i).arg3vc,':')
                index=find(tape(i).arg3vc <= nnn);
                if ~isempty(index)
                    tape(tape(i).arg1vc).W(tape(i).arg3vc(index),:)=...
                        saveW(tape(i).arg3vc(index),:);
                end
                if (length(tape(tape(i).arg2vc).val) ==1) && (length(tape(i).arg3vc) > 1)
                    tape(tape(i).arg2vc).W=...
                        tape(tape(i).arg2vc).W + sum(tape(i).W(tape(i).arg3vc,:));
                else
                    if isequal(tape(i).arg3vc,':')
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                            sum(tape(i).W(tape(i).arg3vc,:));
                    else
                        tape(tape(i).arg2vc).W = ...
                            tape(tape(i).arg2vc).W+tape(i).W(tape(i).arg3vc,:);
                    end
                end
            else
                I=tape(i).arg3vc;
                for j=1:length(I)
                    jindex=ceil(I(j)/n);
                    iindex=I(j)-m*(jindex-1);
                    tape(tape(i).arg2vc).W(j,:) = ...
                        tape(tape(i).arg2vc).W(j,:)+tape(i).W(iindex,jindex,:);
                    tape(tape(i).arg1vc).W(iindex,jindex,:) =...
                        saveW(iindex,jindex,:);
                end
            end
        end
    else
        [p,q]=size(tape(tape(i).arg1vc).val);
        if (ndims(tape(i).W)==3)
            if (p >1) && (q >1)
                tape(tape(i).arg1vc).W = ...
                    tape(tape(i).arg1vc).W + tape(i).W(1:p,1:q,:);
            else
                tape(tape(i).arg1vc).W = ...
                    tape(tape(i).arg1vc).W+squeeze(tape(i).W(1:p,1:q,:));
            end
            if ~isempty(tape(i).arg3vc)
                index=find(tape(i).arg3vc <= p);
                if ~isempty(index)
                    tape(tape(i).arg1vc).W(tape(i).arg3vc(index),tape(i).arg4vc,:) = ...
                        saveW(tape(i).arg3vc(index),tape(i).arg4vc,:);
                end
                if (length(tape(tape(i).arg2vc).val) ==1) && ((length(tape(i).arg3vc) > 1)...
                        || (length(tape(i).arg4vc) > 1))
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                        reshape(sum(sum(tape(i).W(tape(i).arg3vc,tape(i).arg4vc,:))),size(tape(tape(i).arg2vc).W));
                else
                    tape(tape(i).arg2vc).W = ...
                        tape(tape(i).arg2vc).W + ...
                        reshape(tape(i).W(tape(i).arg3vc,tape(i).arg4vc,:),size(tape(tape(i).arg2vc).W));
                end
            end
        else
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
            if ~isempty(tape(i).arg2vc)
                if length(tape(tape(i).arg2vc).val) ==1
                    [p,q]=size(tape(i).val);
                    if p==1
                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            tape(i).W(tape(i).arg4vc,:);
                    else
                        if q == 1
                            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                                tape(i).W(tape(i).arg3vc,:);
                        else
                            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                                sum(sum(tape(i).W(tape(i).arg3vc,tape(i).arg4vc)));
                        end
                    end
                else
                    [p,q]=size(tape(i).val);
                    if p==1

                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            reshape(tape(i).W(tape(i).arg4vc,:),size(tape(tape(i).arg2vc).W));

                    elseif q == 1
                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            reshape(tape(i).W(tape(i).arg3vc,:),size(tape(tape(i).arg2vc).W));
                    else
                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            reshape(tape(i).W(tape(i).arg3vc,tape(i).arg4vc),...
                            size(tape(tape(i).arg2vc).W));
                    end
                end
            end
%                         if ~isempty(tape(i).arg3vc)
%                             index=find(tape(i).arg3vc <= nnn);
%                             if ~isempty(index)
%                                 tape(tape(i).arg1vc).W(tape(i).arg3vc(index),tape(i).arg4vc) = ...
%                                     saveW(tape(i).arg3vc(index),tape(i).arg4vc);
%                             end
%                             if length(tape(tape(i).arg2vc).val) ==1
%                                 p=size(tape(i).val,1);
%                                 if p==1
%                                     tape(tape(i).arg2vc).W = ...
%                                         tape(tape(i).arg2vc).W+tape(i).W(tape(i).arg4vc,:);
%                                 else
%                                     tape(tape(i).arg2vc).W = ...
%                                         tape(tape(i).arg2vc).W + ...
%                                         sum(sum(tape(i).W(tape(i).arg3vc,tape(i).arg4vc)));
%                                 end
%                             else
%                                 p=size(tape(i).val,1);
%                                 if p==1
%                                     tape(tape(i).arg2vc).W = ...
%                                         tape(tape(i).arg2vc).W + ...
%                                         reshape(tape(i).W(tape(i).arg4vc,:),size(tape(tape(i).arg2vc).W));
%                                 else
%                                     tape(tape(i).arg2vc).W = ...
%                                         tape(tape(i).arg2vc).W + ...
%                                         reshape(tape(i).W(tape(i).arg3vc,tape(i).arg4vc),size(tape(tape(i).arg2vc).W));
%                                 end
%                             end
%                         end
        end
    end
end
