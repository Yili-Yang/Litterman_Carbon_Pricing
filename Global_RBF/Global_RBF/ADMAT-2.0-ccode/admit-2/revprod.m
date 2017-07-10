function [f,WJ] = revprod(fun,x,W,Extra)
%
%revprod
%
%	Computes reverse mode product J^T*W 
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       [f,WJ]=revprod(fun,x,W,Extra) computes J^T*W at point x.
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE forwpord, jacsp
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;
global tape;
global tape_begin;
global globp;

if isa(fun, 'string')
    fun=deblank(fun);
end
if nargin < 4
    Extra=[];
end
cleanup;
f=feval(fun,x,Extra);
[p,q]=size(f);
if ((p==1) || (q==1))
    globp=size(W,2);
else
    globp=size(W,3);
end

xx=derivtape(x,1);
y=feval(fun,xx,Extra);

%varcounter=varcount(y)+1;
if globp==1
    WJ = parsetapeS(W);
    WJ = WJ';
else
    WJ = parsetape(W);
end
f=getval(y);
