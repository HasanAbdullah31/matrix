#include <time.h>
#include <stdio.h>
#include <stdlib.h>

void print(int** matrix, int m, int n) {
  for (int i=0; i<m; ++i) {
    for (int j=0; j<n; ++j) printf("%d ",matrix[i][j]);
    printf("\n");
  }
}

int** multiply(int** A, int** B, int m, int n, int p) {
  int** C=(int** )malloc(m*sizeof(int*));
  for (int i=0; i<m; ++i) {
    C[i]=(int* )malloc(p*sizeof(int));
    for (int j=0; j<n; ++j)
      for (int k=0; k<p; ++k)
        C[i][k]+=A[i][j]*B[j][k];
  }
  return C;
}

int main(int argc, char** argv) {
  srand(time(0));
  int m=4, n=4, p=4;
  int** A=(int** )malloc(m*sizeof(int*));
  for (int i=0; i<m; ++i) {
    A[i]=(int* )malloc(n*sizeof(int));
    for (int j=0; j<n; ++j) A[i][j]=(int)rand()%10;
  }
  int** B=(int** )malloc(n*sizeof(int*));
  for (int i=0; i<n; ++i) {
    B[i]=(int* )malloc(p*sizeof(int));
    for (int j=0; j<p; ++j) B[i][j]=(i==j)? 1:0;
  }
  int** C=multiply(A,B,m,n,p);
  print(A,m,n), printf("\n");
  print(B,n,p), printf("\n");
  print(C,m,p);
  for (int i=0; i<m; ++i) free(A[i]), free(C[i]);
  for (int i=0; i<n; ++i) free(B[i]);
  free(A), free(B), free(C);
  return 0;
}
