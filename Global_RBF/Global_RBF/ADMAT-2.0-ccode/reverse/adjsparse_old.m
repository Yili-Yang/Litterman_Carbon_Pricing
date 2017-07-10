function adjsparse(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global globp

for k=1:globp
    for j=1:length(tape(i).arg1vc)
        tape(tape(i).arg3vc).W(j,k) = tape(tape(i).arg3vc).W(j,k)+...
            tape(i).W(tape(i).arg1vc(j),tape(i).arg2vc(j),k);
    end
end
