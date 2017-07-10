#include "mex.h"
#define A_IN 0
#define B_IN 1
#define C_OUT 0

extern void mexmult(int MA, int NA, double *A, int MB, 
                     int NB, double *B, double *C)
{
    int i,j,k;
    /* implement C = A*B */
    for(i=0; i<MA; i++)
    {
        for(j=0; j<NB; j++)
        {
            C[i+j*MA] =0.0;
            for(k=0; k<NA; k++)
            {
                C[i+j*MA] = C[i+j*MA] + (A[i+k*MA] * B[k+j*MB]);
            }
        }
    }
}

/* interface function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
    double *A, *B, *C;
    int MA, NA, MB, NB, MC, NC;
    if (nrhs != 2)
        mexErrMsgTxt("Two input required.");
    else if(nlhs > 1)
        mexErrMsgTxt("Too much output arguments");
    
    MA = mxGetM(prhs[A_IN]);
    NA = mxGetN(prhs[A_IN]);
    MB = mxGetM(prhs[B_IN]);
    NB = mxGetN(prhs[B_IN]);
    
    MC = MA;
    NC = NB;
    
    plhs[C_OUT] = mxCreateDoubleMatrix(MC, NC,mxREAL);
    
    A = mxGetPr(prhs[A_IN]);
    B = mxGetPr(prhs[B_IN]);
    C = mxGetPr(plhs[C_OUT]);
    
    mexmult(MA,NA,A,MB,NB,B,C);
    
    return;
}