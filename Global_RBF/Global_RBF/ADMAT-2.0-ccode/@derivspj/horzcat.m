function sout=horzcat(varargin)
%
%
%  04/2007 -- removed unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

s1=varargin{1};
s1=derivspj(s1);
sout=s1;
for i=2:nargin
    s2=varargin{i};
    s2=derivspj(s2);
    sout.val=[sout.val s2.val];
    [m,n]=size(sout.val);
    if (m==1) && (n~=1)        % row vector
        try
            sout.derivspj=[sout.derivspj; s2.derivspj];
        catch
            keyboard
        end
        
    else
        temp = cell(globp,1); 
        if ~iscell(sout.derivspj) & ~iscell(s2.derivspj)
            for j=1:globp
                temp{j,1} = [sout.derivspj(:,j), s2.derivspj(:,j)];
            end 
            sout.derivspj=temp;
        elseif ~iscell(sout.derivspj)
            for j = 1: globp
                temp{j,1} = [sout.derivspj(:,j), s2.derivspj{j,1}];
            end
        elseif ~iscell(s2.derivspj)
            for j = 1 : globp
                temp{j,1} = [sout.derivspj{j,1}, s2.derivspj(:,j)];
            end
        else
            for j = 1 : globp
                temp{j,1} =  [sout.derivspj{j,1}, s2.derivspj{j,1}];
            end
        end
        sout.derivspj = temp;
        
    end
%         if ~iscell(sout.derivspj) 
%             temp=cell(m,1);
%             for j=1:m
%                 temp{j}=sout.derivspj(j,:); 
%             end
%             sout.derivspj=temp;
%         end
%         if ~iscell(s2.derivspj) 
%             temp=cell(m,1); 
%             for j=1:m 
%                 temp{j}=s2.derivspj(j,:); 
%             end
%             s2.derivspj=temp;
%         end
%         for j=1:m
%             sout.derivspj{j}=[sout.derivspj{j}; s2.derivspj{j}];
%         end
%     end
end
