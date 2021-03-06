% run test on different settings of RBF model
fminl_matrix = [];
xmin1_matrix = [];
iter1_matrix = [];
xbar_min1_matrix = [];
fbar_min1_matrix = [];
y = py.Matlabmod.matlabmode();
for m =100:100:1000
    [fmin1,xmin1,iter1,xbar_min1,fbar_min1] = run_RBF(m,y);
    fminl_matrix = [fminl_matrix;fmin1];
    xmin1_matrix = [xmin1_matrix;xmin1];
    iter1_matrix = [iter1_matrix;iter1];
    xbar_min1_matrix = [xbar_min1_matrix;xbar_min1];
    fbar_min1_matrix = [fbar_min1_matrix;fbar_min1];
end
