function adjsctranspose(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
p=size(tape(i).W,2);
[m,n]= size(tape(i).val);
if m> 1 && n>1
   tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W'; 
else
tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
end
