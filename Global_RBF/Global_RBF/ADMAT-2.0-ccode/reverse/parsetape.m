function WJ= parsetape(W)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global tape;
global varcounter;
global globp;
global tape_begin;
% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end


% for i = varcounter-1 : -1 : tape_begin 
%     if isequal(tape(i).op, ' ')
%         varcounter = varcounter -1;
%     else
%         break;
%     end
% end
[p,q]=size(tape(varcounter-1).val);

if ((p==1) || (q==1)) 
    globp=size(W,2);
else
    globp=size(W,3);
end
for i= tape_begin : (varcounter-2)
    [m,n,d3]=size(tape(i).val);
    if ((m > 1) && (n> 1))           % tape(i).val is a matrix
        if issparse(tape(i).val) && globp==1
            tape(i).W=sparse(m,n);
        else
              tape(i).W=zeros([m n globp]);
        end
    else                            % tape(i).val is a vector or a scalar
        tape(i).W=zeros(length(tape(i).val), globp);
    end
end

tape(varcounter-1).W=W;

for i=varcounter-1 : -1 : tape_begin
    switch tape(i).op
        case 'det',
            adjdet(i);
        case 'round',
            adjround(i);
        case 'sparse',
            adjsparse(i);
        case 'reshape',
            adjreshape(i);
        case 'repmat',
            adjrepmat(i);
        case 'lul',
            adjlul(i);
        case 'luu',
            adjluu(i);
        case 'spdiags',
            adjspdiags(i);
        case 'triu',
            adjtriu(i);
        case 'tril',
            adjtril(i);
        case 'flipud',
            adjflipud(i);
        case 'fliplr',
            adjfliplr(i);
        case 'subsref',
            adjsubsref(i);
        case 'subsindex',
            adjsubsindex(i);
        case 'subsasgn',
            adjsubsasgn(i);
        case 'assign',
            adjassign(i);
        case 'minusvec',
            adjminusvec(i);
        case 'timesvec',
            adjtimesvec(i);
        case 'plusvec',
            adjplusvec(i);
        case 'plus',
            adjplus(i);
        case 'minus',
            adjminus(i);
        case 'rem',
            adjrem(i);
        case 'abs',
            adjabs(i);
        case 'times',
            adjtimes(i);
        case 'mtimes',
            adjmtimes(i);
        case 'ctranspose',
            adjctranspose(i);
        case 'transpose',
            adjtranspose(i);
        case 'sqrt',
            adjsqrt(i);
        case 'mldivide',
            adjmldivide(i);
        case 'mrdivide',
            adjmrdivide(i);
        case 'rdivide',
            adjrdivide(i);
        case 'ldivide',
            adjldivide(i);
        case 'power',
            adjpower(i);
        case 'mpower',
            adjmpower(i);
        case 'prod',
            adjprod(i);
        case 'diff',
            adjdiff(i);
        case 'sum',
            adjsum(i);
        case 'uminus',
            adjuminus(i);
        case 'norm',
            adjnorm(i);
        case 'max',
            adjmax(i);
        case 'min',
            adjmin(i);
        case 'log',
            adjlog(i);
        case 'log2',
            adjlog2(i);
        case 'log10',
            adjlog10(i);
        case 'exp',
            adjexp(i);
        case 'horzcat',
            adjhorzcat(i);
        case 'vertcat',
            adjvertcat(i);
        case 'cos',
            adjcos(i);
        case 'cosh',
            adjcosh(i);
        case 'acos',
            adjacos(i);
        case 'acosh',
            adjacosh(i);
        case 'sin',
            adjsin(i);
        case 'sinh',
            adjsinh(i);
        case 'asin',
            adjasin(i);
        case 'asinh',
            adjasinh(i);
        case 'tan',
            adjtan(i);
        case 'tanh',
            adjtanh(i);
        case 'atan2',
            adjatan2(i);
        case 'atan',
            adjatan(i);
        case 'atanh',
            adjatanh(i);
        case 'sec',
            adjsec(i);
        case 'sech',
            adjsech(i);
        case 'asec',
            adjasec(i);
        case 'asech',
            adjasech(i);
        case 'cot',
            adjcot(i);
        case 'coth',
            adjcoth(i);
        case 'acot',
            adjacot(i);
        case 'acoth',
            adjacoth(i);
        case 'csc',
            adjcsc(i);
        case 'coth',
            adjcsch(i);
        case 'acsc',
            adjacsc(i);
        case 'acsch',
            adjacsch(i);
        case 'diag'
            adjdiag(i);
        case 'bsxfun'
            adjbsxfun(i);
        otherwise,
    end
end
WJ = tape(tape_begin).W;
