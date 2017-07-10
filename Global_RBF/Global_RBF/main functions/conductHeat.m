function y = conductHeat(X,Extra)
    M = Extra.M;
    a = X(1:M); b = X((M+1):2*M); c = X((2*M+1):3*M);
    if length(X) == (3*M)
        u = Extra.u0;
    else
        u = [Extra.u0(1); X((3*M+1):end); Extra.u0(end)];
    end
    y = a.*u(1:(end-2)) + b.*u(2:(end-1)) + c.*u(3:end);
end