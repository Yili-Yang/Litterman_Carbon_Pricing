function adjprod(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

% tmp =  tape(i).val./tape(tape(i).arg1vc).val(:);
% tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
%          tmp(:,ones(1,globp)) .* tape(i).W;

for j=1:globp
     tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+...
         (tape(i).val(:)./tape(tape(i).arg1vc).val(:)).*tape(i).W(:,j);
end
