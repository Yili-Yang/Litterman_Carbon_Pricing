/********************************************************
%
% Evaluate  the Broyden nonlinear equations test function.
%
%
% INPUT:
%       x - The current point (row vector).
%     
%
% OUTPUT:
%  y -    The (vector) function value at x. 
%
****************************************************************/

#include "mex.h"
#define x_IN 0
#define y_OUT 0

extern void mexbroy(int n, double *x, double *y)
{
    int i;
    y[0] = (3.0-2.0*x[0])*x[0]-2.0*x[1]+1.0;
    y[n-1] = (3.0-2.0*x[n-1])*x[n-1]-x[n-2]+1.0;
    
    for(i=1; i<n-1; i++)
        y[i]= (3.0 - 2.0*x[i])*x[i]-x[i-1]-2.0*x[i+1] + 1.0;        
    
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
    
    plhs[y_OUT] = mxCreateDoubleMatrix(n, 1, mxREAL);
    
    x = mxGetPr(prhs[x_IN]);
    y = mxGetPr(plhs[y_OUT]);
    
    mexbroy(n, x, y);
    
    return;
}
                        
