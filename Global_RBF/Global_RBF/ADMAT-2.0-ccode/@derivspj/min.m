function sout=min(s1,s2)
%
%
%  04/2007 -- removed unused variables
%  04/2007 -- avoid for loops
%
%   neither s1.val nor s2.val is a matrix.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

s1=derivspj(s1);
if nargin > 1
    s2=derivspj(s2);
    sout.val=min(s1.val,s2.val);
    sout.derivspj=zeros(length(sout.val),globp);
    I3=find(s1.val-s2.val > 0);
    I2=find(s1.val-s2.val == 0);
    I1=find(s1.val-s2.val < 0);
    if length(s1.val)==1               % s1.val is a scalar
        sout.derivspj=s2.derivspj;
        if ~isempty(I1) 
            sout.derivspj(I1,:)=s1.derivspj(ones(length(I1),1), :); 
        end
        m = length(I2);
        sout.derivspj(I2,:) = (s2.derivspj(I2,:) + s1.derivspj(ones(m,1),:))/2;
%         for j=1:length(I2) 
%             sout.derivspj(I2(j),:)=s2.derivspj(j,:)+s1.derivspj;
%         end
    elseif length(s2.val)==1           % s2.val is a scalar
        sout.derivspj=s1.derivspj;
        if ~isempty(I3) 
            sout.derivspj(I3,:)=s2.derivspj(ones(length(I3),1), :); 
        end
        m = length(I2);
        sout.derivspj(I2,:) = (s1.derivspj(I2,:) + s2.derivspj(ones(m,1),:))/2;
%         for j=1:length(I2) 
%             sout.derivspj(I2(j),:)=(s1.derivspj(j,:)+s2.derivspj)/2; 
%         end
    else
        sout.derivspj=s2.derivspj;
        if ~isempty(I1) 
            sout.derivspj(I1,:)=s1.derivspj(I1,:); 
        end
        if ~isempty(I2)
            sout.derivspj(I2,:)=(s1.derivspj(I2,:)+s2.derivspj(I2,:))./2; 
        end
    end
else
    [sout.val,I]=min(s1.val);
    sout.derivspj=s1.derivspj(I,:);
end
sout=class(sout,'derivspj');
