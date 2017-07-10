function adjnorm(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global globp
for j=1:globp
     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+...
         (tape(tape(i).arg1vc).val./tape(i).val).*tape(i).W(:,j);
end

