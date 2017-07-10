function adjrdivide(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global globp
[m,n]=size(tape(i).val);
if (length(tape(tape(i).arg2vc).val)==1) & (length(tape(tape(i).arg1vc).val)~=1)
    if (m==1) | (n==1)
        for j=1:globp
            tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
                sum((tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W(:,j));
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+(1./tape(tape(i).arg2vc).val).*tape(i).W(:,j);
        end
    else

        for j=1:globp
            tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
                sum(sum((tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W(:,:,j)));
            tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)+(1./tape(tape(i).arg2vc).val).*tape(i).W(:,:,j);
        end
    end

elseif (length(tape(tape(i).arg2vc).val)~=1) & (length(tape(tape(i).arg1vc).val)==1)
    if (m==1) | (n==1)
        for j=1:globp
            tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
                (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W(:,j);
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+sum((1./tape(tape(i).arg2vc).val).*tape(i).W(:,j));
        end
    else
        for j=1:globp
            tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)-...
                (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W(:,:,j);
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+sum(sum((1./tape(tape(i).arg2vc).val).*tape(i).W(:,:,j)));
        end
    end
else
    if (m==1) | (n==1)
        for j=1:globp
            tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)-...
                (tape(tape(i).arg1vc).val(:)./(tape(tape(i).arg2vc).val(:).*tape(tape(i).arg2vc).val(:))).*tape(i).W(:,j);
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+(1./tape(tape(i).arg2vc).val(:)).*tape(i).W(:,j);
        end
    else
        for j=1:globp
            tape(tape(i).arg2vc).W(:,:,j)=tape(tape(i).arg2vc).W(:,:,j)-...
                (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W(:,:,j);
            tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)+(1./tape(tape(i).arg2vc).val).*tape(i).W(:,:,j);
        end
    end
end

