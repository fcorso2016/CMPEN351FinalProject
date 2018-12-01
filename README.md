# MIPS Sudoku
## Project Description

The project is a basic game of Sudoku where the player must fill every square in a 9x9 board with integers from 1-9 where each row, column and 3x3 subsection can only use each number once. A number of squares in the board are permanently fixed at specific values, which are pre-determined upon the start of the game. Gameboards are loaded in from an external text file which has the starting board configuration contained inside. The text file contains a series of numbers. The first is the number of squares that are pre-filled, followed by that many lines of 3 numbers which contain the x and y coordinate of the square and the value inside.

Once the board has been loaded the player navigates the board which is rendered in a visual dis-play within Mars using WASD navigation and pressing E to select a square. Once a square in selected the player can either enter a number 1-9 to change the value in the square or press Q to cancel out of a selec-tion. Upon winning MARS will play a small victory fanfare. Once completed, the game will ask if the player if they want to play again, after which the game resets, otherwise the game exits.

## Mars Configuration

This is a program written in the MIPS Assembly Language using the Mars simulator to run it. To properly utilize Mars the following configuration should be used:

    Using the graphical display, select the following settings.
    ![alt text](https://i.imgur.com/h5kUf7E.png)

    