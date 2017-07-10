function y = nextOptionValue(x,Extra)
    M = Extra.M;
    a = x(1:M); b = x((M+1):2*M); c = x((2*M+1):3*M);
    if length(x) == (3*Extra.M)
        u = Extra.u0;
    else
        u = [Extra.u0(1); x((3*Extra.M+1):end); Extra.u0(end)];
    end
    y = a.*u(1:(end-2)) + b.*u(2:(end-1)) + c.*u(3:end);
end