function WJ= parsetapeS(W)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global varcounter;
global tape_begin;


for i= tape_begin:(varcounter-2)
    [m,n]=size(tape(i).val);
    if ((m > 1) && (n> 1))
        if issparse(tape(i).val)
            tape(i).W=sparse(m,n);
        else
            tape(i).W=zeros([m n]);
        end
    else
        tape(i).W=zeros(length(tape(i).val),1);
    end
end

tape(varcounter-1).W=W;

for i = varcounter-1:-1: tape_begin
    switch tape(i).op
        case 'det',
            adjsdet(i);
        case 'sparse',
            adjssparse(i);
        case 'round',
            adjsround(i);
        case 'reshape',
            adjsreshape(i);
        case 'repmat',
            adjsrepmat(i);
        case 'lul',
            adjslul(i);
        case 'luu',
            adjsluu(i);
        case 'spdiags',
            adjsspdiags(i);
        case 'triu',
            adjstriu(i);
        case 'tril',
            adjstril(i);
        case 'flipud',
            adjsflipud(i);
        case 'fliplr',
            adjsfliplr(i);
        case 'subsref',
            adjssubsref(i);
        case 'subsindex',
            adjssubsindex(i);
        case 'subsasgn',
            adjssubsasgn(i);
        case 'assign',
            adjsassign(i);
        case 'minusvec',
            adjsminusvec(i);
        case 'timesvec',
            adjstimesvec(i);
        case 'plusvec',
            adjsplusvec(i);
        case 'plus',
            adjsplus(i);
        case 'minus',
            adjsminus(i);
        case 'rem',
            adjsrem(i);
        case 'abs',
            adjsabs(i);
        case 'times',
            adjstimes(i);
        case 'mtimes',
            adjsmtimes(i);
        case 'ctranspose',
            adjsctranspose(i);
        case 'transpose',
            adjstranspose(i);
        case 'sqrt',
            adjssqrt(i);
        case 'mldivide',
            adjsmldivide(i);
        case 'mrdivide',
            adjsmrdivide(i);
        case 'rdivide',
            adjsrdivide(i);
        case 'ldivide',
            adjsldivide(i);
        case 'power',
            adjspower(i);
        case 'mpower',
            adjsmpower(i);
        case 'prod',
            adjsprod(i);
        case 'sum',
            adjssum(i);
        case 'uminus',
            adjsuminus(i);
        case 'norm',
            adjsnorm(i);
        case 'max',
            adjsmax(i);
        case 'min',
            adjsmin(i);
        case 'log',
            adjslog(i);
        case 'log2',
            adjslog2(i);
        case 'log10',
            adjslog10(i);
        case 'exp',
            adjsexp(i);
        case 'horzcat',
            adjshorzcat(i);
        case 'vertcat',
            adjsvertcat(i);
        case 'cos',
            adjscos(i);
        case 'cosh',
            adjscosh(i);
        case 'acos',
            adjsacos(i);
        case 'acosh',
            adjsacosh(i);
        case 'sin',
            adjssin(i);
        case 'sinh',
            adjssinh(i);
        case 'asin',
            adjsasin(i);
        case 'asinh',
            adjsasinh(i);
        case 'tan',
            adjstan(i);
        case 'tanh',
            adjstanh(i);
        case 'atan',
            adjsatan(i);
        case 'atanh',
            adjsatanh(i);
        case 'sec',
            adjssec(i);
        case 'sech',
            adjssech(i);
        case 'asec',
            adjsasec(i);
        case 'asech',
            adjsasech(i);
        case 'cot',
            adjscot(i);
        case 'coth',
            adjscoth(i);
        case 'acot',
            adjsacot(i);
        case 'acoth',
            adjsacoth(i);
        case 'csc',
            adjscsc(i);
        case 'coth',
            adjscsch(i);
        case 'acsc',
            adjsacsc(i);
        case 'acsch',
            adjsacsch(i);
        case 'diag'
            adjsdiag(i);
        otherwise,
    end
end
WJ=tape(tape_begin).W;
