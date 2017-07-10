function adjsmrdivide(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global tape;
val2=tape(tape(i).arg2vc).val;
val2=val2(:);
val1=tape(tape(i).arg1vc).val; 
val1=val1(:);

if (length(tape(tape(i).arg2vc).val)==1) && (length(tape(tape(i).arg1vc).val)~=1)

     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     sum(sum((val1./(val2.*val2)).*tape(i).W));
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./val2).*tape(i).W;
elseif (length(tape(tape(i).arg2vc).val)~=1) && (length(tape(tape(i).arg1vc).val)==1)
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (val1./(val2.*val2)).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(sum((1./val2).*tape(i).W));
else
     tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W-...
     (val1./(val2.*val2)).*tape(i).W;
     tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(1./val2).*tape(i).W;
end

