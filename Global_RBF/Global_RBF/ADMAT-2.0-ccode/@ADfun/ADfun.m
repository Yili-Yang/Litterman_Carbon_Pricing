function fun= ADfun(infun,scalar,extendedclass)
%
% ADfun
%	a class for seamless computation of derivatives via AD
%
%	fun= ADfun(infun,scalar)
%
%	infun is the input matlab function  string. 
%	scalar = 1 if its a vector to scalaer mapping.
%
%   EXAMPLES:
%   ========
%	For a vector function say in vecfun.m
%
%	   fun = ADfun('vecfun', n);
%	   N=10; x= ones(N,1);
%	   [f,J]=feval(fun,x)
%   will compute the function value as well as the sparse derivative.
%
%	For a scalar function say in scalarfun.m
%
%	   fun = ADfun('scalarfun',1);
%	   N=10; x= ones(N,1);
%	   [f,g]=feval(fun,x);   computes gradient via AD.
%	   [f,g,H]=feval(fun,x); computes Hessian via AD.
%
%   will compute the function value as well as the sparse derivative.
%
%  
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************




if nargin < 1 infun=''; end
if nargin < 2 scalar=[]; end
if nargin < 3 extendedclass=[]; end
if isempty(scalar) scalar =0; end

if isa(infun,'ADfun')
    fun=infun;
    fun.scalar=scalar;
    fun.class=extendedclass;
else
    fun.fun=infun;
    fun.scalar=scalar;
    fun.class=extendedclass;

    fun.JPI=[];
    fun.HPI=[];
    fun.EJPI=[];
    fun.EHPI=[];
    fun.fdata=[];
    fun.Extra=[];
    fun.n=[];
    fun=class(fun,'ADfun');
end
