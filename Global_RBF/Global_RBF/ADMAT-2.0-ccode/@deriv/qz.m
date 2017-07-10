function [AA, BB, Q, Z, V, W] = qz(A,B)

global globp;
global fdeps;

nA = size(getval(A),1);
nB = size(getval(B),1);
if nargout == 4
    if isa(A, 'deriv')
        [AA, BB, Q, Z] = qz(getval(A),B);
        
        T = getydot(A);
        DAA = zeros(nA,nA, globp);
        DBB = zeros(nA,nA, globp);
        DQ = zeros(nA,nA, globp);
        DZ = zeros(nA,nA, globp);
        for i = 1 : globp
            J = T(:,:,i);
            [AA1, BB1, Q1, Z1] = qz(getval(A)+fdeps*J, B);
            DAA(:,:,i) = (AA1-AA)/fdeps;
            DBB(:,:,i) = (BB1-BB)/fdeps;
            DQ(:,:,i) = (Q1-Q)/fdeps;
            DZ(:,:,i) = (Z1-Z)/fdeps;
        end
        AA = deriv(AA, DAA);
        BB = deriv(BB, DBB);
        Q = deriv(Q, DQ);
        Z = deriv(Z, DZ);
    elseif isa(B, 'deriv')
        [AA, BB, Q, Z] = qz(A,getval(B));
        T = getydot(B);
        DAA = zeros(nB,nB, globp);
        DBB = zeros(nB,nB, globp);
        DQ = zeros(nB,nB, globp);
        DZ = zeros(nB,nB, globp);
        for i = 1 : globp
            J = T(:,:,i);
            [AA1, BB1, Q1, Z1] = qz(A, getval(B)+fdeps*J);
            DAA(:,:,i) = (AA1-AA)/fdeps;
            DBB(:,:,i) = (BB1-BB)/fdeps;
            DQ(:,:,i) = (Q1-Q)/fdeps;
            DZ(:,:,i) = (Z1-Z)/fdeps;
        end
        AA = deriv(AA, DAA);
        BB = deriv(BB, DBB);
        Q = deriv(Q, DQ);
        Z = deriv(Z, DZ);   
    else
        [AA, BB, Q, Z] = qz(A,B);
    end
        
elseif nargout == 6
    if isa(A, 'deriv')
        [AA, BB, Q, Z, V, W] = qz(getval(A),B);
        T = getydot(A);
        DAA = zeros(nA,nA, globp);
        DBB = zeros(nA,nA, globp);
        DQ = zeros(nA,nA, globp);
        DZ = zeros(nA,nA, globp);
        DV = zeros(nA,nA, globp);
        DW = zeros(nA,nA, globp);
        for i = 1 : globp
            J = T(:,:,i);
            [AA1, BB1, Q1, Z1, V1, W1] = qz(getval(A)+fdeps*J, B);
            DAA(:,:,i) = (AA1-AA)/fdeps;
            DBB(:,:,i) = (BB1-BB)/fdeps;
            DQ(:,:,i) = (Q1-Q)/fdeps;
            DZ(:,:,i) = (Z1-Z)/fdeps;
            DV(:,:,i) = (V1-V)/fdeps;
            DW(:,:,i) = (W1-W)/fdeps;
        end
        AA = deriv(AA, DAA);
        BB = deriv(BB, DBB);
        Q = deriv(Q, DQ);
        Z = deriv(Z, DZ);
        V = deriv(V, DV);
        W = deriv(W, DW);
    elseif isa(B, 'deriv')
        [AA, BB, Q, Z, V, W] = qz(A,getval(B));
        T = getydot(B);
        DAA = zeros(nB,nB, globp);
        DBB = zeros(nB,nB, globp);
        DQ = zeros(nB,nB, globp);
        DZ = zeros(nB,nB, globp);
        DV = zeros(nB,nB, globp);
        DW = zeros(nB,nB, globp);
        for i = 1 : globp
            J = T(:,:,i);
            [AA1, BB1, Q1, Z1, V1, W1] = qz(A, getval(B)+fdeps*J);
            DAA(:,:,i) = (AA1-AA)/fdeps;
            DBB(:,:,i) = (BB1-BB)/fdeps;
            DQ(:,:,i) = (Q1-Q)/fdeps;
            DZ(:,:,i) = (Z1-Z)/fdeps;
            DV(:,:,i) = (V1-V)/fdeps;
            DW(:,:,i) = (W1-W)/fdeps;
        end
        AA = deriv(AA, DAA);
        BB = deriv(BB, DBB);
        Q = deriv(Q, DQ);
        Z = deriv(Z, DZ);  
        V = deriv(V, DV);
        W = deriv(W, DW);
    else
        [AA, BB, Q, Z, V, W] = qz(A,B);
    end
    
end