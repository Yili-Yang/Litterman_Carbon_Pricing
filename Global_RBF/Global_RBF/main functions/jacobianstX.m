function [z,M] = jacobianstX(functions, X, dependency, Extra)
% requires ADMAT methods: ADfun, feval
% - - - - - - - - - - - - - - - - - - - - - - - - -
% jacobianstX computes the first derivatives of a structured computation
% z - output of the computation
% M - output of first derivative information in the form W^T*J*V 
%		where J is the Jacobian and W and V are optional matrices specified in Extra
%		by default W and V are identities
% functions - cell array of function names of each step of the computation
% X - column cell array of the initial inputs
% dependency - N-by-2 cell array of dependecy information of the steps of the computation
% Extra - optional structure containing any user defined parameter required by the computation
if ~iscell(X)
    [z,M] = jacobianst(functions, X, dependency, Extra);
    return
end

N_funs = size(functions,1);
assert( 1 == size(functions,2), 'functions must be a column cell of strings');
assert( N_funs == size(dependency,1), 'dependency of every function must be specified');

[N_x, nrow] = size(X);
assert( 1 == nrow, 'input X must be a column cell array');
[xDim, nrow] = size(cell2mat(X));
assert( 1 == nrow, 'each element of X must be a column vector');

Y = cell(N_funs,1);

for n = 1:N_funs
    input = [cell2mat(X(dependency{n,1})); cell2mat(Y(dependency{n,2}))];
    Y{n} = feval(functions{n}, input, Extra);
end
z = Y{end};

if isfield(Extra,'W')
    W = Extra.W;
    assert( size(W,1) == size(z,1), 'output dimension must equal that of the dual vector');
else
    W = speye(length(z));
end

idx_X = cell(length(X),1);  tail = 0;
for n = 1:length(X)
    idx_X{n} = (tail+1):(tail+length(X{n}));
    tail = tail + length(X{n});
end

JTW = zeros(xDim,size(W,2));
G = cell(N_funs,1);
G{N_funs} = W;

for n = N_funs:-1:1
    input = [cell2mat(X(dependency{n,1})); cell2mat(Y(dependency{n,2}))];
    AD_fun = ADfun(functions{n},size(Y{n},1));
    options = setopt('revprod',G{n});
    [~, w] = feval(AD_fun, input, Extra, options);
    if 1 == size(w,1)
        w = w';
    end
    
    idx = reshape(cell2mat(idx_X(dependency{n,1}))',1,[]);
    nx = length(idx);
    if 0 ~= nx
        JTW(idx,:) = JTW(idx,:) + w(1:nx,:);
    end

    head = nx + 1;
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