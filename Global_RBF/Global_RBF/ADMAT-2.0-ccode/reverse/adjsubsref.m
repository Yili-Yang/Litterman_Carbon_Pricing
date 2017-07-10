function adjsubsref(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;


if ~isempty(tape(i).arg2vc)
    [m,n]=size(tape(i).val);
    [m2,n2]=size(tape(tape(i).arg1vc).val);
    if isempty(tape(i).arg3vc)

        len=length(tape(i).arg2vc);
        if (m2==1)
            m2=n2;
        end
        if (max(tape(i).arg2vc) <= m2) || strcmp(tape(i).arg2vc,':')

            if strcmp(tape(i).arg2vc,':')
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
                    reshape(tape(i).W,size(tape(tape(i).arg1vc).W));
            else
                for j=1:len
                    tape(tape(i).arg1vc).W(tape(i).arg2vc(j),:)=...
                        tape(tape(i).arg1vc).W(tape(i).arg2vc(j),:)+tape(i).W(j,:);
                end
            end

        else
            I=tape(i).arg2vc;
            for j=1:length(I)
                jindex=ceil(I(j)/n2);
                iindex=I(j)-m2*(jindex-1);
                tape(tape(i).arg1vc).W(iindex,jindex,:)=...
                    tape(tape(i).arg1vc).W(iindex,jindex,:)+tape(i).W(I(j),:);
            end

        end
    else
        if (ndims(tape(i).W)==3)
            if ndims(tape(tape(i).arg1vc).W) == 2
                tape(tape(i).arg1vc).W=...
                    tape(tape(i).arg1vc).W+squeeze(sum(tape(i).W,2));
            else
                for j=1:globp
                    tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)=...
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)+tape(i).W(:,:,j);
                end
            end
        else
            if (ndims(tape(tape(i).arg1vc).W)==3)

                for j=1:globp
                    if (m==1) && (n~=1)
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)=...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)+...
                            tape(i).W(:,j)';
                    else
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)=...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc,j)+tape(i).W(:,j);
                    end
                end
            else
                if ~strcmp(tape(i).arg2vc,':')&& ~strcmp(tape(i).arg3vc,':')
                    if length(tape(i).arg2vc) > 1  || length(tape(i).arg3vc) > 1
                        if ((m==1) && (n~=1)) && (size(tape(tape(i).arg1vc).val,1)~=1)
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)=...
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W';
                        else
                            [p,q] =  size(tape(tape(i).arg1vc).val);
                            if p == 1 % row vector
                            tape(tape(i).arg1vc).W(:,tape(i).arg3vc)=...
                                tape(tape(i).arg1vc).W(:,tape(i).arg3vc)+tape(i).W;
                            elseif q == 1 % column vector
                                 tape(tape(i).arg1vc).W(tape(i).arg2vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,:)+tape(i).W;
                            else % matrix
                                 tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)=...
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W;
                            end
                        end
                    else
                        if size(tape(tape(i).arg1vc).val,1)==1
                            tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W;
                        else
                            [p,q] = size(tape(tape(i).arg1vc).val);
                            if p == 1   % row vector
                            tape(tape(i).arg1vc).W(:,tape(i).arg3vc)=...
                                tape(tape(i).arg1vc).W(:,tape(i).arg3vc)+tape(i).W;
                            elseif q == 1 % column vector
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,:)+tape(i).W;
                            else   % matrix
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)=...
                                tape(tape(i).arg1vc).W(tape(i).arg2vc,tape(i).arg3vc)+tape(i).W;
                            end
                        end

                    end

                elseif ~strcmp(tape(i).arg2vc,':')
                    [p,q]=size(tape(tape(i).arg1vc).val);
                    if p==1
                        if length(tape(i).arg2vc) > 1
                            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + sum(tape(i).W)';
                        else
                            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
                        end
                    else
                        tape(tape(i).arg1vc).W(tape(i).arg2vc,:)=...
                            tape(tape(i).arg1vc).W(tape(i).arg2vc,:)+...
                            reshape(tape(i).W,size(tape(tape(i).arg1vc).W(tape(i).arg2vc,:)));
                    end
                else
                    [mval, nval] = size(tape(i).val);
                    if m2==1 && n2~=1                        
                        if mval == 1 && nval == 1          % tape(i).val is a scalar
                            tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W;
                        elseif m2 == mval && n2 == nval
                            tape(tape(i).arg1vc).W = tape(i).W;
                        else
                            tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W(tape(i).arg3vc,:);
                        end
                    elseif m2 ~= 1 && n2 ==1
                        if mval == 1 && nval == 1          % tape(i).val is a scalar
                            tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W;
                        elseif m2 == mval && n2 == nval
                            tape(tape(i).arg1vc).W = tape(i).W;
                        else
                            tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=...
                                tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W(tape(i).arg3vc,:);
                        end
                    else                        
                        tape(tape(i).arg1vc).W(:,tape(i).arg3vc,:)=...
                            tape(tape(i).arg1vc).W(:,tape(i).arg3vc,:)+tape(i).W(:,tape(i).arg3vc,:);
                    end
                    %tape(tape(i).arg1vc).W(tape(i).arg3vc,:)=tape(tape(i).arg1vc).W(tape(i).arg3vc,:)+tape(i).W;
                end

            end

        end

    end
end
