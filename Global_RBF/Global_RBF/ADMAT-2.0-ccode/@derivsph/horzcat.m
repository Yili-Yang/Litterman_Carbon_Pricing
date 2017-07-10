function sout=horzcat(varargin)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

s1=varargin{1};
s1=derivsph(s1);
sout=s1;
if nargin > 1
    for i=2:nargin
        s2=varargin{i};
        s2=derivsph(s2);
        sout.val=[sout.val s2.val];
        if ~iscell(sout.derivsph) & ~iscell(s2.derivsph)
            tmp = cell(globp, globp);
            for i = 1: globp
                for j = 1:globp
                    tmp{i,j} = [sout.derivsph(i,j) s2.derivsph(i,j)];
                end
            end                    
            sout.derivsph = tmp;
        else
            sout.derivsph=horzcatcell(sout.derivsph,s2.derivsph);
        end
    end
end
