function[Hout] = HessRecover(fun,x,Extra,verb,HPI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	INPUT 
%		fun : Handle to the function
%		x   : the current point
%		H   : The Sparsity Structure of Hessian  Matrix
%		fdata = [group perm] where group is the coloring Info
%			and perm is the permutation from Powell_Toint method.
% OUTPUT:
%  	Hout: The sparse Hessian  
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global globp;
n=length(x);

% Find the Sparsity pattern and do coloring(path coloring)
% If you don't have the Gradient Routine, write your own
% HessSP and use it
if (nargin < 5)
    HPI=[];
end

if isempty(HPI)
    HPI = gethpi(fun, n, Extra, 'i-a');
end
H=HPI.SPH;
group=HPI.group;
method=HPI.method;

if isempty(verb) 
    verb=0; 
end

if (verb >=1)
    disp(sprintf('Number of Column groups = %d',max(group)));
end
if (verb >= 2)
    subplot(1,1,1)
    spy(H);
    title 'Sparsity Structure of H'
end

ncol = max(group);
V = zeros(n,ncol);
HV = zeros(n,ncol);

for k = 1:ncol
    V(:,k) = (group == k);
end

if ncol >0
    HV =HtimesV(fun,x,V,Extra);
%     for k=1:ncol
%         HV(:,k) =HtimesV(fun,x,V(:,k),Extra);
%     end
end

if method(1)=='i'
    [i, j]=find(H);
    group(logical(group==0))=ones(length(find(group==0)),1);
    Hout = sparse(i,j,HV((group(j)-1)*n + i),n,n);

else
    %method = 's' or 'd'
    perminv=HPI.o;
    perm(perminv)=linspace(1,n,n);

    Hout=sparse(n,n);
    for j=n:-1:1
        row=perminv(j);
        pos=find(H(row,:));
        pos1=find(perm(pos)>j);
        pos2=find(perm(pos)<=j);
        for k=1:length(pos2)
            col=pos(pos2(k));
            gr=group(col);
            if isempty(group(pos(pos1)))
                ind2=[];
            else
                ind2=find(group(pos(pos1))==gr);
            end
            delta=full(sum(Hout(row,pos(pos1(ind2)))));
            if isempty(delta) 
                delta=0; 
            end
            Hout(row,col)=HV(row,gr)-delta;
            Hout(col,row)=Hout(row,col);
        end

    end

end

