function adjshorzcat(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

[m,n]=size(tape(tape(i).arg1vc).val);
[m,n2]=size(tape(tape(i).arg2vc).val);
if m==1
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
        tape(i).W(1:n,:);
    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
        tape(i).W(n+1:n+n2,:);
else
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
        reshape(tape(i).W(:,1:n,:),size(tape(tape(i).arg1vc).W));
    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
        reshape(tape(i).W(:,n+1:n+n2,:),size(tape(tape(i).arg2vc).W));
end
