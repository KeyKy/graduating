#include "mex.h"

int **d;

int dist(char *a, char *b, int la, int lb){
	int i = la;
	int j = lb;
	d[0][0] = 0;
	for(int l = 0; l < j; l++){
		d[0][l] = l;
	}
	for(int l = 0; l < i; l++){
		d[l][0] = l;
	}
	for(int row = 1; row <= i; row++){
		for(int col = 1; col <= j; col++){
			if(a[row-1] == b[col-1]){
				int t1 = d[row-1][col]+1;
				int t2 = d[row][col-1]+1;
				int t3 = d[row-1][col-1];
				int tmp = t1 < t2 ? t1: t2;
				d[row][col] = t3 < tmp ? t3 : tmp;
			}
			else{
				int t1 = d[row-1][col]+1;
				int t2 = d[row][col-1]+1;
				int t3 = d[row-1][col-1]+1;
				int tmp = t1 < t2 ? t1: t2;
				d[row][col] = t3 < tmp ? t3 : tmp;
			}
		}
	}
	return 0;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	double *dataCursor1 = mxGetPr(prhs[0]);
	double *dataCursor2 = mxGetPr(prhs[1]);
	
	int ncols1 = mxGetN(prhs[0]);
	int ncols2 = mxGetN(prhs[1]);
	char *a = new char[ncols1];
    char *b = new char[ncols2];
    for(int i = 0; i < ncols1; i++){
        a[i] = int(dataCursor1[i]) + 48;
    }
    for(int i = 0; i < ncols2; i++){
        b[i] = int(dataCursor2[i]) + 48;
    }
    int maxL = ncols1 > ncols2 ? ncols1+1 : ncols2+1;
    
    d = new int *[maxL];
    for(int i = 0; i < maxL; i++){
        d[i] = new int[maxL];
    }
    for(int i = 0; i < maxL; i++){
        for(int j = 0; j < maxL; j++){
            d[i][j] = 0;
        }
    }
    
    dist(a, b, ncols1, ncols2);
    
    double *y;
    plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    y = mxGetPr(plhs[0]);
    *y = d[ncols1][ncols2];
    
    for(int i = 0; i < maxL; i++){
        delete[] d[i];
    }
    delete[] d;
    delete[] b;
    delete[] a;
}