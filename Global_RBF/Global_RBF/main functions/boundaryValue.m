%% convert boundary values to the right hand side of A*u=b
function b = boundaryValue(x,Extra)
    if isfield(Extra,'M')
        M = Extra.M;
    else
        M = numel(x)/4;
    end
    if isfield(Extra,'b0')
        idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        b = cons(Extra.b0,x);
        b(idr) = b(idr) + x;
    else
        idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        b = sparse(idr,ones(4*M,1),x);
    end
end