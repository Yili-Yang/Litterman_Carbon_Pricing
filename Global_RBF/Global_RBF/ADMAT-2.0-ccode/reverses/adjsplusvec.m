function adjsplusvec(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global tape
[m1,z]=size(tape(tape(i).arg1vc).val);
[m2,z]=size(tape(tape(i).arg2vc).val);
if ((m1==1) &(m2~=1))
tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(tape(i).W)';
elseif ((m1~=1)&(m2==1))
tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+sum(tape(i).W)';
else
tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
end
