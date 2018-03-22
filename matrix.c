#include <stdio.h>
#include <stdlib.h>

void print(FILE* file, int** matrix, int m, int n) {
     char element[2];
     for (int i=0; i<m; ++i) {
         for (int j=0; j<n; ++j) {
             sprintf(element,"%d ",matrix[i][j]);
             fputs(element,file);
         }
         fputs("\n",file);
         fflush(file);
     }
     fclose(file);
}
/*
int** multiply(int** A, int** B, int m, int n, int p) {
      ;
}
*/
int main(int argc, char** argv) {
    int m=4;
    int n=4;
    int p=4;
    int** A=(int** )malloc(m*sizeof(int*));
    for (int i=0; i<m; ++i) {
        A[i]=(int* )malloc(n*sizeof(int));
        for (int j=0; j<n; ++j)
            A[i][j]=j;
    }
    int** B=(int** )malloc(n*sizeof(int*));
    for (int i=0; i<n; ++i) {
        B[i]=(int* )malloc(p*sizeof(int));
        for (int j=0; j<p; ++j)
            B[i][j]=(i!=j)? 0:1;
    }
    FILE* file=fopen("foo.txt","w");
    print(file,A,m,n);
    file=fopen("bar.txt","w");
    print(file,B,n,p);
    for (int i=0; i<m; ++i) free(A[i]);
    for (int i=0; i<n; ++i) free(B[i]);
    free(A);
    free(B);
    return 0;
}
