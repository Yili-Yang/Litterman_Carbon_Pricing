function adjsreshape(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
mm=tape(i).arg2vc;
nn=tape(i).arg3vc;
[m1,n1]=size(tape(tape(i).arg1vc).val);
if m1==1 && n1~=1
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(tape(i).W,mm,nn)';
else
    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(tape(i).W,mm,nn);
end
