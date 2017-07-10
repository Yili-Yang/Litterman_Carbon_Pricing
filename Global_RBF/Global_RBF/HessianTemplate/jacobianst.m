function [z,M] = jacobianst(functions, x, dependency, Extra)
% requires ADMAT methods: ADfun, feval
% - - - - - - - - - - - - - - - - - - - - - - - - -
% jacobianst computes the first derivatives of a structured computation
% z - output of the computation
% M - output of first derivative information in the form W^T*J*V 
%		where J is the Jacobian and W and V are optional matrices specified in Extra
%		by default W and V are identities
% functions - cell array of function names of each step of the computation
% x - vector of initial input
% dependency - N-by-2 cell array of dependecy information of the steps of the computation
% Extra - optional structure containing any user defined parameter required by the computation

N_funs = size(functions,1);
assert( 1 == size(functions,2), 'functions must be a column cell of strings');
assert( N_funs == size(dependency,1), 'dependency of every function must be specified');

[xDim, nrow] = size(x);
assert( 1 == nrow, 'each element of X must be a column vector');

Y = cell(N_funs,1);

for n = 1:N_funs
    input = [x(1:end*dependency{n,1}); cell2mat(Y(dependency{n,2}))];
    Y{n} = feval(functions{n}, input, Extra);
end
z = Y{end};

if isfield(Extra,'W')
    W = Extra.W;
    assert( size(W,1) == size(z,1), 'output dimension must equal that of the dual vector');
else
    W = speye(length(z));
end

JTW = zeros(xDim,size(W,2));
G = cell(N_funs,1);
G{N_funs} = W;
for n = N_funs:-1:1
    input = [x(1:end*dependency{n,1}); cell2mat(Y(dependency{n,2}))];
    AD_fun = ADfun(functions{n},size(Y{n},1));
    options = setopt('revprod',G{n});
    [~, w] = feval(AD_fun, input, Extra, options);
    if 1 == size(w,1)
        w = w';
    end
    
    head = 1;
    if dependency{n,1}
        JTW(1:xDim,:) = JTW(1:xDim,:) + w(1:xDim,:);
        head = head + xDim;
    end
    
    for k = dependency{n,2}
        tail = head + size(Y{k},1) - 1;
        if isempty(G{k})
            G{k} = w(head:tail,:);
        else
            G{k} = G{k} + w(head:tail,:);
        end
        head = tail + 1;
    end
end
if isfield(Extra,'V')
    M = JTW'*Extra.V;
else
    M = JTW';
end