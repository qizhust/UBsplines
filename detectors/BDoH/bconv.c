#include"mex.h"
#include"matrix.h"
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include"mexutils.c"

void mexFunction(int nout,mxArray *out[],
				     int nin,const mxArray *in[])
{
    enum {IN_IC=0,IN_X,IN_Y,IN_G,IN_OR,IN_OC,IN_S};
    int iir,iic,wr,wc,or,oc,step,i,j,fl,pady,padx; 
    double tmp;
    double *x,*y,*ic,*g,*ico,*pic,*xx,*yy,*gg;
   
    if(nin != 7) 
        mexErrMsgTxt("Exactly seven input arguments required.");
    else if(nout > 1) 
    	mexErrMsgTxt("Too many output arguments.");
  
    if(mxGetNumberOfDimensions(in[IN_IC])!=2) 
        mexErrMsgTxt("Integrated image must be a two dimensional array");
  
    if(mxGetNumberOfDimensions(in[IN_X])!=2) 
        mexErrMsgTxt("X coordinate must be a two dimensional array");
  
    if(mxGetNumberOfDimensions(in[IN_Y])!=2) 
        mexErrMsgTxt("Y coordinate must be a two dimensional array");
  
    if(mxGetNumberOfDimensions(in[IN_G])!=2) 
        mexErrMsgTxt("Bspline kernel must be a two dimensional array");
  
    if(!uIsRealScalar(in[IN_OR])) 
        mexErrMsgTxt("Output image height should be a real scalar");
    
    if(!uIsRealScalar(in[IN_OC])) 
        mexErrMsgTxt("Output image width should be a real scalar");
    
    if(!uIsRealScalar(in[IN_S])) 
        mexErrMsgTxt("Step should be a real scalar");
    
    step = (int)(*(mxGetPr(in[IN_S])));
    or = (int)(*(mxGetPr(in[IN_OR])));
    oc = (int)(*(mxGetPr(in[IN_OC])));
    ic = mxGetPr(in[IN_IC]);
    x  = mxGetPr(in[IN_X]);
    y  = mxGetPr(in[IN_Y]);
    g  = mxGetPr(in[IN_G]);
    iir = mxGetM(in[IN_IC]);
    iic = mxGetN(in[IN_IC]);
    wr = mxGetM(in[IN_X]);
    wc = mxGetN(in[IN_Y]);
    
    pady = (iir-or)/2;
    padx = (iic-oc)/2;
    tmp = or;
    or = (int)ceil(tmp/step);
    tmp = oc;
    oc = (int)ceil(tmp/step);
    out[0] = mxCreateDoubleMatrix(or,oc,mxREAL);
    ico = mxGetPr(out[0]);
    
    pic = ic+padx*iir;
    for(j=1;j<=oc;j++)
    {
        double *ppic = pic+pady;
        for(i=1;i<=or;i++)
        {
            xx = x;
            yy = y;
            gg = g;
            for(fl=1;fl<=wr*wc;fl++)
            {
                *ico += *(ppic+(int)(*(yy++))+(int)(*(xx++))*iir)*(*(gg++));
            }
            ppic = ppic+step;
            ico++;
        }
        pic = pic+iir*step;
    }
}

