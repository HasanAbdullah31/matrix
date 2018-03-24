# Hasan Abdullah
# float_matrix_mult.asm - multiplies two matrices (represented as arrays) of floats.
        .data
               m:       .word 3
               n:       .word 3
               p:       .word 3
               A:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               B:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               C:       .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
               point_1: .float 0.1
               point_5: .float 0.5
               spaces:  .asciiz "  "
               prompt1: .asciiz "Enter A["
               prompt2: .asciiz "]["
               prompt3: .asciiz "]: "
               newline: .asciiz "\n"
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   const int m=3, n=3, p=3;
        #   float* A=(float* )malloc(m*n*sizeof(float));
        #   for (int i=0; i<m; ++i) {
        #     for (int j=0; j<n; ++j) {
        #       printf("Enter A[%d][%d]: ",i,j);
        #       scanf( "%f",&(*(A+n*i+j)) ); // A[i][j]
        #     }
        #   }
        #   float* B=(float* )malloc(n*p*sizeof(float));
        #   for (int i=0; i<n; ++i)
        #     for (int j=0; j<p; ++j) *(B+p*i+j)=(i==j)? 0.5f:0.1f; // B[i][j]
        #   float* C=multiply(A,B,m,n,p);
        #   print(A,m,n), printf("\n");
        #   print(B,n,p), printf("\n");
        #   print(C,m,p);
        #   free(A), free(B), free(C);
        #   return 0;
        # }
        # m, n, p are in $s0, $s1, $s2 (respectively)
main:
        lw $s0, m                     # const int m=3, n=3, p=3;
        lw $s1, n
        lw $s2, p
        li $t0, 0                     # int i=0;
        main_loop_1:
          beq $t0, $s0, loop_exit_1   # if i==m, exit loop 1
          li $t1, 0                   # int j=0;
          main_loop_2:
            beq $t1, $s1, loop_exit_2 # if j==n, exit loop 2
            la $a0, prompt1
            li $v0, 4
            syscall               # print "Enter A["
            move $a0, $t0
            li $v0, 1
            syscall               # print i
            la $a0, prompt2
            li $v0, 4
            syscall               # print "]["
            move $a0, $t1
            li $v0, 1
            syscall               # print j
            la $a0, prompt3
            li $v0, 4
            syscall               # print "]: "
            la $t2, A             # $t2 holds base address of "matrix" A
            mul $t3, $s1, $t0     # $t3 holds n*i
            add $t3, $t3, $t1     # $t3 holds n*i+j
            sll $t3, $t3, 2       # $t3 holds [sizeof(int)=4]*(n*i+j)
            add $t2, $t2, $t3     # $t2 holds A+4*(n*i+j), i.e. &(A[i][j])
            li $v0, 6             # read float from stdin, i.e. scanf("%f",&x)
            syscall               # $f0 contains float read, i.e. $f0 holds x
            swc1 $f0, 0($t2)      # store read value into A[i][j]
            addi $t1, $t1, 1      # ++j
            j main_loop_2
          loop_exit_2:
          addi $t0, $t0, 1        # ++i
          j main_loop_1
        loop_exit_1:

        li $t0, 0                     # int i=0;
        main_loop_3:
          beq $t0, $s1, loop_exit_3   # if i==n, exit loop 3
          li $t1, 0                   # int j=0;
          main_loop_4:
            beq $t1, $s2, loop_exit_4 # if j==p, exit loop 4
            la $t2, B                 # $t2 holds base address of "matrix" B
            mul $t3, $s2, $t0         # $t3 holds p*i
            add $t3, $t3, $t1         # $t3 holds p*i+j
            sll $t3, $t3, 2           # $t3 holds [sizeof(int)=4]*(p*i+j)
            add $t2, $t2, $t3         # $t2 holds B+4*(p*i+j), i.e. &(B[i][j])
            beq $t0, $t1, i_eq_j
            # else if i!=j, B[i][j]=0.1f
            lwc1 $f4, point_1
            swc1 $f4, 0($t2)
            j if_else_exit
            i_eq_j:
            # if i==j, B[i][j]=0.5f
            lwc1 $f4, point_5
            swc1 $f4, 0($t2)
            if_else_exit:
            addi $t1, $t1, 1      # ++j
            j main_loop_4
          loop_exit_4:
          addi $t0, $t0, 1        # ++i
          j main_loop_3
        loop_exit_3:

        la $a0, A
        la $a1, B
        move $a2, $s0
        move $a3, $s1
        subi $sp, $sp, 4
        sw $s2, 0($sp)
        jal multiply              # float* C=multiply(A,B,m,n,p);
        lw $s2, 0($sp)
        addi $sp, $sp, 4

        la $a0, A
        move $a1, $s0
        move $a2, $s1
        jal print                 # print(A,m,n)
        la $a0, newline
        li $v0, 4
        syscall                   # printf("\n");

        la $a0, B
        move $a1, $s1
        move $a2, $s2
        jal print                 # print(B,n,p)
        la $a0, newline
        li $v0, 4
        syscall                   # printf("\n");

        la $a0, C
        move $a1, $s0
        move $a2, $s2
        jal print                 # print(C,m,p)
        li $v0, 10
        syscall                   # exit main
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
            mul $t2, $a2, $t0     # $t2 holds cols*i
            add $t2, $t2, $t1     # $t2 holds cols*i+j
            sll $t2, $t2, 2       # $t2 holds 4*(cols*i+j)
            add $t2, $t3, $t2     # $t2 holds M+4*(cols*i+j), i.e. &(M[i][j])
            lwc1 $f12, 0($t2)     # load M[i][j] into $f12
            li $v0, 2
            syscall               # print M[i][j]
            la $a0, spaces
            li $v0, 4
            syscall               # print "  "
            addi $t1, $t1, 1      # ++j
            j print_loop_2
          print_exit_2:
          la $a0, newline
          li $v0, 4
          syscall                 # printf("\n");
          addi $t0, $t0, 1        # ++i
          j print_loop_1
        print_exit_1:
        move $a0, $t3             # restore $a0 to its original value
        jr $ra                    # return;
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
        # A, B, m, n, p are in $a0, $a1, $a2, $a3, 0($sp) (respectively)
multiply:
        lw $t3, 0($sp)                  # $t3 holds p
        li $t0, 0                       # int i=0;
        mult_loop_1:
          beq $t0, $a2, mult_exit_1     # if i==m, exit loop 1
          li $t1, 0                     # int j=0;
          mult_loop_2:
            beq $t1, $a3, mult_exit_2   # if j==n, exit loop 2
            li $t2, 0                   # int k=0;
            mult_loop_3:
              beq $t2, $t3, mult_exit_3 # if k==p, exit loop 3
              move $t4, $a0             # $t4 holds base address of "matrix" A
              mul $t5, $a3, $t0         # $t5 holds n*i
              add $t5, $t5, $t1         # $t5 holds n*i+j
              sll $t5, $t5, 2           # $t5 holds [sizeof(int)=4]*(n*i+j)
              add $t4, $t4, $t5         # $t4 holds &(A[i][j])
              lwc1 $f4, 0($t4)          # $f4 holds A[i][j]

              move $t4, $a1             # $t4 holds base address of "matrix" B
              mul $t5, $t3, $t1         # $t5 holds p*j
              add $t5, $t5, $t2         # $t5 holds p*j+k
              sll $t5, $t5, 2           # $t5 holds [sizeof(int)=4]*(p*j+k)
              add $t4, $t4, $t5         # $t4 holds &(B[j][k])
              lwc1 $f5, 0($t4)          # $f5 holds B[j][k]

              la $t4, C                 # $t4 holds base address of "matrix" C
              mul $t5, $t3, $t0         # $t5 holds p*i
              add $t5, $t5, $t2         # $t5 holds p*i+k
              sll $t5, $t5, 2           # $t5 holds [sizeof(int)=4]*(p*i+k)
              add $t4, $t4, $t5         # $t4 holds &(C[i][k])
              mul.s $f4, $f4, $f5       # $f4 holds A[i][j]*B[j][k]
              lwc1 $f5, 0($t4)          # $f5 holds C[i][k]
              add.s $f5, $f5, $f4       # $f5 holds C[i][k]+A[i][j]*B[j][k]
              swc1 $f5, 0($t4)          # put this value into C[i][k]
              addi $t2, $t2, 1    # ++k
              j mult_loop_3
            mult_exit_3:
            addi $t1, $t1, 1      # ++j
            j mult_loop_2
          mult_exit_2:
          addi $t0, $t0, 1        # ++i
          j mult_loop_1
        mult_exit_1:
        jr $ra                    # return C;
# -----------------------------------------------------------------------------
