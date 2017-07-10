function a=subsasgncell(a,x,I1,I2)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
global globp;

[m]=size(a.derivspj,1);
if nargin == 3
    I=I1;
    if length(I) <= m
        for i=1:length(I)
            a.derivspj{I(i)}=x.derivspj{i};
        end
    else
        for i=1:length(I)
            jindex=ceil(I(i)/size(a.derivspj{1},1));
            iindex=I(i)-m*(jindex-1);
            a.derivspj{iindex}(jindex,:)=x.derivspj(i,:);
        end
    end

else
    if ~isempty(a)
%         if 0 %strcmp(I1,':')
%             %if iscell(x.derivspj)
%             
%             if length(x.derivspj) > 1
%                 for k = 1 : globp
%                     a.derivspj{k}(I1,I2) = x.derivspj{k}(I1,I2);
%                 end
%             elseif ndims(x.derivspj) == 2
%                 for k = 1:globp
%                     a.derivspj{k}(I1,I2) = x.derivspj(:,k);
%                 end
%             else
%                 for k = 1: globp
%                     a.derivspj{k}(I1,I2) = x.derivspj;
%                 end
%             end
% %             for k=1:globp
% %                 temp=x(k);
% %                 a.derivspj{k}(I2,:)=temp.derivspj;
% %             end
%         else
            if iscell(x.derivspj)
                for k=1:globp
                    a.derivspj{k}(I1,I2)=x.derivspj{k};
                end
            else
                if size(x.val,1) == 1
                    for k=1:globp
                        a.derivspj{k}(I1,I2)=x.derivspj(:,k)';
                    end
                elseif size(x.val,2) == 1
                    for k=1:globp
                        a.derivspj{k}(I1,I2)=x.derivspj(:,k);
                    end
                end
            end
        % end
    else
        for k=1:globp
            a.derivspj{k}(I1,I2)=x.derivspj; 
        end
    end
end
