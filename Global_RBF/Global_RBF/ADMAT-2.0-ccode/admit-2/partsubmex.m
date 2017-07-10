function JPI=partsubmex(J)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINDS PARTITION AND COLORS THE GRAPH TOO : SUBSTUTUTION METHOD
%
% INPUT:
%       Jd= Structure of Jacobian Matrix
%
% OUTPUT :
%       Jr :-  Jr
%       Jc :-  Jc
%	gr : Groups for Jr
%	gc :-groups for Jc
%       roworcol, order :- Some details about the partition
%  
%
% 04/2007 -- removed unused variables
% o4/2007 -- using logical index for speed
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% J=spones(Jd);
[m,n]=size(J);


sumc=full(sum(J));
sumr=full(sum(J,2))';

currrowcount=0;
currcolcount=0;

order=zeros(m+n,1);
roworcol=zeros(m+n,1);


rowsconsideredcomp=linspace(1,m,m)';
%rowpoints=linspace(1,m,m)';
 
 
colsconsideredcomp=linspace(1,n,n)';
%colpoints=linspace(1,n,n)';


numrowscons=0;
numcolscons=0;


%Jr=sparse(m,n);
%Jc=sparse(m,n);
Jr=[];
Jc=[];


last=1;
colcons=zeros(0,0);
rowcons=zeros(0,0);

% rows=rowsconsideredcomp(1:m);
% cols=colsconsideredcomp(1:n);

%[incrrow,incrcol,Ic,Ir,row]=rowcolsub;
[colmin]=min(sumc);
[rowmin]=min(sumr);
incrrow=max(rowmin-currrowcount,0);
incrcol=max(colmin-currcolcount,0);
row=0;
if (incrrow < 2*incrcol) || (last == 1)
    row = 1;
end
if (row ==1 && numrowscons < m)
    last=1;
else
    last=0;
end
counter=1;
while (counter<=m+n)

    if (row ==1 && numrowscons < m)
        Ir=find(sumr-currrowcount<=incrrow);
        if (length(Ir) > 1)
            sumc=sumc-sum(J(Ir,:));
        else
            sumc=sumc-J(Ir,:);
        end
        sumr(Ir)=(m+n+1).*ones(1,length(Ir));
        counter=counter+length(Ir);
        order(counter-length(Ir):counter-1)= Ir;
        roworcol(counter-length(Ir):counter-1)=zeros(1,length(Ir));

        currrowcount=currrowcount+incrrow;
        rowsconsideredcomp(Ir)=zeros(1,length(Ir));
        numrowscons=numrowscons + length(Ir);
        rowcons(numrowscons-length(Ir)+1: numrowscons)=Ir;
        Jr=[Jr;
            J(Ir,colcons)];
        Jc=[Jc; sparse(length(Ir),numcolscons)];
        %rows=find(rowsconsideredcomp>0);

    else
        Ic=find(sumc-currcolcount<=incrcol);
        if (length(Ic) > 1)
            sumr=sumr-sum(J(:,Ic),2)';
        else
            sumr=sumr-J(:,Ic)';
        end
        counter=counter+length(Ic);
        order(counter-length(Ic):counter-1)= Ic;
        roworcol(counter-length(Ic):counter-1)=ones(1,length(Ic));
        sumc(Ic)=(m+n+1).*ones(1,length(Ic));
        currcolcount=currcolcount+incrcol;

        colsconsideredcomp(Ic)=zeros(1,length(Ic));

        numcolscons=numcolscons + length(Ic);
        colcons(numcolscons-length(Ic)+1:numcolscons)=Ic;
        Jc=[Jc J(rowcons,Ic)];
        Jr=[Jr sparse(numrowscons,length(Ic))];
        % cols=find(colsconsideredcomp>0);

    end

    if (counter <=m+n)
        %[incrrow,incrcol,Ic,Ir,row]=rowcolsub;
        [colmin]=min(sumc);
        [rowmin]=min(sumr);
        incrrow=max(rowmin-currrowcount,0);
        incrcol=max(colmin-currcolcount,0);
        row=0;
        if (incrrow < 2*incrcol) || (last == 1)
            row = 1;
        end
        if (row ==1 && numrowscons < m)
            last=1;
        else
            last=0;
        end
    end
end                  % end for While

if size(Jr,1) < m
    Jc=[Jc ; sparse(m-size(Jr,1),n)];
    Jr=[Jr; J(rowcons(size(Jr,1)+1:m),colcons)];
end

if size(Jr,2) < n
    Jc=[Jc J(rowcons,colcons(size(Jr,2)+1:n))];
    Jr=[Jr  sparse(m,n-size(Jr,2))];
end


[y,invpermrow]=sort(rowcons);
[y,invpermcol]=sort(colcons);
Jr=Jr(invpermrow,invpermcol);
Jc=Jc(invpermrow,invpermcol);


Hr=spones(Jr*Jr');
Hc=spones(Jc'*Jc);
%Hr=spones(Jr*Jr'+speye(m));
%Hc=spones(Jc'*Jc+speye(n));
pc=id(Hc,full(sum(Hc)));
pr=id(Hr,full(sum(Hr)));

gr=colorHess(Hr,pr);
gc=colorHess(Hc,pc);

% Also try Row and Column colorings
bgc=max(gc);
bgr=max(gr);
rmax=max(full(sum(J)));
cmax=max(full(sum(J, 2)));
if ((2*rmax <= bgc+2*bgr+1) && (2*rmax < cmax))
    Jr=J;
    Jc=sparse(m,n);
    Hr=spones(J*J');
    pr=id(Hr,full(sum(Hr)));
    gr=colorHess(Hr,pr);
    gc=ones(n,1);
end
if ((cmax <= bgc+2*bgr+1) && (cmax <= 2*rmax))
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
    j = find(Jc(:,gc==i));
    if isempty(j)
        gc(logical(gc==i))=zeros(sum(gc==i),1);
        if (i~= maxval)
            gc(logical(gc==max(gc)))=i.*ones(sum(gc==max(gc)),1);
        end
        maxval=maxval-1;
    end
    i=i+1;
end

maxval=max(gr);
i=1;
while (i<=maxval)

    j = find(Jr(gr==i,:));
    if isempty(j)
        gr(logical(gr==i))=zeros(sum(gr==i),1);
        if (i~= maxval)
            gr(logical(gr==max(gr)))=i.*ones(sum(gr==max(gr)),1);
        end
        maxval=maxval-1;
    end
    i=i+1;

end
rowcons=rowcons(:);
colcons=colcons(:);
invpermrow=invpermrow(:);
invpermcol=invpermcol(:);
nrow=max(gr);
W = zeros(m,nrow);
for k = 1:nrow
    W(:,k) = (gr == k);
end
ncol=max(gc);
V = zeros(n,ncol);
for k = 1:ncol
    V(:,k) = (gc == k);
end


x1=ncol;
x2=nrow;
A=sparse(m*x1+n*x2,nnz(J));
count=0;
if (x1 > 0)
    for i=1:m
        index=find(J(i,:));
        len=length(index);
        if (len > 0)
            A((i-1)*x1+1:i*x1,count+1:count+length(index))=V(index,:)';
        end
        count=count+len;
    end
end
count=0;
if (x2 > 0)
    for i=1:m
        index=find(J(i,:));
        len=length(index);
        for j=1:len
            A(m*x1+(index(j)-1)*x2+1:m*x1+(index(j))*x2, count+j)= W(i,:)';
        end
        count=count+len;
    end
end

p1=dmperm(A);
A=A(p1,:);
[p,q]=dmperm(A);
A=A(p,q);

JPI.Jc=Jc;
JPI.Jr=Jr;
JPI.gr=gr;
JPI.gc=gc;
JPI.order=order;
JPI.roworcol=roworcol;
JPI.rowcons=rowcons;
JPI.colcons=colcons;
JPI.invpermrow=invpermrow;
JPI.invpermcol=invpermcol;
JPI.p=p;
JPI.p1=p1;
JPI.q=q;
JPI.A=A;
JPI.V=V;
JPI.W=W;


