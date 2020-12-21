# @author Bryan Bennett {@literal bennbc16@wfu.edu}
# @date Nov. 30, 2020
# @assignment Lab 7
# @file sum_two.s
# @course CSC 250
#
# This program reads two integers and displays the sum
#
# Compile and run (Linux)
#   gcc -no-pie sum_two.s && ./a.out


.text
   .global main               # use main if using C library

sum:
   leal (%rdi,%rsi), %eax     # Use addressing mode with leal to sum the two arguments to this function. Store in %eax
   ret                        # Return from sum. Resultant integer is stored in 4 least-sig bytes of %rax

main:
   push %rbp                  # save the old frame
   mov  %rsp, %rbp            # create a new frame  

   sub  $16, %rsp             # make some space on the stack (stack alignment)

   # prompt the user for two integers
   mov  $prompt_format, %rdi  # first printf argument, format string  
   xor  %rax, %rax            # zero out rax  
   call printf                # printf

   # read the first value user enters, store in -8(%rbp)
   mov  $read_format, %rdi    # first scanf argument, format string 
   lea  -8(%rbp), %rsi        # second scanf argument, memory address
   xor  %rax, %rax            # zero out rax
   call scanf                 # scanf

   # read the second value user enters, store in -12(%rbp)
   mov  $read_format, %rdi    # first scanf argument, format string 
   lea  -12(%rbp), %rsi       # second scanf argument, memory address
   xor  %rax, %rax            # zero out rax
   call scanf                 # scanf

   # Call sum function
   mov  -8(%rbp), %rdi        # Set %rdi to the first integer from user
   mov  -12(%rbp), %rsi       # Set %rsi to the second integer from user 
   xor  %rax, %rax            # Zero out %rax
   call sum                   # Call sum function, which sets %eax to sum of two integers
   movl  %eax, -16(%rbp)      # Store this returned value in -16(%rbp) 

   # print results to the screen
   mov  $write_format, %rdi   # first printf argument, format string  
   mov -8(%rbp), %rsi         # second printf argument, the first integer from user
   mov -12(%rbp), %rdx        # third printf argument, second integer provided by user
   mov -16(%rbp), %rcx        # fourth argument to printf, sum of two provided integers (result of sum function) 
   xor  %rax, %rax            # zero out rax  
   call printf                # printf

   add  $16, %rsp             # release stack space
   pop  %rbp                  # restore old frame
   ret                        # return to C library to end


.data

read_format:
   .asciz  "%d"                        # String, first argument to scanf statement. Makes scanf read an integer

prompt_format:
   .asciz  "Enter two integers -> "    # String, first argument to first printf statement to prompt user

write_format:
   .asciz  "%d + %d = %d\n"            # String, first argument to second printf statement which returns sum

