/********************************************************
%
% Evaluate Brown nonlinear equations test function.
%
%
% INPUT:
%       x - The current point (column vector). When it is an
%           object of deriv class, the fundamental operations
%           will be overloaded automatically.
%     
%
% OUTPUT:
%  y -    The function value at x. When x  is an object
%         of deriv class, fvec will be an object of deriv class 
%         as well. There are two fields in fvec. One is the 
%         function value at x, the other is the gradient at x.
%
****************************************************************/

#include "mex.h"
#define x_IN 0
#define y_OUT 0

extern void mexbrown(int n, double *x, double *y)
{
    int i;
    double *tmp, val;
    tmp = (double *)malloc(n*sizeof(double));
    val = 0.0;
    
    for(i=0; i<n-1; i++)
    {
        tmp[i] = pow(x[i]*x[i], x[i+1]*x[i+1]+1.0);
        tmp[i] += pow(x[i+1]*x[i+1], x[i]*x[i]+1.0);
        val += tmp[i];
    }
    *y = val;
}

// Interface function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
    // define input and output variables
    double *x, *y;
    int n;
    if (nrhs != 1)
        mexErrMsgTxt("One input required");
    else if(nlhs >1)
        mexErrMsgTxt("Too many outpur argument");
    
    n = mxGetM(prhs[x_IN]);
    if (n == 1)
       n = mxGetN(prhs[x_IN]);
    
    plhs[y_OUT] = mxCreateDoubleMatrix(1, 1, mxREAL);
    
    x = mxGetPr(prhs[x_IN]);
    y = mxGetPr(plhs[y_OUT]);
    
    mexbrown(n, x, y);
    
    return;
}
                        
