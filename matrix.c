#include <stdio.h>
#include <stdlib.h>

void print(float* matrix, int rows, int cols) {
  for (int i=0; i<rows; ++i) {
    for (int j=0; j<cols; ++j)
      printf("%.1f  ",*(matrix+cols*i+j));   // matrix[i][j]
    printf("\n");
  }
}

float* multiply(float* A, float* B, int m, int n, int p) {
  float* C=(float* )malloc(m*p*sizeof(float));
  for (int i=0; i<m; ++i)
    for (int j=0; j<n; ++j)
      for (int k=0; k<p; ++k)
        *(C+p*i+k) += *(A+n*i+j) * (*(B+p*j+k));   // C[i][k]+=A[i][j]*B[j][k]
  return C;
}

int main(int argc, char** argv) {
  int m=4, n=4, p=4;
  float* A=(float* )malloc(m*n*sizeof(float));
  for (int i=0; i<m; ++i) {
    for (int j=0; j<n; ++j) {
      printf("Enter A[%d][%d]: ",i,j);
      scanf( "%f",&(*(A+n*i+j)) );   // A[i][j]
    }
  }
  float* B=(float* )malloc(n*p*sizeof(float));
  for (int i=0; i<n; ++i)
    for (int j=0; j<p; ++j) *(B+p*i+j)=(i==j)? 1.0f:0.0f;   // B[i][j]
  float* C=multiply(A,B,m,n,p);
  print(A,m,n), printf("\n");
  print(B,n,p), printf("\n");
  print(C,m,p);
  free(A), free(B), free(C);
  return 0;
}
