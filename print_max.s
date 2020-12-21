# @author Bryan Bennett {@literal bennbc16@wfu.edu}
# @date Nov. 30, 2020
# @assignment Lab 7
# @file print_max.s
# @course CSC 250
#
# This program reads a sequence of integers until a negative
# value is entered and displays the current maximum
#
# Compile and run (Linux)
#   gcc -no-pie print_max.s && ./a.out


.text
   .global main               # use main if using C library


main:
   push %rbp                  # save the old frame
   mov  %rsp, %rbp            # create a new frame  
   sub  $16, %rsp             # make some space on the stack (stack alignment)
   
   # "int a" is the integer user enters, and is stored at -8(%rbp)
   # "int max" is the maximum integer entered so far, and is stored at -4(%rbp)
   
   movq  $0, -8(%rbp)          # Here we initialize both "max" and "a" to zero


.while_condition:
   movl  -8(%rbp), %eax       # Copy "int a" to register %eax
   testl  %eax, %eax          # And "a" with itself, this checks if "a" is zero. If "a" is negative, SF will be set to one 
   js  .after_while             # jump over the while body if SF = 1. In other words, break loop if a < 0.


.while_body:
   
   # prompt the user for integer
   mov  $prompt_format, %rdi  # first argument passed to printf, format = string  
   xor  %rax, %rax            # zero out rax  
   call printf                # printf, which prints string in $prompt_format

   # read the integer "a" from user, store in -8(%rbp)
   mov  $read_format, %rdi    # first argument to scanf, format string 
   lea  -8(%rbp), %rsi        # second scanf argument, memory address to store information
   xor  %rax, %rax            # zero out rax
   call scanf                 # scanf. Now "a" stores integer from user

   # Check if "a" is greater than max, if it is then max = a. Else leave max alone and skip to print_max
   movl  -8(%rbp), %eax       # Copy "a" to %eax, so cmp can work as we cannot compare memory-to-memory
   cmpl  -4(%rbp), %eax       # Compare "a" to "max", which sets flags to be read by jle 
   jle .print_max             # Skip past "max" reassignment if "a" is less than or equal to "max". 

   # Max is reassigned. max = "a"
   movl  -8(%rbp), %eax       # Copy "a" to %eax. %eax is used as temporary location b/c next move statement cannot go memory-to-memory
   movl  %eax, -4(%rbp)       # Copy the value in %eax (which is "a") to location of "max" 

.print_max:

   # print max value to the screen
   mov  $write_format, %rdi   # first printf argument, format string  
   mov -4(%rbp), %rsi         # second printf argument, the integer "max".
   xor  %rax, %rax            # zero out rax  
   call printf                # printf
   jmp .while_condition       # End of while loop body. Go back to check while criteria again with new "a" value


.after_while:

   xor  %rax, %rax            # Restore %rax register to zero
   add  $16, %rsp             # release stack space
   pop  %rbp                  # restore old frame
   ret                        # return to C library to end



.data

read_format:
   .asciz  "%d"                                             # String, first argument to scanf statement. Makes scanf read an integer

prompt_format:
   .asciz  "Enter an integer (negative to quit) -> "        # String, first argument to printf statement in while that prompts user

write_format:
   .asciz  "Current maximum is %d \n"                       # String, first argument to the printf statement that prints max value