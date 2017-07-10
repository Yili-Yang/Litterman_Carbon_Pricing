function out=diag(V, k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

V=derivspj(V);
[m,n]=size(V.val);

if ~isempty(getval(V))

    if m==1 || n==1            % V is a vector

        if nargin==1
            out.val=diag(V.val);
            out.derivspj = cell(globp,1);
            for i=1:globp
                out.derivspj{i}=diag(V.derivspj(:,i));
            end
        else
            k=getval(k);
            out.val=diag(V.val,k);
            out.derivspj = cell(globp,1);
            for i=1:globp
                out.derivspj{i}=diag(V.derivspj(:,i),k);
            end
        end

    else              % V is a matrix
        
        if nargin==1
            out.val=diag(V.val);
            for i=1:globp
                out.derivspj(:,i)=diag(V.derivspj{i});
            end
        else
            k=getval(k);
            out.val=diag(V.val,k);
            for i=1:globp
                out.derivspj(:,i)=diag(V.derivspj{i},k);
            end
        end

    end
    out=class(out,'derivspj');

else
    out=[];
end
