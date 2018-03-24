# Hasan Abdullah
# float_matrix_mult.asm - multiplies two matrices (represented as an array) of floats.
        .data
               m:       .word 2
               n:       .word 3
               p:       .word 4
               A:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               A_size:  .word 6
               B:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               B_size:  .word 12
               C:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               C_size:  .word 8
               spaces:   .asciiz "  "
               prompt1: .asciiz "Enter A["
               prompt2: .asciiz "]["
               prompt3: .asciiz "]: "
               newline: .asciiz "\n"
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   const int m=2, n=3, p=4;
        #   float* A=(float* )malloc(m*n*sizeof(float));
        #   for (int i=0; i<m; ++i) {
        #     for (int j=0; j<n; ++j) {
        #       printf("Enter A[%d][%d]: ",i,j);
        #       scanf( "%f",&(*(A+n*i+j)) ); // A[i][j]
        #     }
        #   }
        #   float* B=(float* )malloc(n*p*sizeof(float));
        #   for (int i=0; i<n; ++i)
        #     for (int j=0; j<p; ++j) *(B+p*i+j)=(i==j)? 1.0f:0.0f; // B[i][j]
        #   float* C=multiply(A,B,m,n,p);
        #   print(A,m,n), printf("\n");
        #   print(B,n,p), printf("\n");
        #   print(C,m,p);
        #   free(A), free(B), free(C);
        #   return 0;
        # }
main:
        lw $s0, m
        lw $s1, n
        lw $s2, p
        li $t0, 0                      # int i=0;
        main_loop_1:
          beq $t0, $s0, loop_exit_1    # if i==m, exit loop 1
          li $t1, 0                    # int j=0;
          main_loop_2:
            beq $t1, $s1, loop_exit_2  # if j==n, exit loop 2
            la $a0, prompt1
            li $v0, 4
            syscall                # print "Enter A["
            move $a0, $t0
            li $v0, 1
            syscall                # print i
            la $a0, prompt2
            li $v0, 4
            syscall                # print "]["
            move $a0, $t1
            li $v0, 1
            syscall                # print j
            la $a0, prompt3
            li $v0, 4
            syscall                # print "]: "
            la $t2, A              # $t2 holds base address of "matrix" A
            mul $t3, $s1, $t0      # $t3 holds n*i
            add $t3, $t3, $t1      # $t3 holds n*i+j
            sll $t3, $t3, 2        # $t3 holds [sizeof(int)=4]*(n*i+j)
            add $t2, $t2, $t3      # $t2 holds A+4*(n*i+j), i.e. &(A[i][j])
            li $v0, 6              # read float from stdin, i.e. scanf("%f",&x)
            syscall                # $f0 contains float read, i.e. $f0 holds x
            swc1 $f0, 0($t2)       # store read value into A[i][j]
            addi $t1, $t1, 1       # ++j
            j main_loop_2
          loop_exit_2:
          addi $t0, $t0, 1         # ++i
          j main_loop_1
        loop_exit_1:
        la $a0, A                  # $a0 holds base address of "matrix" A
        move $a1, $s0              # $a1 holds m
        move $a2, $s1              # $a2 holds n
        jal print
        li $v0, 10
        syscall                    # exit main
# -----------------------------------------------------------------------------
        # void print(float* M, int rows, int cols) {
        #   for (int i=0; i<rows; ++i) {
        #     for (int j=0; j<cols; ++j)
        #       printf("%.1f  ",*(M+cols*i+j)); // M[i][j]
        #     printf("\n");
        #   }
        #   return;
        # }
        # M, rows, cols are in $a0, $a1, $a2 (respectively)
print:
        move $t3, $a0                  # save $a0 b/c it will change in loop
        li $t0, 0                      # int i=0;
        print_loop_1:
          beq $t0, $a1, print_exit_1   # if i==rows, exit loop 1
          li $t1, 0                    # int j=0;
          print_loop_2:
            beq $t1, $a2, print_exit_2 # if j==cols, exit loop 2
            mul $t2, $a2, $t0      # $t2 holds cols*i
            add $t2, $t2, $t1      # $t2 holds cols*i+j
            sll $t2, $t2, 2        # $t2 holds 4*(cols*i+j)
            add $t2, $t3, $t2      # $t2 holds M+4*(cols*i+j), i.e. &(M[i][j])
            lwc1 $f12, 0($t2)      # load M[i][j] into $f12
            li $v0, 2
            syscall                # print M[i][j]
            la $a0, spaces
            li $v0, 4
            syscall                # print "  "
            addi $t1, $t1, 1       # ++j
            j print_loop_2
          print_exit_2:
          la $a0, newline
          li $v0, 4
          syscall                  # printf("\n");
          addi $t0, $t0, 1         # ++i
          j print_loop_1
        print_exit_1:
        move $a0, $t3              # restore $a0 to its original value
        jr $ra                     # return;
# -----------------------------------------------------------------------------
        # float* multiply(float* A, float* B, int m, int n, int p) {
        #   float* C=(float* )malloc(m*p*sizeof(float));
        #   for (int i=0; i<m; ++i)
        #     for (int j=0; j<n; ++j)
        #       for (int k=0; k<p; ++k)
        #         // C[i][k]+=A[i][j]*B[j][k]
        #         *(C+p*i+k) += *(A+n*i+j) * (*(B+p*j+k));
        #   return C;
        # }
multiply:
        # code
        jr $ra                     # return C;
# -----------------------------------------------------------------------------
