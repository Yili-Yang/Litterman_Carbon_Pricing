function sout=max(s1,s2)
%
%
%  04/2007 -- removed unused variables
%  04/2007 -- avoid for loops
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
if nargin > 1
    sout.val=max(s1.val,s2.val);
    sout.derivspj=sparse(length(sout.val),globp);
    I1=find(s1.val-s2.val > 0);
    I2=find(s1.val-s2.val == 0);
    I3=find(s1.val-s2.val < 0);
    if length(s1.val)==1           % s1.val is a scalar
        sout.derivspj = s2.derivspj;
        if ~isempty(I1)
            sout.derivspj(I1,:) = ...
                s1.derivspj(ones(length(I1),1),:);
        end
        sout.derivspj(I2,:) = ...
            (s1.derivspj(ones(length(I2),1), :) + s2.derivspj)/2;
%         for i=1:size(sout.derivspj,1)
%             sout.derivspj(i,:)=s1.derivspj+s2.derivspj(i,:);
%         end
    elseif length(s2.val)==1       % s2.val is a scalar
        sout.derivspj = s1.derivspj;
        if ~isempty(I3)
            sout.derivspj(I3,:) = s2.derivspj(ones(length(I3),1), :);
        end
        sout.derivspj(I2,:) = (s1.derivspj(I2,:) + ...
            s2.derivspj(ones(length(I2),1),:))/2;
%         for i=1:size(sout.derivspj,1)
%             sout.derivspj(i,:)=s1.derivspj(i,:)+s2.derivspj;
%         end
    else            % both are vectors 
        sout.derivspj=s2.derivspj;
        if ~isempty(I1)
            sout.derivspj(I1,:)=s1.derivspj(I1,:);
        end
        if ~isempty(I2)
            sout.derivspj(I2,:)=(s1.derivspj(I2,:)+s2.derivspj(I2,:))./2;
        end
    end
else
    [sout.val,I]=max(s1.val);
    sout.derivspj=s1.derivspj(I,:);
end

sout=class(sout,'derivspj');
