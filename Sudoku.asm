#======================================================================================
# * Sudoku
#--------------------------------------------------------------------------------------
# Probably on JT will ever play this, but whatever.
#======================================================================================
.data

#--------------------------------------------------------------------------------------
# * The size of the screen
#--------------------------------------------------------------------------------------
ScreenSize:	.word 	256

#--------------------------------------------------------------------------------------
# * The colors to draw on the screen
#--------------------------------------------------------------------------------------
ColorTable:	.word 0x000000		# Black  [0]
		.word 0x0000ff		# Blue   [1]
		.word 0x00ff00		# Green  [2]
		.word 0xff0000		# Red    [3]
		.word 0xff9900		# Orange [4]
		.word 0xcc00cc		# Purple [5]
		.word 0xffff00		# Yellow [6]
		.word 0xffffff		# White  [7]
		.word 0x808080		# Off-White [8]
		
#--------------------------------------------------------------------------------------
# * The colors of the lines on the board
#--------------------------------------------------------------------------------------
LineColors:	.byte 7 		# White [0]
		.byte 8 		# Off-White [1]
		.byte 8 		# Off-White [2]
		.byte 7 		# White [3]
		.byte 8 		# White [4]
		.byte 8 		# White [5]
		.byte 7 		# White [6]
		.byte 8 		# White [7]
		.byte 8 		# White [8]
		.byte 7 		# White [9]
		
#--------------------------------------------------------------------------------------
# * The numbers on the board
#--------------------------------------------------------------------------------------
DefaultBoard:	.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		.byte '0' : 9
		
#--------------------------------------------------------------------------------------
# * The string used to get info for the board from
#--------------------------------------------------------------------------------------	
InputBuffer:	.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11
		.byte '0' : 11	

#--------------------------------------------------------------------------------------
# * The location of the number to be displayed
#--------------------------------------------------------------------------------------
NumberStr:	.asciiz "0"

#--------------------------------------------------------------------------------------
# * Temp location for the board to read in
#--------------------------------------------------------------------------------------
TempText:	.asciiz "Test.txt"
		
.text
#======================================================================================
# * Main Process
#======================================================================================
Main:
	jal	DrawBackground		# Draw the background on the display
	
	jal	DrawBoard		# Draw the lines that make up the board
	
	jal	LoadBoard		# Load the board in
	
	jal	DrawNumbers		# Draw the numbers on the board
	
	li	$v0, 10			# Call program exit
	syscall


#======================================================================================
# * Draw Background
#--------------------------------------------------------------------------------------
# Draws the background
#======================================================================================	
DrawBackground:
	li	$a0, 0			# Draw a black box across the entire screen
	li	$a1, 0
	li	$a2, 0
	lw	$a3, ScreenSize
	subu	$sp, $sp, 4		# Draw the background box
	sw 	$ra, 0($sp)
	jal	DrawBox
	lw 	$ra, 0($sp)		
	addu 	$sp, $sp, 4

	jr	$ra
	
#======================================================================================
# * Draw Board
#--------------------------------------------------------------------------------------
# Draws board on the screen
#======================================================================================	
DrawBoard:
	lw	$t0, ScreenSize		# Get the screen size in pixels
	rem	$t1, $t0, 10		# and mod it by 10
	div	$t1, $t1, 2		# Get halfway across to get the original offset
	div	$t2, $t0, 10		# Get the width of each of the boxes
	div	$t3, $t2, 2		# Move the board over by half the pixel width
	add	$t1, $t1, $t3
	
	li	$t4, 0			# Setup a loop counter for the drawing of the lines	
board_loop:
	move	$a0, $t1		# Get the offset of the vertical lines
	mul	$t3, $t2, $t4
	add	$a0, $a0, $t3		# X = offset + (counter * divider)
	move	$a1, $t1		# Y = offset
	la	$t5, LineColors		# Get the colors from the table
	addu	$t5, $t5, $t4
	lb	$a2, 0($t5)
	sub	$a3, $t0, $t1		# Lenght = Size - (offset * 2)
	sub	$a3, $a3, $t1
	
	subu	$sp, $sp, 20		# Draw a vertical lines
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t4, 16($sp)
	jal	DrawVertLine
	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t4, 16($sp)
	addu	$sp, $sp, 20
	
	move	$a1, $t1		# Get the offset of the vertical lines
	mul	$t3, $t2, $t4
	add	$a1, $a1, $t3		# Y = offset + (counter * divider)
	move	$a0, $t1		# X = offset
	la	$t5, LineColors		# Get the colors from the table
	addu	$t5, $t5, $t4
	lb	$a2, 0($t5)
	sub	$a3, $t0, $t1		# Lenght = Size - (offset * 2)
	sub	$a3, $a3, $t1
	
	subu	$sp, $sp, 20		# Draw a vertical lines
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t4, 16($sp)
	jal	DrawHorzLine
	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t4, 16($sp)
	addu	$sp, $sp, 20

	addi	$t4, $t4, 1		# Increment the loop counter
	blt	$t4, 10, board_loop	# If counter is less than 10, go back
	
	# Redraw the outer lines to reinforce the boarder
	move	$a0, $t1		# Get the offset of the vertical lines
	move	$a1, $t1		# to set the X and Y
	lb	$a2, LineColors		# Ge the color of the first line
	sub	$a3, $t0, $t1		# Lenght = Size - (offset * 2)
	sub	$a3, $a3, $t1
	
	subu	$sp, $sp, 20		# Draw a vertical lines
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$a3, 16($sp)
	jal	DrawVertLine
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$a3, 16($sp)
	addu	$sp, $sp, 20
	
	subu	$sp, $sp, 4		# Draw a horizontal line
	sw	$ra, 0($sp)
	jal	DrawHorzLine
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	
	jr	$ra
	
#======================================================================================
# * Load Board
#--------------------------------------------------------------------------------------
# Load the board from a text file
#======================================================================================	
LoadBoard:
	la	$a0, TempText		# Use the temporary text file for now
	li	$a1, 0			# Read in mode
	li	$a2, 0			# Mode is ignored
	li	$v0, 13			# Prepare to open a text file
	syscall				# Open the file
	
	move	$a0, $v0		# Setup the to read the characters in
	la	$a1, InputBuffer	# Use the board as the buffer
	li	$a2, 99			# It's a 9x9 board, thus we have 81 elements with 9 new lines which consists of a '\n' and a '\r' character
	li	$v0, 14			# Prepare to read text
	syscall				# Read the text
	
	li	$t1, 0			# Setup a loop counter
	la	$t2, DefaultBoard	# Gets the boad buffer
square_loop:
	lb	$t0, 0($a1)		# Get the address from the board
	beq	$t0, '\n', lp_end	# Skip a new line without incrementng the counter
	beq	$t0, '\r', lp_end	# Skip a new line without incrementng the counter
	subi	$t0, $t0, '0'		# Adjust to a number
	beqz	$t0, sv_num		# If the number is 0, then don't lock the number in
	ori	$t0, $t0, 0x10		# A 1 in the upper 4 bits means that the number can't be edited
sv_num: sb	$t0, 0($t2) 
	
	addi	$t1, $t1, 1		# Increment the loop counter
	addi	$t2, $t2, 1		# Increment the board location
lp_end:	addi	$a1, $a1, 1		# Increment the address	of the input buffer
	blt	$t1, 81, square_loop	# If there are still squares, go back 
	
	li	$v0, 16			# Close the text file
	syscall
	
	jr	$ra
	
#======================================================================================
# * Draw Numbers
#--------------------------------------------------------------------------------------
# Draws the numbers on the board
#======================================================================================	
DrawNumbers:
	li	$a0, 0			# Setup counters for the X
	
col_loop:	
	li	$a1, 0			# Setup a y counter
	
row_loop:
	la	$t0, DefaultBoard	# Get the default board
	addu	$t0, $t0, $a0		# Factor in the component of the array
	mul	$t1, $a1, 9		# Get the y component of the array
	addu	$t0, $t0, $t1
	lb	$a2, 0($t0)		# Get the number at the given position
	andi	$a2, $a2, 0xf		# Only keep the lower 4 bits of the number

	subu	$sp, $sp, 12		# Draw the number saved at those coordinate
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	jal	DrawNum
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	addu	$sp, $sp, 12

	addi	$a1, $a1, 1		# Increment the y counter
	blt	$a1, 9, row_loop	# and go back if less than 9
	
	addi	$a0, $a0, 1		# Increment the x counter
	blt	$a0, 9, col_loop	# and go back if less than 9
	
	jr	$ra

#======================================================================================
# * Draw Horizontal Line
#--------------------------------------------------------------------------------------
# Draws a horizontal line across the screen
# @param: $a0 the x-coordinate to start at
# @param: $a1 the y-coordinate to start at
# @param: $a2 the color of the line
# @param: $a3 the length of the line
#======================================================================================	
DrawHorzLine:
	move	$t0, $a0		# Move the x-coordinate and line lenght into
	move	$t1, $a3		# a temp register.
	
horz_loop:
	add	$a0, $t0, $t1		# Sets the x-coordinate for the line drawing
	sub	$a0, $a0, 1
	subu	$sp, $sp, 20
	sw 	$ra, 0($sp)
	sw	$t0, 4($sp)		# Store the x-coordinate and length
	sw	$t1, 8($sp)
	sw	$a1, 12($sp)		# Store the arugments that are kept
	sw	$a2, 16($sp)
	jal 	FillPixel
	lw 	$ra, 0($sp)		
	lw	$t0, 4($sp)		# Restore the x-coordinate and length
	lw	$t1, 8($sp)
	lw	$a1, 12($sp)		# Restore the arguments that are kept
	lw	$a2, 16($sp)
	addu	$sp, $sp, 20
	
	subi	$t1, $t1, 1		# Move 1 pixel to the left (towards the staring point)
	bgtz	$t1, horz_loop		# If still has pixels to draw, go back
	
	jr	$ra
	
#======================================================================================
# * Draw Vertical Line
#--------------------------------------------------------------------------------------
# Draws a horizontal line across the screen
# @param: $a0 the x-coordinate to start at
# @param: $a1 the y-coordinate to start at
# @param: $a2 the color of the line
# @param: $a3 the length of the line
#======================================================================================	
DrawVertLine:
	move	$t0, $a1		# Move the y-coordinate and line lenght into
	move	$t1, $a3		# a temp register.
	
vert_loop:
	add	$a1, $t0, $t1		# Sets the y-coordinate for the line drawing
	sub	$a1, $a1, 1
	subu	$sp, $sp, 20
	sw 	$ra, 0($sp)
	sw	$t0, 4($sp)		# Store the x-coordinate and length
	sw	$t1, 8($sp)
	sw	$a0, 12($sp)		# Store the arugments that are kept
	sw	$a2, 16($sp)
	jal 	FillPixel
	lw 	$ra, 0($sp)		
	lw	$t0, 4($sp)		# Restore the x-coordinate and length
	lw	$t1, 8($sp)
	lw	$a0, 12($sp)		# Restore the arguments that are kept
	lw	$a2, 16($sp)
	addu	$sp, $sp, 20
	
	subi	$t1, $t1, 1		# Move 1 pixel to the left (towards the staring point)
	bgtz	$t1, vert_loop		# If still has pixels to draw, go back
	
	jr	$ra
	
#======================================================================================
# * Draw Foward Diagonal
#--------------------------------------------------------------------------------------
# Draws a foward diagonal line across the screen
# @param: $a0 the x-coordinate to start at
# @param: $a1 the y-coordinate to start at
# @param: $a2 the color of the line
# @param: $a3 the length of the line
#======================================================================================	
DrawForwDiag:
	move	$t0, $a0		# Move the x and y-coordinates and line lenght into
	move	$t1, $a1		# a temp register.
	move	$t2, $a3
	
forw_loop:
	add	$a0, $t0, $t2		# Sets the x and y-coordinates for the line drawing
	add	$a1, $t1, $t2
	sub	$a0, $a0, 1
	sub	$a1, $a1, 1
	subu	$sp, $sp, 24
	sw 	$ra, 0($sp)
	sw	$t0, 4($sp)		# Store the x-coordinate and length
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$a0, 16($sp)		# Store the arugments that are kept
	sw	$a2, 20($sp)
	jal 	FillPixel
	lw 	$ra, 0($sp)		
	lw	$t0, 4($sp)		# Restore the x-coordinate and length
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$a0, 16($sp)		# Restore the arguments that are kept
	lw	$a2, 20($sp)
	addu	$sp, $sp, 24
	
	subi	$t2, $t2, 1		# Move 1 pixel to the left (towards the staring point)
	bgtz	$t2, forw_loop		# If still has pixels to draw, go back
	
	jr	$ra
	
#======================================================================================
# * DrawBox
#--------------------------------------------------------------------------------------
# Draws a box on the screen
# @param: $a0 the x-coordinate to start at
# @param: $a1 the y-coordinate to start at
# @param: $a2 the color of the line
# @param: $a3 the sizes of the box
#======================================================================================	
DrawBox:
	move	$t2, $a0		# Store the initial coordinates somewhere
	move	$t3, $a1
	
	move	$t0, $a0		# Get the starting x-coordinate
	
x_loop:
	
	move	$t1, $t3		# Get the starting y-coordinate
y_loop:
	move	$a0, $t0		# Transfer the draw coordinates into arguments
	move	$a1, $t1
	subu	$sp, $sp, 28
	sw 	$ra, 0($sp)
	sw	$t0, 4($sp)		# Store the x and y coordinates
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)
	sw	$a2, 20($sp)		# Store the color and lengths
	sw	$a3, 24($sp)
	jal 	FillPixel
	lw 	$ra, 0($sp)		
	lw	$t0, 4($sp)		# Restore the x and y coordinates
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t3, 16($sp)
	lw	$a2, 20($sp)		# Restore the color and lengths
	sw	$a3, 24($sp)
	addu 	$sp, $sp, 28		
	
	addiu	$t1, $t1 1		# Increment the y-coordinate by 1
	
	add	$t4, $a3, $t3		# If still in the bounds then go back
	ble	$t1, $t4, y_loop	
	
	addi	$t0, $t0 1		# Increment the x-coordinate by 1
	
	add	$t4, $a3, $t2		# If still in the bounds then go back
	ble	$t0, $t4, x_loop	
	
	jr	$ra
	
#======================================================================================
# * Get Pixel
#--------------------------------------------------------------------------------------
# Gets the address of a pixel on screen
# @param: $a0 is the x coodinate
# @param: $a1 is the y coordinate
# @return: $v0 is the address of the pixel
#======================================================================================
GetPixel:
	lw	$t2, ScreenSize		# Get the screen size
	mul	$t2, $t2, 4		# Multiply the screen size by 4, to account for memory
	mul	$t0, $a0, 4		# Get the address part of the x-ccordinate
	mul	$t1, $a1, $t2		# Get the address part of the y-coordinate
	addu	$v0, $t0, $t1		# Combine the two parts to get the final address modifier
	addiu	$v0, $v0, 0x10040000	# Add the address value of the heap
	jr	$ra
	
#======================================================================================
# * Get Pixel
#--------------------------------------------------------------------------------------
# Gets the address of a pixel on screen
# @param: $a0 is the x coodinate
# @param: $a1 is the y coordinate
# @param: $a2 is the color to be drawn
#======================================================================================
FillPixel:
	subu 	$sp, $sp, 8		# Get the address of the pixel to store
	sw 	$ra, 0($sp)
	sw	$a2, 4($sp)		# Store the x and y coordinates
	jal 	GetPixel
	lw 	$ra, 0($sp)		
	lw	$a2, 4($sp)		# Restore the x and y coordinates
	addu 	$sp, $sp, 8		
	
	la	$t0, ColorTable		# Color the pixel
	mul	$t1, $a2, 4
	addu	$t1, $t0, $t1		
	lw	$t2, 0($t1)
	sw	$t2, 0($v0)
	
	jr	$ra
	
#======================================================================================
# * Draw Number
#--------------------------------------------------------------------------------------
# Draws a number in a given square
# @param: $a0 is the x coodinate
# @param: $a1 is the y coordinate
# @param: $a2 is the number
#======================================================================================
DrawNum:
	blez	$a2, post_draw		# Don't draw a 0
	addi	$a2, $a2, '0'		# Convert from the number to a character
	sb	$a2, NumberStr		# Save it to the buffer
	la	$a2, NumberStr
	
	lw	$t0, ScreenSize		# Get the screen size in pixels
	rem	$t1, $t0, 10		# and mod it by 10
	div	$t1, $t1, 2		# Get halfway across to get the original offset
	div	$t2, $t0, 10		# Get the width of each of the boxes
	div	$t3, $t2, 2		# Move the board over by half the pixel width
	add	$t1, $t1, $t3
	
	mul	$a0, $a0, $t2		# X = x * box_width + offset + 11
	add	$a0, $a0, $t3
	add	$a0, $a0, 11
	mul	$a1, $a1, $t2		# Y = y * box_width + offset + 10
	add	$a1, $a1, $t3
	add	$a1, $a1, 10
	
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	jal	OutText
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	
post_draw:
	
	jr	$ra
	
#======================================================================================
# * Panda Digit Module
#--------------------------------------------------------------------------------------
# Don't actually edit this. This is dangerous
#======================================================================================
.data

Colors: .word   0x000000        # background color (black)
        .word   0xffffff        # foreground color (white)

DigitTable:
        .byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        .byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        .byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        .byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        .byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        .byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        .byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        .byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   '*', 0x00,0x00,0x00,0x66,0x3c,0x18,0x18,0x3c,0x66,0x00,0x00,0x00
        .byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        .byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        .byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        .byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        .byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
# add additional characters here....
# first byte is the ascii character
# next 12 bytes are the pixels that are "on" for each of the 12 lines
        .byte    0, 0,0,0,0,0,0,0,0,0,0,0,0




#  0x80----  ----0x08
#  0x40--- || ---0x04
#  0x20-- |||| --0x02
#  0x10- |||||| -0x01
#       ||||||||
#       84218421

#   1   ...xx...      0x18
#   2   ..xxxx..      0x3c
#   3   .xx..xx.      0x66
#   4   xx....xx      0xc3
#   5   xx....xx      0xc3
#   6   xx....xx      0xc3
#   7   xxxxxxxx      0xff
#   8   xxxxxxxx      0xff
#   9   xx....xx      0xc3
#  10   xx....xx      0xc3
#  11   xx....xx      0xc3
#  12   xx....xx      0xc3

.text


# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, Colors
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        la      $t7, Colors     # else it is white
        lw      $t7, 4($t7)
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra	
