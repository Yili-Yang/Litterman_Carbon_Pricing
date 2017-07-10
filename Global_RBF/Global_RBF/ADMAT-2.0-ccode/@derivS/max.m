function [sout,I] = max(s1,s2)
%

%   03/2007 -- matrix operation is used to avoid
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a
%              column vector
%   03/2007 -- rearrange the program for readibilty
%   01/2010 -- add nondifferentiable points detecting.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivS(s1);
if nargin > 1
    s2=derivS(s2);
    if nargout ==2
        [sout,I]=max(s1.val,s2.val);
    else
        sout=max(s1.val,s2.val);
    end

    sout=derivS(sout);
    if size(sout.val,1)==1 || size(sout.val,2)==1      % sout.val is a vector
        I1=find(s1.val-s2.val > 0);
        I2=find(s1.val-s2.val == 0);

        I3=find(s1.val-s2.val < 0);
        if length(s1.val)==1
            sout.derivS=s2.derivS;
            if ~isempty(I1)
                sout.derivS(I1)=s1.derivS;
            end
            if isequal(s2.derivS(I2,:) , s1.derivS)
                sout.derivS(I2,:) = s1.derivS;
            else
                error('Nondifferentiable points in max() was detected.');
            end

            %             for j=1:length(I2)
            %                 sout.derivS(I2(j),:)=(s2.derivS(I2(j),:)+s1.derivS)./2;
            %             end
        elseif length(s2.val)==1
            sout.derivS=s1.derivS;
            if ~isempty(I3)
                sout.derivS(I3)=s2.derivS;
            end
            if isequal(s1.derivS(I2,:), s2.derivS)
                sout.derivS(I2,:) =  s2.derivS;
            else
                error('Nondifferentiable points in max() was detected.');
            end

            %             for j=1:length(I2)
            %                 sout.derivS(I2(j),:)=(s1.derivS(I2(j),:)+s2.derivS)/2;
            %             end
        else                    % both are vectors
            sout.derivS=s2.derivS;
            if ~isempty(I1)
                sout.derivS(I1,:)=s1.derivS(I1,:);
            end
            if ~isempty(I2)
                if isequal(s1.derivS(I2,:), s2.derivS(I2,:))
                    sout.derivS(I2,:)=s2.derivS(I2,:);
                else
                    error('Nondifferentiable points in max() was detected.');
                end

            end
        end


    else                        % sout.val is a matrix

        [I1,I1j]=find(s1.val-s2.val > 0);
        [I2,I2j]=find(s1.val-s2.val == 0);
        % non differentiable points checking

        [I3,I3j]=find(s1.val-s2.val < 0);

        if length(s1.val)==1              % s1.val is a scalar
            sout.derivS=s2.derivS;
            if ~isempty(I1)
                for j=1:length(I1)
                    sout.derivS(I1(j),I1j(j)) = s1.derivS;
                end;
            end
            %             sout.derivS(I2, I2j) = (s2.derivS(I2, I2j) + s1.derivS)./2;
            for j=1:length(I2)
                if isequal(s2.derivS(I2(j),I2j(j)), s1.derivS)
                    sout.derivS(I2(j),I2j(j))= s1.derivS;
                else
                    error('Nondifferentiable points in max() was detected.');
                end

            end

        elseif length(s2.val)==1           % s2.val is a scalar
            sout.derivS=s1.derivS;
            if ~isempty(I3)
                %                 sout.derivS(I3, I3j) = s2.derivS * ones(length(I3));
                for j=1:length(I3)
                    sout.derivS(I3(j),I3j(j))=s2.derivS;
                end
            end
            %               sout.derivS(I2, I2j) = (s1.derivS(I2, I2j) + s2.derivS)./2;
            for j=1:length(I2)
                if isequal(s1.derivS(I2(j),I2j(j)), s2.derivS)
                    sout.derivS(I2(j),I2j(j))= s2.derivS;
                else
                    error('Nondifferentiable points in max() was detected.');
                end

            end
        else                             % both s1.val and s2.val are matrices
            sout.derivS=s2.derivS;
            if ~isempty(I1)
                for j=1:length(I1)
                    sout.derivS(I1(j),I1j(j),:)=s1.derivS(I1(j),I1j(j),:);
                end
            end
            if ~isempty(I2)
                %                 sout.derivS(I2, I2j) = (s1.derivS(I2, I2j) + s2.derivS(I2, I2j))./2;
                for j=1: length(I2)
                    if isequal(s1.derivS(I2(j),I2j(j)), s2.derivS(I2(j),I2j(j)))
                        sout.derivS(I2(j),I2j(j))= s1.derivS(I2(j),I2j(j));
                    else
                        error('Nondifferentiable points in max() was detected.');
                    end

                end
            end
        end
    end
else                 % nargin == 1
    [sout.val,II]=max(s1.val);
    if length(sout.val) == 1
        sout.derivS=s1.derivS(II);
    else
        len = length(II);
        sout.derivS = zeros(1,len);
        for j = 1 : len
            sout.derivS(j) = s1.derivS(II(j), j);
        end
    end
    if nargout==2
        I=II;
    end
    sout=class(sout,'derivS');
end
