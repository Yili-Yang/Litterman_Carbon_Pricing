#include <stdio.h>
#include <math.h>
#include <malloc.h>
#include "mex.h"


/*#define DEBUG*/

#include "sumdat.h"


void
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{	
	int IIc,j;
double max;	
double *sumc;
int n,k;
int nnz;
int rhoc;
int *ir;
int *jc;





n = mxGetN(prhs[0]);
plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);

sumc=(double *)calloc(n,sizeof(double));
memcpy((char *)sumc,(char *)mxGetPr(prhs[1]),n*sizeof(double));

rhoc=n;

j=0;
max=sumc[j];
for (k=0;k<n;k++){
	if (sumc[k]>max){
		j=k;	max=sumc[k];}
	sumc[k]=n;
}
sumc[j]=n-1;
nnz=mxGetNzmax(prhs[0]);


ir=(int *)calloc(nnz,sizeof(int));
memcpy((char *)ir,(char *)mxGetIr(prhs[0]),nnz*sizeof(int));

jc=(int *)calloc(n,sizeof(int));
memcpy((char *)jc,(char *)mxGetJc(prhs[0]),n*sizeof(int));


initialise(rhoc,sumc,n,ROW);


for (j=0;j<n;j++)
{

IIc=mydeletemin(ROW,1);

if (IIc!=n-1)
decreasekeylist(&ir[jc[IIc]],(jc[IIc+1]-jc[IIc]),ROW);
else
decreasekeylist(&ir[jc[IIc]],(nnz-jc[IIc]),ROW);

*(mxGetPr(plhs[0])+j)=(double)(IIc+1);
}

free(ir);
free(jc);
free(sumc);
}

