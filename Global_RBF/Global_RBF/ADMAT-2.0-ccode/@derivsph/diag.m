function out=diag(V, k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

V=derivsph(V);
[m,n]=size(V.val);

if ~isempty(getval(V))

    if m==1 || n==1            % V is a vector

        if nargin==1
            out.val=diag(V.val);
            out.derivsph = cell(globp);
            
            for i=1:globp
                for j = 1 : globp
                    out.derivsph{i,j}=diag(V.derivsph{i,j});
                end
            end
        else
            k=getval(k);
            out.val=diag(V.val,k);
            out.derivsph = cell(globp);
            for i=1:globp
                for j = 1 : globp
                out.derivsph{i,j}=diag(V.derivsph{i,j},k);
                end
            end
        end

    else              % V is a matrix
        
        if nargin==1
            out.val=diag(V.val);
            out.derivsph = cell(globp);
            for i=1:globp
                for j = 1 : globp
                    out.derivsph{i,j}=diag(V.derivsph{i,j});
                end
            end
        else
            k=getval(k);
            out.val=diag(V.val,k);
            out.derivsph = cell(globp);
            for i=1:globp
                for j = 1 : globp
                    out.derivsph{i,j}=diag(V.derivsph{i,j},k);
                end
            end
        end

    end
    out=class(out,'derivsph');

else
    out=[];
end

