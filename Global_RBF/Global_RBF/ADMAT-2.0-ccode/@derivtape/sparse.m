function sout=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if isa(i, 'derivtape')
    i = i.val;
end
if isa(j,'derivtape')
    j = j.val;
end

if nargin == 2
    sout.val=sparse(i,j);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('sparse',sout,i,j);
elseif nargin == 3
    s=derivtape(s);
    sout.val=sparse(i,j,s.val);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('sparse',sout,i,j,s.varcount);
elseif nargin == 4
    s=derivtape(s);
    if isa(m, 'derivtape')
        m = m.val;
    end
    sout.val=sparse(i,j,s.val,m);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('sparse',sout,i,j,s.varcount,m);
else
    s=derivtape(s);
    if isa(m, 'derivtape')
        m = m.val;
    end
    if isa(n, 'derivtape')
        n = n.val;
    end
    sout.val=sparse(i,j,s.val,m,n);
    sout.varcount=varcounter;
    sout=class(sout,'derivtape');
    savetape('sparse',sout,i,j,s.varcount,m,n);
end
