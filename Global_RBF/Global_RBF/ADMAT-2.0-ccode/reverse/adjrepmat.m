function adjrepmat(i)
global globp tape;
[m1 n1]=size(tape(i).val);[m2 n2]=size(tape(tape(i).arg1vc).val);
m=tape(i).arg2vc;
if isempty(tape(i).arg3vc)
    n=tape(i).arg2vc;
else
    n=tape(i).arg3vc;
end
if globp==1
    if m2==1 && n2==1
       if m>1 && n>1
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(sum(tape(i).W));
       else
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(tape(i).W);
       end
    elseif m2==1
        if m>1 && n>1
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(reshape(sum(tape(i).W),n2,n),2);
        elseif m>1
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+(sum(tape(i).W))';
        else
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(reshape(tape(i).W,n2,n),2);
        end
    elseif n2==1
        if m>1 && n>1
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(reshape(sum(tape(i).W,2),m2,m),2);
        elseif m>1
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(reshape(tape(i).W,m2,m),2);
        else
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(tape(i).W,2);
        end
    else
        if m>1 && n>1
            v1=repmat(speye(m2),1,m);v2=repmat(speye(n2),n,1);
            tmp=v1*tape(i).W*v2;
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tmp;
            if ~issparse(tape(tape(i).arg1vc).val)
                tape(tape(i).arg1vc).W=full(tape(tape(i).arg1vc).W);
            end
        elseif m>1
            v1=repmat(speye(m2),1,m);
            tmp=v1*tape(i).W;
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tmp;
            if ~issparse(tape(tape(i).arg1vc).val)
                tape(tape(i).arg1vc).W=full(tape(tape(i).arg1vc).W);
            end
        else
            v2=repmat(speye(n2),n,1);
            tmp=tape(i).W*v2;
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tmp;
            if ~issparse(tape(tape(i).arg1vc).val)
                tape(tape(i).arg1vc).W=full(tape(tape(i).arg1vc).W);
            end
        end
    end
else
   if m2==1 && n2==1
       if m>1 && n>1
           tmp=sum(sum(tape(i).W));
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(tmp,1,globp);
       else
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(tape(i).W);
       end
   elseif m2==1
       if m>1 && n>1
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+...
                                reshape(sum(reshape(sum(tape(i).W),n2,n,globp),2),n2,globp);
       elseif m==1
           v1=repmat(speye(n2),1,n);
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+v1*tape(i).W;
           if ~issparse(tape(tape(i).arg1vc).val)
               tape(tape(i).arg1vc).W=full(tape(tape(i).arg1vc).W);
           end
       else
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(sum(tape(i).W),n2,globp);
       end
   elseif n2==1
       if m>1 && n>1
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(sum(reshape(sum(tape(i).W,2),m2,m,globp),2),m2,globp);
       elseif m>1
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(sum(reshape(tape(i).W,m2,m,globp),2),m2,globp);
       elseif n>1
           tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+reshape(sum(tape(i).W,2),m2,globp);
       end
   else
       if m>1 && n>1
       v1=repmat(speye(m2),1,m);v2=repmat(speye(n2),n,1);
           for i1=1:globp
            tape(tape(i).arg1vc).W(:,:,i1)=tape(tape(i).arg1vc).W(:,:,i1)+v1*tape(i).W(:,:,i1)*v2;
           end
       elseif m>1
           v1=repmat(speye(m2),1,m); 
           for i1=1:globp
               tape(tape(i).arg1vc).W(:,:,i1)=tape(tape(i).arg1vc).W(:,:,i1)+v1*tape(i).W(:,:,i1);
           end
       else
            v2=repmat(speye(n2),n,1);
           for i1=1:globp
            tape(tape(i).arg1vc).W(:,:,i1)=tape(tape(i).arg1vc).W(:,:,i1)+tape(i).W(:,:,i1)*v2;
           end
       end
   end
end
end