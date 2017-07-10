function y = repmat(x,m,n)
global globp varcounter;
if nargin==2
    m=getval(m);
    n=getval(n);
elseif nargin==3
    m=getval(m);
    n=getval(n);
end
y.val=repmat(x.val,m,n);
[m1 n1]=size(getval(x));
if globp>1
    if m1==1 && n1==1
        if m>1 && n>1
            for i1=1:globp
                y.deriv(:,:,i1)=repmat(x.deriv(:,i1),m,n);
            end
        elseif m==1
            y.deriv=repmat(x.deriv,n,1);
        else
            y.deriv=repmat(x.deriv,m,1);
        end
    elseif m1==1
        if m>1 && n>1
            for i1=1:globp
                y.deriv(:,:,i1)=repmat(x.deriv(:,i1)',m,n);
            end
        elseif m==1
            y.deriv=repmat(x.deriv,n,1);
        else
            for i1=1:globp
                y.deriv(:,:,i1)=repmat(x.deriv(:,i1)',m,1);
            end
        end
    elseif n1==1
        if m>1 && n>1
            for i1=1:globp
                y.deriv(:,:,i1)=repmat(x.deriv(:,i1),m,n);
            end
        elseif m==1
            for i1=1:globp
                y.deriv(:,:,i1)=repmat(x.deriv(:,i1),1,n);
            end
        else
            y.deriv=repmat(x.deriv,m,1);
        end
    else
      for i1=1:globp
          y.deriv(:,:,i1)=repmat(x.deriv(:,:,i1),m,n);
      end
    end
end
y=class(y,'derivtapeH');
end
