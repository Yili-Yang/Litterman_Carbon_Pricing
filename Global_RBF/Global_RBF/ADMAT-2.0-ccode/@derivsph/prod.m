function sout = prod(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
sout.val=prod(s1.val);
sout.derivsph=cell(1,1);
sout.derivsph{1}=sparse(globp,globp);
for i=1:length(getval(s1.val))
    sout.derivsph{1}=sout.derivsph{1}+s1.derivsph{i};
    for  j=1:i-1
        sout.derivsph{1} = sout.derivsph{1} + ...
            getspj(s1(i))'*getspj(s1(j)) + ...
            getspj(s1(j))'*getspj(s1(i));
    end
end
sout=class(sout,'derivsph');
