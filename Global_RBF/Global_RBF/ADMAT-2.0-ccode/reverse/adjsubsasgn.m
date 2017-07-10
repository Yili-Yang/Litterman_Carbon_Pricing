function adjsubsasgn(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n]=size(tape(i).val);
if tape(i).arg1vc==0
    if isempty(tape(i).arg4vc)
        if ~isempty(tape(i).arg3vc)
            if (max(tape(i).arg3vc) <= m)||strcmp(tape(i).arg3vc,':')
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W(tape(i).arg3vc,:);
            else
                I=tape(i).arg3vc;
                for j=1:length(I)
                    jindex=ceil(I(j)/n);
                    iindex=I(j)-m*(jindex-1);
                    tape(tape(i).arg2vc).W(j,:)=tape(tape(i).arg2vc).W(j,:)+...
                        tape(i).W(iindex,jindex,:);
                end
            end
        end
    else
        if  (m==1) || (n==1)
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                tape(i).W(tape(i).arg3vc,:);
        else
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                tape(i).W(tape(i).arg3vc,tape(i).arg4vc,:);
        end
    end

else
    saveW=tape(tape(i).arg1vc).W;
    if isempty(tape(i).arg4vc)
        nnn=length(tape(tape(i).arg1vc).val);
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W(1:nnn,:);
        if ~isempty(tape(i).arg3vc)
            if (max(tape(i).arg3vc) <= length(tape(i).val))||strcmp(tape(i).arg3vc,':')
                index=find(tape(i).arg3vc <= nnn);
                if ~isempty(index) 
                    tape(tape(i).arg1vc).W(tape(i).arg3vc(index),:)=...
                        saveW(tape(i).arg3vc(index),:);
                end
                if (length(tape(tape(i).arg2vc).val) ==1) && (length(tape(i).arg3vc) > 1)
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                        sum(tape(i).W(tape(i).arg3vc,:));
                else
                    if strcmp(tape(i).arg3vc,':')
                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            tape(i).W(tape(i).arg3vc,:);
                    else
                        tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                            tape(i).W(tape(i).arg3vc,:);
                    end

                end
            else
                I=tape(i).arg3vc;
                for j=1:length(I)
                    jindex=ceil(I(j)/n);
                    iindex=I(j)-m*(jindex-1);
                    tape(tape(i).arg2vc).W(j,:)=tape(tape(i).arg2vc).W(j,:)+...
                        tape(i).W(iindex,jindex,:);
                    tape(tape(i).arg1vc).W(iindex,jindex,:)=saveW(iindex,jindex,:);
                end
            end
        end
    else
        [p,q, d3]=size(tape(tape(i).arg1vc).val);
        if (ndims(tape(i).W)==3)
            if (p >1) && (q >1)
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W(1:p,1:q,:);
            else
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+squeeze(tape(i).W(1:p,1:q,:));
            end
            if ~isempty(tape(i).arg3vc)
                index=find(tape(i).arg3vc <= p);
                if ~isempty(index) && ~strcmp(tape(i).arg3vc,':')
                    tape(tape(i).arg1vc).W(tape(i).arg3vc(index),tape(i).arg4vc,:)=...
                        saveW(tape(i).arg3vc(index),tape(i).arg4vc,:);
                end
                if (length(tape(tape(i).arg2vc).val) ==1)&&((length(tape(i).arg3vc) > 1) ||...
                        (length(tape(i).arg4vc) > 1))
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                        reshape(sum(tape(i).W(tape(i).arg3vc,tape(i).arg4vc,:)),...
                        size(tape(tape(i).arg2vc).W));
                elseif strcmp(tape(i).arg5vc, ':') && length(tape(i).arg3vc) == 1 && strcmp(tape(i).arg4vc, ':')
                    for k = 1:globp
                        tape(tape(i).arg2vc).W( tape(i).arg4vc,tape(i).arg3vc,k) = ...
                            tape(tape(i).arg2vc).W(tape(i).arg4vc,tape(i).arg3vc,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k)';
                    end
                elseif strcmp(tape(i).arg5vc, ':') && length(tape(i).arg4vc) == 1 && strcmp(tape(i).arg3vc, ':')
                    for k = 1:globp
                        tape(tape(i).arg2vc).W( tape(i).arg3vc,tape(i).arg4vc,k) = ...
                            tape(tape(i).arg2vc).W(tape(i).arg3vc,tape(i).arg4vc,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k);
                    end
                elseif strcmp(tape(i).arg5vc, ':') && (size(tape(tape(i).arg2vc).val,1) ==1 || size(tape(tape(i).arg2vc).val,2) ==1)
                    if tape(i).arg3vc >1
                    for k = 1:globp
                        tape(tape(i).arg2vc).W( tape(i).arg3vc,k) = ...
                            tape(tape(i).arg2vc).W(tape(i).arg3vc,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k);
                    end
                    else
                        for k = 1:globp
                        tape(tape(i).arg2vc).W( tape(i).arg4vc,k) = ...
                            tape(tape(i).arg2vc).W(tape(i).arg4vc,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k);
                        end
                    end
                elseif strcmp(tape(i).arg5vc, ':') && ndims(tape(tape(i).arg2vc).val) == 2
                    if length(tape(i).arg3vc) == 1
                     for k = 1:globp
                        tape(tape(i).arg2vc).W(:, tape(i).arg3vc, k) = ...
                            tape(tape(i).arg2vc).W(:, tape(i).arg3vc,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k)';
                     end
                    else
                         for k = 1:globp
                        tape(tape(i).arg2vc).W(tape(i).arg3vc, :,k) = ...
                            tape(tape(i).arg2vc).W(tape(i).arg3vc, :,k) + ...
                        tape(i).W(tape(i).arg3vc, tape(i).arg4vc,k);
                         end
                    end
                else                            
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                        reshape(tape(i).W(tape(i).arg3vc,tape(i).arg4vc,:),...
                        size(tape(tape(i).arg2vc).W));
                end
            end
        else
             nnn=length(tape(tape(i).arg1vc).val);
             if globp == 1
                 tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
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

             else
                 tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W(1:nnn,:);

                 if ~isempty(tape(i).arg3vc)
                     if (size(tape(tape(i).arg1vc).val,1)~=1)||(size(tape(tape(i).arg1vc).val,2)==1)
                         if strcmp(tape(i).arg3vc,':')
                             index=1:nnn;
                         else
                             index=tape(i).arg3vc(find(tape(i).arg3vc <= nnn));
                         end
                     else
                         if strcmp(tape(i).arg4vc, ':')
                             index=1:nnn;
                         else
                             index=tape(i).arg4vc(find(tape(i).arg4vc <= nnn));
                         end

                     end

                     if ~isempty(index) && (size(tape(tape(i).arg1vc).val,1) > 1  && ...
                             size(tape(tape(i).arg1vc).val,2) > 1)
                         tape(tape(i).arg1vc).W(index,tape(i).arg4vc)=...
                             saveW(index,tape(i).arg4vc);
                     end

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
             end
        end
    end
end
