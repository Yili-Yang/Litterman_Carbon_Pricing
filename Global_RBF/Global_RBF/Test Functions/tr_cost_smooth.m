function [val,der1,der2] = tr_cost_smooth(epsinon,m_posi,k_posi,x,m_nega,k_nega)

m_posi = m_posi(k_posi~=0);
k_posi = k_posi(k_posi~=0);

if nargin>4
    m_nega = m_nega(k_nega~=0);
    k_nega = k_nega(k_nega~=0);
end


% calculating for boundaries and heights
if size(k_posi,1) > 1
    %boundaries_pos = [1;k_posi];
    boundaries_pos = k_posi;
    heights_pos = [0;(boundaries_pos(2:end)-boundaries_pos(1:end-1)).*m_posi(1:end-1)];
else
    boundaries_pos = k_posi;
    heights_pos = [0,(boundaries_pos(2:end)-boundaries_pos(1:end-1)).*m_posi(1:end-1)];
end
heights_pos = cumsum(heights_pos);


% calculation of values

% straight parts
cond = (x<=boundaries_pos(1));
val(cond) = 0;
for i=1:length(boundaries_pos)-1
    cond = (x>=boundaries_pos(i)&x<=boundaries_pos(i+1));
    val(cond) = heights_pos(i) + (x(cond)-boundaries_pos(i))*m_posi(i);
end
cond = x>=boundaries_pos(end);
val(cond) = heights_pos(end) + (x(cond)-boundaries_pos(end))*m_posi(end);

% smoothing parts
cond = (x>=boundaries_pos(1)-epsinon&x<=boundaries_pos(1)+epsinon);
x_local = x(cond)-boundaries_pos(1);
factor_local = m_posi(1)/4/epsinon;
b_local = 2*epsinon;
c_local = epsinon^2;
val(cond) = heights_pos(1) + factor_local*(x_local.^2+b_local*x_local+c_local);
for i=2:length(boundaries_pos)
    cond = (x>=boundaries_pos(i)-epsinon&x<=boundaries_pos(i)+epsinon);
    x_local = x(cond)-boundaries_pos(i);
    factor_local = (m_posi(i)-m_posi(i-1))/4/epsinon;
    b_local = 2*epsinon*(m_posi(i)+m_posi(i-1))/(m_posi(i)-m_posi(i-1));
    c_local = epsinon^2;
    val(cond) = heights_pos(i) + factor_local*(x_local.^2+b_local*x_local+c_local);
end

% negative axis
if nargin>4
    if size(k_nega,1) > 1
        %boundaries_nega = [-1;k_nega];
        boundaries_nega = k_nega;
        heights_nega = [0;(boundaries_nega(2:end)-boundaries_nega(1:end-1)).*m_nega(1:end-1)];
    else
        %boundaries_nega = [-1,k_nega];
        boundaries_nega = k_nega;
        heights_nega = [0,(boundaries_nega(2:end)-boundaries_nega(1:end-1)).*m_nega(1:end-1)];
    end
    
    cond = (x>=boundaries_nega(1)&x<=boundaries_pos(1));
    val(cond) = 0;
    
    heights_nega = cumsum(heights_nega);
    
    for i=1:length(boundaries_nega)-1
        cond = (x>=boundaries_nega(i+1)&x<=boundaries_nega(i));
        val(cond) = heights_nega(i) + (x(cond)-boundaries_nega(i))*m_nega(i);
    end
    cond = x<=boundaries_nega(end);
    val(cond) = heights_nega(end) + (x(cond)-boundaries_nega(end))*m_nega(end);
    
    % smoothing
    cond = (x>=boundaries_nega(1)-epsinon&x<=boundaries_nega(1)+epsinon);
    x_local = x(cond)-boundaries_nega(1);
    factor_local = -m_nega(1)/4/epsinon;
    b_local = -2*epsinon;
    c_local = epsinon^2;
    val(cond) = heights_nega(1) + factor_local*(x_local.^2+b_local*x_local+c_local);
    for i=2:length(boundaries_nega)
        cond = (x>=boundaries_nega(i)-epsinon&x<=boundaries_nega(i)+epsinon);
        x_local = x(cond)-boundaries_nega(i);
        factor_local = (m_nega(i-1)-m_nega(i))/4/epsinon;
        b_local = 2*epsinon*(m_nega(i-1)+m_nega(i))/(m_nega(i-1)-m_nega(i));
        c_local = epsinon^2;
        val(cond) = heights_nega(i) + factor_local*(x_local.^2+b_local*x_local+c_local);
    end
end

% computing der1 (first order derivative)
if nargout > 1
    cond = (x<=boundaries_pos(1));
    der1(cond) = 0;
    for i=1:length(boundaries_pos)-1
        cond = (x>=boundaries_pos(i)&x<=boundaries_pos(i+1));
        der1(cond) = m_posi(i);
    end
    cond = x>=boundaries_pos(end);
    der1(cond) = m_posi(end);

    % smoothing
    cond = (x>=boundaries_pos(1)-epsinon&x<=boundaries_pos(1)+epsinon);
    x_local = x(cond)-boundaries_pos(1);
    factor_local = m_posi(1)/4/epsinon;
    b_local = 2*epsinon;
    der1(cond) = factor_local*(x_local*2+b_local);
    for i=2:length(boundaries_pos)
        cond = (x>=boundaries_pos(i)-epsinon&x<=boundaries_pos(i)+epsinon);
        x_local = x(cond)-boundaries_pos(i);
        factor_local = (m_posi(i)-m_posi(i-1))/4/epsinon;
        b_local = 2*epsinon*(m_posi(i)+m_posi(i-1))/(m_posi(i)-m_posi(i-1));
        der1(cond) = factor_local*(2*x_local+b_local);
    end
    
    % negative axis
    if nargin>4

        cond = (x>=boundaries_nega(1)&x<=boundaries_pos(1));
        der1(cond) = 0;
        
        for i=1:length(boundaries_nega)-1
            cond = (x>=boundaries_nega(i+1)&x<=boundaries_nega(i));
            der1(cond) = m_nega(i);
        end
        
        cond = x<=boundaries_nega(end);
        der1(cond) = m_nega(end);
        
%         display('here!!');
%         display(cond);
% 
%         display(nargout);
%         display(nargin);
%         display(x);
%         display(boundaries_nega);
%         display(val);
%         display(der1);
        
        % smoothing
        cond = (x>=boundaries_nega(1)-epsinon&x<=boundaries_nega(1)+epsinon);
        x_local = x(cond)-boundaries_nega(1);
        factor_local = -m_nega(1)/4/epsinon;
        b_local = -2*epsinon;
        der1(cond) = factor_local*(x_local*2+b_local);
        for i=2:length(boundaries_nega)
            cond = (x>=boundaries_nega(i)-epsinon&x<=boundaries_nega(i)+epsinon);
            x_local = x(cond)-boundaries_nega(i);
            factor_local = (m_nega(i-1)-m_nega(i))/4/epsinon;
            b_local = 2*epsinon*(m_nega(i-1)+m_nega(i))/(m_nega(i-1)-m_nega(i));
            der1(cond) = factor_local*(x_local*2+b_local);
        end
    end
end

% computing der2 (2nd order derivative)
if nargout > 2
    der2 = der1;
    der2(:) = 0;

    % smoothing
    cond = (x>=boundaries_pos(1)-epsinon&x<=boundaries_pos(1)+epsinon);
    factor_local = m_posi(1)/4/epsinon;
    der2(cond) = factor_local*2;
    for i=2:length(boundaries_pos)
        cond = (x>=boundaries_pos(i)-epsinon&x<=boundaries_pos(i)+epsinon);
        factor_local = (m_posi(i)-m_posi(i-1))/4/epsinon;
        der2(cond) = factor_local*2;
    end
    
    % negative axis
    if nargin>4
        % smoothing
        cond = (x>boundaries_nega(1)-epsinon&x<=boundaries_nega(1)+epsinon);
        factor_local = -m_nega(1)/4/epsinon;
        der2(cond) = factor_local*2;
        for i=2:length(boundaries_nega)
            cond = (x>boundaries_nega(i)-epsinon&x<=boundaries_nega(i)+epsinon);
            factor_local = (m_nega(i-1)-m_nega(i))/4/epsinon;
            der2(cond) = factor_local*2;
        end
    end
end
end