function y=zeros(m,n,k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


switch nargin
    case 1            
        if isa(m, 'derivtape')
            m1 = getval(m);
        else
            m1 = m;
        end
        n1 = m1;
        k1 = 1;
    case 2
        if isa(m, 'derivtape')
            m1 = getval(m);
        else
            m1 = m;
        end
        if isa(n,'derivtape')
            n1 = getval(n);
        else
            n1 = n;
        end
        k1 = 1;
        
    case 3
        if isa(m, 'derivtape')
            m1 = getval(m);
        else
            m1 = m;
        end
        if isa(n,'derivtape')
            n1 = getval(n);
        else
            n1 = n;
        end
        if isa(k,'derivtape')
            k1 = getval(k);
        else
            k1 = k;
        end
end
if length(m1) == 2    
    n1 = m1(2);
    m1 = m1(1);
end
y=zeros(m1,n1, k1);
y=derivtape(y,0);
