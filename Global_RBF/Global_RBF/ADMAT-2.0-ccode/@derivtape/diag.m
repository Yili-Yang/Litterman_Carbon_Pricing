function sout = diag(V, k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
global varcounter;

if ~isa(V, 'derivtape')   % V is not an object of derivtape
    if nargin > 1
        k = getval(k);
        sout = diag(V, k);
    else
        sout = diag(V);
    end
else     % V is an object of derivtape
    if nargin > 1
        k = getval(k);
        D = getval(V);
        sout.val = diag(D,k);
        sout.varcount=varcounter;
        sout=class(sout,'derivtape');
        savetape('diag',sout,V.varcount, k);        
    else
        D = getval(V);
        sout.val = diag(D);
        sout.varcount=varcounter;
        sout=class(sout,'derivtape');
        savetape('diag',sout,V.varcount);
    end    
end
