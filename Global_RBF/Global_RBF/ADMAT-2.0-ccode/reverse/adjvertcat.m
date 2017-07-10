function adjvertcat(i)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global tape;

[m,n]=size(tape(tape(i).arg1vc).val);
[m2,n]=size(tape(tape(i).arg2vc).val);
if n==1
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W(1:m,:);
    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W(m+1:m+m2,:);
else
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
        reshape(tape(i).W(1:m,:,:),size(tape(tape(i).arg1vc).W));
    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
        reshape(tape(i).W(m+1:m+m2,:,:),size(tape(tape(i).arg2vc).W));
end
