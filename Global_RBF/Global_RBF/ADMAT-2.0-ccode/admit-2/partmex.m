function JPI=partmex(Jd,verb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINDS PARTITION AND FORMS THE GRAPH TOO :- DIRECT METHOD
%
% INPUT:
%	Jd= Structure of Jacobian Matrix
%
% OUTPUT :
%	Ar,Jr :- Information related to Jr
%	Ac,Jc :- Information related to Jc
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=spones(Jd);
[m,n]=size(J);
sumc=zeros(1,n);
sumr=zeros(1,m);
if m > 1
    sumc=full(sum(J));
else
    sumc=J;
end

if n > 1
    sumr=full(sum(J'));
else
    sumr=J;
end

%currrowcount=0;
%currcolcount=0;
rowsconsideredcomp=linspace(1,m,m)';
colsconsideredcomp=linspace(1,n,n)';
counter=1;
numrowscons=0;
numcolscons=0;
Jr=[];
Jc=[];
Ar=sparse(m,m);
Ac=sparse(n,n);
last=1;
colcons=zeros(0,1);
rowcons=zeros(0,1);

% Initialize %%%%%%%%%%%%
rows=rowsconsideredcomp(1:m);
cols=colsconsideredcomp(1:n);
[colmax,Ic]=max(sumc);
[rowmax,Ir]=max(sumr);
row=0;
col=0;
if  rowmax > 2*colmax
    row=1;
elseif rowmax < 2*colmax
    col=1;
elseif last==1
    row=1;
else
    col=1;
end
if (row ==1 & numrowscons < m)
    last=1;
else
    last=0;
end

counter=1;


while (counter<=m+n)
    if (row ==1 & numrowscons < m)
        Ir=find(sumr==rowmax);
        if (length(Ir) > 1)
            sumc=sumc-sum(J(Ir,:));
        else
            sumc=sumc-J(Ir,:);
        end
        sumr(Ir)=-ones(1,length(Ir));
        counter=counter+length(Ir);

        rowsconsideredcomp(Ir)=zeros(1,length(Ir));
        numrowscons=numrowscons + length(Ir);
        rowcons(numrowscons-length(Ir)+1: numrowscons)=Ir;
        Jc=[Jc;
            J(Ir,colcons)];
        Jr=[Jr; sparse(length(Ir),numcolscons)];

        if ((length(cols) >0) &(length(colcons) >0))
            Ac = Ac+[sparse(length(colcons), length(colcons))  J(Ir,colcons)'*J(Ir,cols);
                sparse(length(cols),n)];
        end
        rows=find(rowsconsideredcomp>0);
    else
        Ic=find(sumc==colmax);
        if (length(Ic) > 1)
            sumr=sumr-sum(J(:,Ic)');
        else
            sumr=sumr-J(:,Ic)';
        end

        counter=counter+length(Ic);
        sumc(Ic)=-ones(1,length(Ic));

        colsconsideredcomp(Ic)=zeros(1,length(Ic));

        numcolscons=numcolscons + length(Ic);
        colcons(numcolscons-length(Ic)+1:numcolscons)=Ic;
        Jr=[Jr J(rowcons,Ic)];
        Jc=[Jc sparse(numrowscons,length(Ic))];
        if ((length(rows) >0) &(length(rowcons) >0))
            Ar = Ar+[sparse(length(rowcons), length(rowcons))  J(rowcons,Ic)*J(rows,Ic)';
                sparse(length(rows),m)];
        end
        cols=find(colsconsideredcomp>0);
    end
    if (counter <=m+n)
        [colmax,Ic]=max(sumc);
        [rowmax,Ir]=max(sumr);
        row=0;
        col=0;
        if  rowmax > 2*colmax
            row=1;
        elseif rowmax < 2*colmax
            col=1;
        elseif last==1
            row=1;
        else
            col=1;
        end
        if (row ==1 & numrowscons < m)
            last=1;
        else
            last=0;
        end
    end
end
if size(Jc,1) < m
    Jr=[Jr ; sparse(m-size(Jc,1),n)];
    Jc=[Jc; J(rowcons(size(Jc,1)+1:m),colcons)];
end
if size(Jc,2) < n
    Jr=[Jr J(rowcons,colcons(size(Jc,2)+1:n))];
    Jc=[Jc  sparse(m,n-size(Jc,2))];
end

[y,invpermrow]=sort(rowcons);
[y,invpermcol]=sort(colcons);
Jr=Jr(invpermrow,invpermcol);
Jc=Jc(invpermrow,invpermcol);
Ar=Ar(invpermrow,invpermrow);
Ac=Ac(invpermcol,invpermcol);

% Also try Row and Column colorings

Ar=Ar+Ar';
Ac=Ac+Ac';
Hr=spones(Ar+Jr*Jr');
Hc=spones(Ac+Jc'*Jc);
pr=id(Hr,full(sum(Hr)));
pc=id(Hc,full(sum(Hc)));
gr=colorHess(Hr,pr);
gc=colorHess(Hc,pc);

bgc=max(gc);
bgr=max(gr);
max(full(sum(Jc')));
max(full(sum(Jr)));
rmax=max(full(sum(J)));
cmax=max(full(sum(J')));
if ((2*rmax <= bgc+2*bgr+1) & (2*rmax < cmax))
    Jr=J;
    Jc=sparse(m,n);
    Hr=spones(J*J');
    pr=id(Hr,full(sum(Hr)));
    gr=colorHess(Hr,pr);
    gc=ones(n,1);
end
if ((cmax <= bgc+2*bgr+1) & (cmax <= 2*rmax))
    Jc=J;
    Jr=sparse(m,n);
    Hc=spones(J'*J);
    pc=id(Hc,full(sum(Hc)));
    gc=colorHess(Hc,pc);
    gr=ones(m,1);
end
maxval=max(gc);
i=1;
while (i<=maxval)
    [j,l] = find(Jc(:,gc==i));
    if length(j)==0
        gc(find(gc==i))=zeros(sum(gc==i),1);
        if (i~= maxval)
            gc(find(gc==max(gc)))=i.*ones(sum(gc==max(gc)),1);
        end
        maxval=maxval-1;
    end
    i=i+1;
end
i=1;
maxval=max(gr);
while (i<=maxval)
    [j,l] = find(Jr(gr==i,:));
    if length(j)==0
        gr(find(gr==i))=zeros(sum(gr==i),1);
        if (i~= maxval)
            gr(find(gr==max(gr)))=i.*ones(sum(gr==max(gr)),1);
        end
        maxval=maxval-1;
    end
    i=i+1;
end
nrow=max(gr);
W = zeros(m,nrow);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check the sparsity for the lower triangular part
% nr = length(gr);
% nc = length(gc);
% for i = 1:nr
%     if gr(i) ~= 0
%         if sum(J(i,1:i)) == 0
%             gr(i) = 0;
%         elseif sum(J(i,1:i-1))==0 & J(i,i) ~= 0 & gc(i) ~= 0
%             gr(i) = 0;
%         end
%     end
% end
% 
% for i = 1:nc
%     if gc(i) ~= 0
%         if sum(J(i:m,i)) == 0
%             gc(i) = 0;
%         elseif sum(J(i+1:m,i))==0 & J(i,i) ~= 0 & gr(i) ~= 0
%             gc(i) = 0;
%         end
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

for k = 1:nrow
    W(:,k) = (gr == k);
end
ncol=max(gc);
V = zeros(n,ncol);
for k = 1:ncol
    V(:,k) = (gc == k);
end

JPI.Jc=Jc;
JPI.Jr=Jr;
JPI.gr=gr;
JPI.gc=gc;
JPI.V=V;
JPI.W=W;
