#include "mex.h"
#include "math.h"
#include<stdio.h>
#include<conio.h>
/* Entradas: imagen, media, covarianza, lamda, miu, bin, ni, modelos */
// media(modelos,3)
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    double *imagen, *media, *covinv, lam, nx, miu, *bin, ni,*vri, *sal, modelos, ve[3],tsgm[10],temp,temp2,bo, borrar;
    double alfa[10], tm[10], beta[10],  tempo[10];
    int i,j, ip, jp, p, k,ug,elementos;
    mwSize mrows, ncols, nDims, nDimss, *dims,*dimsd;
    if (nrhs != 8)    {
        mexErrMsgTxt("Demasiados o pocos argumentos de entrada");
    }
    else if (nlhs > 1)    {
        mexErrMsgTxt("Demasiados argumentos de salida");
    }
    else {
        
        
        /* Dimensiones de la imagen */
        mrows = mxGetDimensions(prhs[0])[0];
        ncols = mxGetDimensions(prhs[0])[1];
        nDims = mxGetNumberOfDimensions(prhs[0]);
        nDimss = mxGetNumberOfDimensions(prhs[5]);
        dims = mxGetDimensions(prhs[0]);
        dimsd = mxGetDimensions(prhs[0]);
        /* Get the data passed in */
        imagen = mxGetPr(prhs[0]);
        media= (double*) mxGetPr(prhs[1]);
        covinv=(double*) mxGetPr(prhs[2]);
        lam= mxGetScalar(prhs[3]);
        miu= mxGetScalar(prhs[4]);
        bin=(double*) mxGetPr(prhs[5]);
        ni=mxGetScalar(prhs[6]);
        modelos=mxGetScalar(prhs[7]);
        elementos=mxGetNumberOfElements(prhs[5]);
        /* Create an mxArray for the output      plhs[i] = mxCreateDoubleMatrix(m, n, mxREAL);*/
        /*plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);*/
        plhs[0] = mxCreateNumericArray(nDimss,mxGetDimensions(prhs[5]),mxDOUBLE_CLASS,mxREAL);
        vri = mxGetPr(plhs[0]);
        //vri = (double*) mxGetPr(plhs[0]);
        //ciclo de iteraciones General
        for (p=1; p<ni; p++)
        {
            //recorriendo imagen
            for(i=0; i<mrows; i++)
            {
                for(j=0; j<ncols; j++)
                {
                    //vecindario
                    nx=-1;
                    for (ip = 0; ip < 10; ip++)
                        tempo[ip]=0;
                   
                    for(ip = -1; ip < 2; ip++)
                        for(jp = -2; jp < 2; jp++)
                            if (  (i+ip>-1)  &&  (j+jp>-1) )
                                if (  (i+ip < mrows-1)  && (j+jp < ncols-1)   ){
                                    nx++;
                                    for (k=0; k<modelos; k++)
                                        tempo[k]= tempo[k]+bin[ (i+ip)+((j+jp)*dims[0])+(k*dims[0]*dims[1])];
                                }
                    
                    for (k=0; k<modelos; k++)
                        tempo[k]= tempo[k]-bin[i+(j*dims[0])+(k*dims[0]*dims[1])];
                    //termina vecindario
                    
                    //verosimilitud y  beta
                    
                    for (k=0; k<modelos; k++)
                    {
                        ve[0]= imagen[i+(j*dims[0])+(0*dims[0]*dims[1])]-media[0+(k*3)];
                        ve[1]= imagen[i+(j*dims[0])+(1*dims[0]*dims[1])]-media[1+(k*3)];
                        ve[2]= imagen[i+(j*dims[0])+(2*dims[0]*dims[1])]-media[2+(k*3)];
                        
                        for (ug = 0; ug < 3; ug++)
                            tsgm[ug]= (covinv[0+ug+(k*9)]*ve[0])+(covinv[3+ug+(k*9)]*ve[1])+(covinv[6+ug+(k*9)]*ve[2]);
                        
                        
                        temp=(tsgm[0]*ve[0])+(tsgm[1]*ve[1])+(tsgm[2]*ve[2]);
                        beta[k]= temp - miu + (lam* nx);
                        alfa[k]= lam * tempo[k];
                    }
                    temp=0;
                    temp2=0;
                    for (k=0; k<modelos; k++)
                    {
                        temp=temp+(alfa[k]/beta[k]);
                        temp2=temp2+(1/beta[k]);
                    }
                    for (k=0; k<modelos; k++)
                    {
                        bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]=(alfa[k]/beta[k])+ ((1-temp)/(beta[k]*temp2));
                        tsgm[k]=(alfa[k]/beta[k])+ ((1-temp)/(beta[k]*temp2));
                        // borrar=(alfa[k]/beta[k])+ ((1-temp)/(beta[k]*temp2));
                    }
                    borrar=0;
                    for (k=0; k<modelos; k++)
                    {
                        if(tsgm[k]<0)
                            if(tsgm[k]<borrar)
                                borrar=tsgm[k];
                    }
                    
                    if (borrar<0)
                    {
                        borrar=borrar*borrar;
                        borrar=pow (borrar, .5);
                        bo=0;
                        for (k=0; k<modelos; k++)
                        {
                            bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]=bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]+borrar;
                            // if(bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]>bo)
                            bo=bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]+bo;
                            // borrar=(alfa[k]/beta[k])+ ((1-temp)/(beta[k]*temp2));
                        }
                        
                        for (k=0; k<modelos; k++)
                        {
                            bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]=bin[ i+(j*dims[0])+(k*dims[0]*dims[1])]/bo;
                            //vri[ i+(j*dims[0])+(k*dims[0]*dims[1])]=bin[ i+(j*dims[0])+(k*dims[0]*dims[1])];
                            tsgm[k]=bin[ i+(j*dims[0])+(k*dims[0]*dims[1])];
                        }
                        
                    }
                }
            }
        }
        for (k = 0; k < elementos; k++)
        {
            vri[k]=bin[k];
            tsgm[0]=bin[k];
        }
        
    }
    return;
}


