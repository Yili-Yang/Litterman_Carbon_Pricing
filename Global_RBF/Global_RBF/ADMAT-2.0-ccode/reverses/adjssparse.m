function adjssparse(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

for j=1:length(tape(i).arg1vc)
    tape(tape(i).arg3vc).W(j)=tape(tape(i).arg3vc).W(j) + ...
        tape(i).W(tape(i).arg1vc(j),tape(i).arg2vc(j));
end
