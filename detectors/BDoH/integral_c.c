#include"mex.h"
#include"matrix.h"
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include"mexutils.c"

int integral_x(double* c, int rows, int cols)
{
    int i,j;
    for(i=1;i<=rows;i++)
        for(j=2;j<=cols;j++)
            *(c+(i-1)+(j-1)*rows) += *(c+(i-1)+(j-2)*rows);
}

int integral_y(double* c, int rows, int cols)
{
    int i,j;
    for(j=1;j<=cols;j++)
        for(i=2;i<=rows;i++)
            *(c+(i-1)+(j-1)*rows) += *(c+(i-2)+(j-1)*rows);
}

void mexFunction(int nout,mxArray *out[],
				     int nin,const mxArray *in[])
{
    enum {IN_C=0,IN_XT,IN_YT};
    int rows,cols,xt,yt,i,j; 
    double *c,*ic;
    
    xt   = (int)(*(mxGetPr(in[IN_XT])));
    yt   = (int)(*(mxGetPr(in[IN_YT])));
    c    = mxGetPr(in[IN_C]);
    rows = mxGetM(in[IN_C]);
    cols = mxGetN(in[IN_C]);

    out[0] = mxCreateDoubleMatrix(rows,cols,mxREAL);
    ic = mxGetPr(out[0]);
    memcpy(ic,c,rows*cols*sizeof(double));
    for(i=1;i<=xt;i++)
        integral_x(ic,rows,cols);
    for(i=1;i<=yt;i++)
        integral_y(ic,rows,cols);    
}

