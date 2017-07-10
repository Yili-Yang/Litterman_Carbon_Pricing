function adjsrdivide(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
[m,n]=size(tape(i).val);
if (length(tape(tape(i).arg2vc).val)==1) & (length(tape(tape(i).arg1vc).val)~=1)
if (m==1) | (n==1)
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     sum((tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W);
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./tape(tape(i).arg2vc).val).*tape(i).W;
else

     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     sum(sum((tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W));
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./tape(tape(i).arg2vc).val).*tape(i).W;
end

elseif (length(tape(tape(i).arg2vc).val)~=1) & (length(tape(tape(i).arg1vc).val)==1)
if (m==1) | (n==1)
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum((1./tape(tape(i).arg2vc).val).*tape(i).W);
else
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(sum((1./tape(tape(i).arg2vc).val).*tape(i).W));
end
else
if (m==1) | (n==1)
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (tape(tape(i).arg1vc).val(:)./(tape(tape(i).arg2vc).val(:).*tape(tape(i).arg2vc).val(:))).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./tape(tape(i).arg2vc).val(:)).*tape(i).W;
else
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (tape(tape(i).arg1vc).val./(tape(tape(i).arg2vc).val.*tape(tape(i).arg2vc).val)).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./tape(tape(i).arg2vc).val).*tape(i).W;
end
end

