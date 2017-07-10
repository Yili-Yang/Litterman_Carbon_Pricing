function adjreshape(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

mm=tape(i).arg2vc;
nn=tape(i).arg3vc;

if mm==1
    mm=nn;
    nn=1;
end

[m1,n1]=size(tape(tape(i).arg1vc).val);


[m,n]=size(tape(i).val);
if m > 1 && n > 1

    if m1 > 1 && n1 > 1
        for j=1:globp
            tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)+...
                reshape(tape(i).W(:,:,j),mm,nn);
        end
    else
        for j=1:globp
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+...
                reshape(tape(i).W(:,:,j),mm,nn);
        end
    end

else
    if m1 > 1 && n1 > 1
        for j=1:globp
            tape(tape(i).arg1vc).W(:,:,j)=tape(tape(i).arg1vc).W(:,:,j)+...
                reshape(tape(i).W(:,j),mm,nn);
        end
    else
        for j=1:globp
            tape(tape(i).arg1vc).W(:,j)=tape(tape(i).arg1vc).W(:,j)+...
                reshape(tape(i).W(:,j),mm,nn);
        end
    end
end
