function [argout1,argout2,argout3]= feval(fun,x,Extra,options)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

% global Lflag;
% 
% 
% if isempty(Lflag)
%     clear global currfun warningon globp tape varcounter fdeps ADhess wparm funtens tape_begin Lflag  LUflag backflag QRflag SVDflag  LUflag backflag QRflag SVDflag
%     error('ADMAT 2.0 licence  error . Please contact Cayuga Research for licence extension.\n');
% end

global currfun
n=length(x);
if nargin < 4
    options.JPI=[]; options.HPI=[]; options.func=[]; options.V=[]; options.W=[];
    options.EJPI=[]; options.EHPI=[]; options.fdata=[];
end
if nargin < 3 
    Extra=[];
end

if isequal(currfun.fun,fun.fun) 
    fun=currfun;
end

if isequal(fun.n,n)
    if ~isempty(Extra)
        fun.Extra=Extra;
    elseif ~isempty(fun.Extra)
        Extra=fun.Extra;
    end
%     if ~isempty(options.fdata)
%         fun.fdata=options.fdata;
%     end
end


if isempty(fun.class)

    if isempty(options.func)
        if fun.scalar ~= 1
            % Jacobian problem
            if nargout == 1
                argout1=feval(fun.fun,x,Extra);
            else
                if n > 10000
                    % using sparse structure to compute the Jacobian 
                    % matrix when n is larger than 20
                    JPI=[];
                    if length(x)~=1
                        if (isequal(fun.n,n) && ~isempty(fun.JPI))
                            JPI=fun.JPI;
                        end
                        if isempty(JPI)
                            if ~isempty(options.JPI) 
                                JPI=options.JPI;
                            else
                                JPI=getjpi(fun.fun,fun.scalar,n,Extra);
                            end
                            fun.JPI=JPI;
                        end
                    end
                    [argout1,argout2]=evalj(fun.fun,x,Extra,[],JPI);
                else
                    % using forward mode to compute the Jacobian matrix
                    % when n is less than 20
                    [argout1,argout2]=forwprod(fun.fun,x,eye(n),n,Extra);
                end
            end

        else
            % Hessian Problem
            if nargout == 1
                argout1=feval(fun.fun,x,Extra);
            elseif nargout==2
                [argout1,argout2]=funcval(fun.fun,x,Extra);
            else
                if n <= 10000                    %[argout1,argout2]=funcval(fun.fun,x,Extra);
                    [argout3, argout1, argout2]=HtimesV(fun.fun,x,eye(length(x)),Extra);
                else
                    % using sparse structure to compute the Hessian matrix
                    HPI=[];
                    if ~isequal(length(x),1)
                        if (isequal(fun.n,n) && ~isempty(fun.HPI))
                            HPI=fun.HPI;
                        end
                        if isempty(HPI)
                            if ~isempty(options.HPI) 
                                HPI=options.HPI;
                            else
                                HPI=gethpi(fun.fun,n,Extra);
                            end
                            fun.HPI=HPI;
                        end
                    end
                    [argout1,argout2,argout3]=evalh(fun.fun,x,Extra,HPI);
                end
            end

        end
    else
        % User might want to do some other function -- e.g HV, JV, WJ, sparsity pattern

        if isequal(options.func,'forwprod')
            [argout1,argout2]=forwprod(fun.fun,x,options.V,[],Extra);
        elseif isequal(options.func,'revprod')
            [argout1,argout2]=revprod(fun.fun,x,options.W,Extra);
        elseif isequal(options.func,'htimesv')
            argout1=HtimesV(fun.fun,x,options.V,Extra);
        elseif isequal(options.func,'jacsp')
            argout1=jacsp(fun.fun,[],n,Extra);
        else
            %hesssp
            argout1=hesssp(fun.fun,n,Extra);
        end
    end

end



fun.n=n;
currfun=fun;
