#include <stdio.h>
#include <stdlib.h>

void print(int* matrix, int rows, int cols) {
  for (int i=0; i<rows; ++i) {
    for (int j=0; j<cols; ++j)
      printf("%d ",*(matrix+cols*i+j));   // matrix[i][j]
    printf("\n");
  }
}

int* multiply(int* A, int* B, int m, int n, int p) {
  int* C=(int* )malloc(m*p*sizeof(int));
  for (int i=0; i<m; ++i)
    for (int j=0; j<n; ++j)
      for (int k=0; k<p; ++k)
        *(C+p*i+k) += *(A+n*i+j) * (*(B+p*j+k));   // C[i][k]+=A[i][j]*B[j][k]
  return C;
}

int main(int argc, char** argv) {
  int m=4, n=4, p=4;
  int* A=(int* )malloc(m*n*sizeof(int));
  for (int i=0; i<m; ++i)
    for (int j=0; j<n; ++j) *(A+n*i+j)=j;   // A[i][j]
  int* B=(int* )malloc(n*p*sizeof(int));
  for (int i=0; i<n; ++i)
    for (int j=0; j<p; ++j) *(B+p*i+j)=(i==j)? 1:0;   // B[i][j]
  int* C=multiply(A,B,m,n,p);
  print(A,m,n), printf("\n");
  print(B,n,p), printf("\n");
  print(C,m,p);
  free(A), free(B), free(C);
  return 0;
}
