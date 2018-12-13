# MIPS Sudoku

## Overview 

### Project Description

The project is a basic game of Sudoku where the player must fill every square in a 9x9 board with integers from 1-9 where each row, column and 3x3 subsection can only use each number once. A number of squares in the board are permanently fixed at specific values, which are pre-determined upon the start of the game. Gameboards are loaded in from an external text file which has the starting board configuration contained inside. The text file contains a series of numbers. The first is the number of squares that are pre-filled, followed by that many lines of 3 numbers which contain the x and y coordinate of the square and the value inside.

### Mars Configuration

This is a program written in the MIPS Assembly Language using the Mars simulator to run it. To properly utilize Mars the following configuration should be used:

Using the graphical display, select the following settings.

![alt text](https://i.imgur.com/h5kUf7E.png)

Alteratively either of the following may also be used:

![alt text](https://i.imgur.com/fMMNPPA.png) ![alt text](https://i.imgur.com/LHC5jOR.png)

Everything else can be left to the default settings

### How to Play

Once the board has been loaded the player navigates the board which is rendered in a visual dis-play within Mars using WASD navigation and pressing E to select a square. Once a square in selected the player can either enter a number 1-9 to change the value in the square or press Q to cancel out of a selec-tion. Upon winning MARS will play a small victory fanfare. Once completed, the game will ask if the player if they want to play again, after which the game resets, otherwise the game exits.

## Project Details

### Architectural Design

#### Appearance and Game Flow

When the program first starts the bitmap display should clear itself making the entire screen black to prevent any conflicts with previous runs using Mars. Once that's done the board will appear in the center of the screen like so:

![alt text](https://i.imgur.com/QjqJzhQ.png)

The user moves around the board using WASD controls (the console in Mars must be selected in order to do this). When the user wants to select a square, they should press the E key, which will cause the cursor to turn yellow, like so:

![alt text](https://i.imgur.com/30Hpqpa.png)

Be forewarned that the user cannot make changes to a pre existing numbers. Pressing E on one of those will do nothing. The user can deselect a number by pressing Q. Alternatively the user can enter a number 1-9 to place it in. Any other keypress will be ignored.

#### Program Flow

The program runs using the following rough flow:

![alt text](https://i.imgur.com/M1MmMOe.png)

### Test/Verification Plan

This program was build in pieces with all the of the major graphical components built one at a time. (I.e. All the lines were drawn before the numbers were placed and then the numbers were drawn). After that the cursor's placement was done. Once the visuals were done, the board loading was done, loading from a single text file everytime for the intial testing, with the loaded information being placed into the board array.

After that was completed, the core gameplay loop was created, which was tested within the rest of the program, as the visuals were needed to properly test the gameplay. This was subdivided, with the movement fully tested and working first before the numeric input was tested.

Finally victory checking was implemented and tested independently from the rest of the program with a presolved board in data. All three of the different clauses were done independently from each other with the horizontals being tested, before the verticals and finally the individual blocks.

Finally the last component that was added was the random board loading which was done by simply replacing a few characters on the the source input file, as all boards shared the same naming scheme. This was tested in isolation before being integrated into the program.

The victory fanfare algorithm already exists from the Simon Says lab, so that simply needed to be inserted into the code with no real modifications.

### Debug Issues

The biggest issue with the visuals came from making sure the white lines were all on time (i.e. there were no gray lines displaying in-front). This was solved by redrawing all the white lines again after everything was drawin the first time.

Another issue with the process was loading in from a text file, as the text files included \n and \r characters in them that had to be accounted for. This was done, by having a second counter in the loading loop that would only count up if it encountered a numeric character.

A small minor issue that arose with the numbers was the fact that the user could theoretically overwrite one of the default numbers, this was prevented simply by having the default numbers having a 1 placed in the 5th bit, which would be ignored when displaying in and checking for victory.

The biggest issue with the victory checking was simply finding the right formula for the cell offset as they were encoded using a single number to find the offset. Otherwise, the algorithms worked just fine.
 