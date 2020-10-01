#######################################################################################
#Program Name	: This Program uses Positive Bubble Sort to Sort n integer values
#Programmer	: Christian Costa
#Date Last Modif.	: 30 April 2020
########################################################################################
# Comments: This Program uses Positive Bubble Sort to Sort
#	n integer values stored in .data.
######################################################################################## 
	.align 2
	.data		# data segment
#The table of 20 words	
#int arr[] 	= {-1,	64,	34,	25,	12,	-1,	22,	11,	90,	-1,	-1,	-1,	100, 8, 10, 111, 34, 55, 999, 19};
#int size = 20;
table: 			.word	-1,	64,	34,	25,	12,	-1,	22,	11,	90,	-1,	-1,	-1,	100, 8,	10,	111, 34, 55, 999, 19
size:			.byte	20		#The size of the table
newLine:		.asciiz "\n"	#New line
comma:			.asciiz ",	"	#Comma
######################################################################################## 
				.text			# text segment
				.globl main
main:
		# Initiate the values used in the program
		li $t0,0 				# set the counting value equal to 0
		
		la $a0, table			#Load the start address of the table
		lb $a1, size			#Load the size of the table
		jal printArray 			#printArray(arr, size);
		#---------------------------------------------------------------------------------
		# Call the Bubble Sort Function
		#---------------------------------------------------------------------------------
		la $a0, table 			#Load the start address of the table
		lb $a1, size			#Load the size of the table
		jal bubbleSort_positive
		#----------------------------------------------------------------------------------
		la $a0, table			#Load the start address of the table
		lb $a1, size			#Load the size of the table
		jal printArray 			#printArray(arr, size);
 
 
		# Exit
		li $v0, 10				# Exit System Call
		syscall

######################################################################	
###  Functions
######################################################################
printArray:
	move $t0, $a0 
	move $t1, $a1
#--------------------------------------------------------------------- 
loop_prt:
		lw $a0, 0($t0)			# Load word from table
		li $v0, 1				# System Call print_int
		syscall					# Print on Console
		 # Print on Console
		li $v0, 4				# 4 = print questionStr syscall 
		la $a0, comma			# load address of string
		syscall					# execute the system call
		addi $t0, $t0, 4		# Move the pointer to the next word
		addi $t1, $t1, -1		# Decrease the counter
		bnez $t1, loop_prt		# Repeat until all words read
	li $v0, 4					# 4 = print questionStr syscall 
	la $a0, newLine				# load address of string
	syscall						# execute the system call
	jr $ra 
#----------------------------------------------------------------------
###############################
########  Stack Frame  ########
#old $sp |-----------|
#		 |	  $s0	 |	
#$fp-->  |-----------|	
#		 |	  $s1	 |
#$sp+48  |-----------|	 	
#		 |	  $s2	 |
#$sp+44  |-----------| 	
#		 |	  $s3	 |
#$sp+40  |-----------|
#		 |	  $s4	 |
#$sp+36  |-----------|	
#		 |	  $s5	 |
#$sp+32  |-----------| 	
#		 |	  $s6	 |
#$sp+28  |-----------|
#		 |	  $s7	 |
#$sp+24  |-----------|	
#		 |	  $fp	 |
#$sp+20  |-----------|	
#		 |	  $ra	 |
#$sp+16  |-----------|	
#		 |	  $a0	 |
#$sp+12  |-----------|
#		 |	  $al	 |
#$sp+8   |-----------|
#		 |	  $a2 	 |
#$sp+4   |-----------|
#		 |	  $a3 	 |
#t$sp -->|-----------|
#
###############################
bubbleSort_positive:
	subu $sp,$sp,56			# Stack frame is 56 bytes long
	sw $a0, 12($sp)			# Save Argument 0 ($a0)
	sw $a1, 8($sp)			# Save Argument 0 ($a0)
	
	sw $s0, 56($sp)			# Save $s0
	sw $s1, 52($sp)			# Save $s1
	sw $s2, 48($sp)			# Save $s2
	sw $s3, 44($sp)			# Save $s3
	sw $s4, 40($sp)			# Save $s4
	sw $s5, 36($sp)			# Save $s5
	sw $s6, 32($sp)			# Save $s6
	sw $s7, 24($sp)			# Save $s7

	sw $ra, 16($sp)			# Save return adress
	sw $fp, 20($sp)			# Save frame pointer

	addiu $fp,$sp,52		# Set up frame pointer

	move $s0, $a0			# $s0 = @Table
	move $s1, $a1			# $s1 = Size
	
	li $s6, 0				# $s6 = i


bb_loop_i:			    	#<------------<----i-------------<------i---------------|
	li $s2,0 	 	  	# $s2 = j				                        						       	|	
	li $s7,0		  	# swapped = 0						                       			       	|	
	bb_loop_j:			      	#<----------<-------j-----<----j----------------|  	|
		mul $s3, $s2, 4		# Multiply the index by 4					                 	|  	|
		add $s3, $s3, $s0 	# Get the pointer to the table at index j	       	^  	^
		lw  $s4, 0($s3)		# load arr[j]								                      	|  	|
		lw  $s5, 4($s3)		# load arr[j+1]							              	       	|  	|
		bltz $s4, bb_loop_j_next	#if (arr[j] < 0 ) goto bb_loop_j_next     	|  	|
		bltz $s5, bb_loop_j_next	#if (arr[j+1] < 0)goto bb_loop_j_next     	|  	|
		bgt $s5, $s4, bb_loop_j_next #if (arr[j+1] > arr[j]) goto bb_loop_j_next
	bb_swap: #if (arr[j] > arr[j+1])(swap(arr, j, j+1);svapped = 1;}       	|  	|
		li $s7, 1		# swapped = 1							                    		      	|  	|
		move $a0, $s0   # The address of arr[]							                 	j  	i
		move $a1, $s2 	# The index of x (which is j)					              	|  	|
		addi $a2, $s2,1 # The index of y (which is j+1)				  	        	  |  	|
		jal swap		# call swap										                          	|  	|		
								#										                                    	|  	|
	bb_loop_j_next:				#								                        	  	   	|  	|
		add $s2, $s2, 1			#j++								                            	|  	|
		move $t0, $s1		  	#									                              	| 	|
		sub $t0,$t0, 1			#										                             	|	  |
		sub $t0,$t0, $s6		#									                            		| 	|
		blt $s2, $t0, bb_loop_j   #j<n-1-i >>--j--------->--------j--->-------|	  ^
								#								                                      				|
		#DEBUG																                                  	|
		move $a0, $s0	            # Table adress			                  					|
		move $a1, $s1           	# n									                         		|
		jal printArray	          #							                              		i
					                  	#					                                			|
		beqz $s7, Return	       	# If no swap occured Return			             		|
		add $s6, $s6, 1		      	#i++										                        |
		blt $s6, $s1, bb_loop_i   #i<n-i  >>--i--------->--------i--->------------|

Return:						# Result is in $v0
	lw $s0, 56($sp)			# Load $s0
	lw $s1, 52($sp)			# Load $s1
	lw $s2, 48($sp)			# Load $s2
	lw $s3, 44($sp)			# Load $s3
	lw $s4, 40($sp)			# Load $s4
	lw $s5, 36($sp)			# Load $s5
	lw $s6, 32($sp)			# Load $s6
	lw $s7, 24($sp)			# Load $s7
	lw $ra, 16($sp)			# Restore the old value of $ra
	lw $fp, 20($sp)			# Restore the old value of $fp
	addiu $sp, $sp, 56 		# Pop stack
jr $ra	

#---------------------------------------------------------------------- 
#swap(int arr[], int x, int y){
#	int temp = arr[x];
#	arr[x]=arr[y];
#	arr[y]=temp;
#}
swap: # ERROR if use: la $a0, table
	mul $a1, $a1, 4					#Compute the offset for x
	mul $a2, $a2, 4					#Compute the offset for y
	add $a1, $a1, $a0				#Compute the address of x
	add $a2, $a2, $a0				#Compute the address of y
	lw $t1,	($a1)
	lw $t2,	($a2)
    # Swap numbers
	sw $t2, 0($a1)
	sw $t1, 0($a2)
	jr $ra
#---------------------------------------------------------------------- 
