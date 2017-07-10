function sout=subsref(x,s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
global tape;

if ~isa(x, 'derivtapeH')
    x=derivtapeH(x,0);
end

if length(s1.subs)==1
    I=s1.subs{1};
    if isa(I,'derivtapeH') 
        I=getval(I.val); 
    end
    if ~isempty(I)
        sout.val = x.val(I);
        %sout=derivtapeH(sout,0);
        [m,n]=size(getval(x));
        if (m==1) 
            m=n;
        end
        if (max(I) <= m)
            sout.deriv = x.deriv(I,:);
        elseif (I == ':')
            sout.deriv=x.deriv(I);
        else
            for i=1:length(I)
                jindex=ceil(I(i)/n);
                iindex=I(i)-m*(jindex-1);
                sout.deriv(i,:)=x.deriv(iindex,jindex,:);
            end
        end
    else
        sout=[];
    end

else
    I1=s1.subs{1};
    I2=s1.subs{2};
    if isa(I1,'derivtapeH') 
        I1=getval(I1.val);
    end
    if isa(I2,'derivtapeH') 
        I2=getval(I2.val);
    end
    if ~isempty(I1) && ~isempty(I2)
        sout.val=x.val(I1,I2);
        [p,q]=size(getval(sout.val));
        if p == 1 && q == 1   % sout.val is a scalar
            if strcmp(I1, ':') || I1 == 1  % case for x(:,i) and x is a row vector
                sout.deriv = x.deriv(I2, :);
            elseif strcmp(I2, ':')  || I2 == 1 % case for x(i,:) and x is a column vector
                sout.deriv = x.deriv(I1,:);
            else %  case for x(i,i) and x is a matrix
                for i = 1 : globp
                    sout.deriv(:,i) = x.deriv(I1,I2,i);
                end
            end
        elseif p==1 || q==1
            if ndims(getval(x.deriv)) == 3
                flagmatrix = 0;
                if strcmp(I1, ':')  % Z(:, i:j)
                    sout.deriv = zeros(size(getval(x.deriv),1),globp);
                elseif strcmp(I2, ':') % Z(i:j, :)
                    sout.deriv = zeros(size(getval(x.deriv),2),globp);
                elseif length(I2) == 1  % Z(i:j, k)
                    sout.deriv = zeros(length(I1),globp);
                elseif length(I1) == 1 % Z(k,i:j)
                    sout.deriv = zeros(length(I2), globp);
                else   % Z(i:j, k:p)
                    sout.deriv = zeros(length(I1), length(I2), globp);
                    flagmatrix = 1;
                end
                sout.deriv = cons(sout.deriv,x.deriv);
                if flagmatrix == 0
                    for i=1:globp
                        tmp = x.deriv(I1,I2,i);
                        sout.deriv(:,i)= tmp(:);
                    end
                else
                    for i = 1: globp
                        tmp = x.deriv(I1,I2,i);
                        sout.deriv(:,:,i) = tmp;
                    end
                end
            else
                if  size(getval(x.deriv),1) == 1    % row vector
                    if strcmp(I2, ':')
                        sout.deriv = x.deriv;
                    else
                        sout.deriv = x.deriv(I1,I2);
                    end
                elseif size(getval(x.deriv),2) == 1  % column vector
                    if strcmp(I1, ':')
                        sout.deriv = x.deriv;
                    else
                        sout.deriv = x.deriv(I1, I2);
                    end
                else   % matrix       
                    if p == 1  % row vector
                    sout.deriv = x.deriv(:,I2);
                    elseif q == 1 % column vector
                        sout.deriv = x.deriv(I1,:);
                    end
                end
            end
        else
            [px, qx] = size(getval(x.val));
            if px == 1 || qx == 1      % sout.val is expanded from a vector
                for i=1:globp
                    sout.deriv(:,:,i)=x.deriv(I1,I2);
                end
            else
                for i=1:globp
                    sout.deriv(:,:,i)=x.deriv(I1,I2,i);
                end
            end

        end
        p = size(getval(sout.val),1);
        if p==1 && globp==1
            if isreal(I1) 
               sout.deriv=x.deriv(I1,:)';
            else
               sout.deriv=x.deriv(:);
            end
        end
       
    else
        sout=[];
    end
end
if ~isempty(sout) 
  sout=class(sout, 'derivtapeH');
end
