#include "mex.h"
#include "matrix.h"
#include<stdio.h>
#include<string.h>
#include<math.h>

int Ffun(double* c, double x, double y, double j, double k)
{
    double Fjk_0, Fjk_x, Fjk_y, Fjk_yx, Fjk_xy;
    
    Fjk_0 = 1.0 - (x-j)*(x-j) - (y-k)*(y-k);
    
    if (x >= (j-3/2.0) && x < (j-1/2.0)){
        Fjk_x = (x-j+1/2.0)*(x-j+1/2.0);
    }
    else if (x >= (j-1/2.0) && x <= (j+1/2.0)){
        Fjk_x = 0;
    }
    else if (x > (j+1/2.0) && x <= (j+3/2.0)){
        Fjk_x = (x-j-1/2.0)*(x-j-1/2.0);
    }
    else{
        Fjk_x = 0;
        printf("Fjk_x (%.4f, %.4f, %.4f, %.4f) error...\n",x,y,j,k);
    }
    
    if (y >= (k-3/2.0) && y < (k-1/2.0)){
        Fjk_y = (y-k+1/2.0)*(y-k+1/2.0);
    }
    else if (y >= (k-1/2.0) && y <= (k+1/2.0)){
        Fjk_y = 0;
    }
    else if (y > (k+1/2.0) && y <= (k+3/2.0)){
        Fjk_y = (y-k-1/2.0)*(y-k-1/2.0);
    }
    else{
        Fjk_y = 0;
        printf("Fjk_y (%.4f, %.4f, %.4f, %.4f) error...\n",x,y,j,k);
    }
    
    if ((y-x) >= (k-j-2) && (y-x) < (k-j-1)){
        Fjk_yx = (y-x+j-k+1)*(y-x+j-k+1)/2.0;
    }
    else if ((y-x) >= (k-j-1) && (y-x) <= (k-j+1)){
        Fjk_yx = 0;
    }
    else if ((y-x) > (k-j+1) && (y-x) <= (k-j+2)){
        Fjk_yx = (y-x+j-k-1)*(y-x+j-k-1)/2.0;
    }
    else{
        Fjk_yx = 0;
        printf("Fjk_yx (%.4f, %.4f, %.4f, %.4f) error...\n",x,y,j,k);
    }
    
    if ( (x+y) >= (j+k-2) && (x+y) < (j+k-1) ){
        Fjk_xy = (x+y-j-k+1)*(x+y-j-k+1)/2.0;
    }
    else if ( (x+y) >= (j+k-1) && (x+y) <= (j+k+1) ){
        Fjk_xy = 0;
    }
    else if ( (x+y) > (j+k+1) && (x+y) <= (j+k+2) ){
        Fjk_xy = (x+y-j-k-1)*(x+y-j-k-1)/2.0;
    }
    else{
        Fjk_xy = 0;
        printf("Fjk_xy (%.4f, %.4f, %.4f, %.4f) error...\n",x,y,j,k);
    }

    *c = Fjk_0 + Fjk_x + Fjk_y + Fjk_xy + Fjk_yx;
}

void mexFunction(int nout, mxArray *out[],
                 int nin, const mxArray *in[])
{
    int rows, cols, i, j, k, m, x1_int, x2_int, xtmp, ytmp;
    double x1_curr, x2_curr, res1=0, res2=0, delta_x1, delta_x2;
    double *ic, *g, *t1, *t2, *xi, *wi, *xall;
    
    rows = mxGetM(in[0]);
    cols = mxGetN(in[0]);
    
    out[0] = mxCreateDoubleMatrix(rows, cols, mxREAL);
    ic = mxGetPr(out[0]);
    g = mxGetPr(in[0]); 
    t1 = mxGetPr(in[1]);
    t2 = mxGetPr(in[2]);
    xi = mxGetPr(in[3]);
    wi = mxGetPr(in[4]);

    for (i=1; i<=rows; i++){
        for (j=1; j<=cols; j++){
            for (k=1; k<=16; k++){
                x1_curr = i + (*t1) - (*(xi+(k-1)));
                x2_curr = j + (*t2) - (*(xi+(k-1)+16));
                
                if (x1_curr>3/2 && x2_curr>3/2 && x1_curr<rows-3/2 && x2_curr<cols-3/2) {
                    x1_int = round(x1_curr);
                    x2_int = round(x2_curr);
                    delta_x1 = x1_int - x1_curr;
                    delta_x2 = x2_int - x2_curr;
                    if (delta_x1 > delta_x2){
                        if (delta_x1 > -delta_x2){xall = mxGetPr(in[5]);}
                        else{xall = mxGetPr(in[6]);}
                    }
                    else{
                        if (delta_x1 > -delta_x2){xall = mxGetPr(in[7]);}
                        else{xall = mxGetPr(in[8]);}
                    }
                    
                    for (m=1; m<=7; m++){
                        xtmp = x1_int + (*(xall+(m-1)));
                        if (xtmp < 1) {xtmp = 1;}
                        else if (xtmp > rows) {xtmp = rows;}
                        ytmp = x2_int + (*(xall+(m-1)+7));
                        if (ytmp < 1) {ytmp = 1;}
                        else if (ytmp > cols) {ytmp = cols;}
                        
                        Ffun(&res1, xtmp, ytmp, x1_curr, x2_curr);
                        res2 += *(g+(xtmp-1)+(ytmp-1)*rows) * res1;
                    }
                    *(ic+(i-1)+(j-1)*rows) += (*(wi+k-1)) * res2;
                    res1 = 0;
                    res2 = 0;
                 }
                else{
                    *(ic+(i-1)+(j-1)*rows) = 0;
                    break;
                }
            }
        }
    }
}