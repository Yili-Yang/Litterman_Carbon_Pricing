function adjtimesvec(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global globp;
[m1,z]=size(tape(tape(i).arg1vc).val);
[m2,z]=size(tape(tape(i).arg2vc).val);
if ((m1==1)&(m2~=1))
for j=1:globp
tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+sum(tape(tape(i).arg2vc).val.*tape(i).W(:,j));
tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+tape(tape(i).arg1vc).val.*tape(i).W(:,j);
end

elseif ((m2==1)&(m1~=1))
for j=1:globp
tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+tape(tape(i).arg2vc).val.*tape(i).W(:,j);
tape(tape(i).arg2vc).W(:,j)=tape(tape(i).arg2vc).W(:,j)+sum(tape(tape(i).arg1vc).val.*tape(i).W(:,j));
end
elseif ((m1==1)&(m2==1))
tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(tape(i).arg2vc).val*tape(i).W;
tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(tape(i).arg1vc).val*tape(i).W;
else
for k=1:globp
for j=1:globp
tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+tape(i).W(:,k,j).*tape(tape(i).arg2vc).val(:,k);
tape(tape(i).arg2vc).W(:,k,j)=tape(tape(i).arg2vc).W(:,k,j)+tape(i).W(:,k,j).*tape(tape(i).arg1vc).val;
end
end
end
