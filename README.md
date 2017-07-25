# sudoku

### Testing the program

There are 5 test boards hard-coded into the program.

To run the code with the most difficult board I could find, just navigate to this repo in terminal and type `ruby sudoky.rb`.

The very last lines initialize a new game with the code `trial = Solver.new(test_5)` and then run that game with `trial.solve`. To see the program run with an easier puzzle, replace the `test_5` with `test_1`. Tests 1-5 are ordered in ascending difficulty. Only tests 4 and 5 require the program to branch. 

### The strategy

This program attempts to programmatically solve sudoku using the same human logic we use to solve sudoku. The difference is that while it's really hard for a person to manage 81 different arrays of 9 possibilities (729 values), it's very easy for a machine to do the same. 

In essence, the program will render each cell as an object with a stored array of possible values, and an attribute for a chosen value. It then stores each of those objects in three different arrays: one for the square, one for the row, and one for the column in which that cell exists. 

### The loop

The program then runs the following operations, in order, repeating until the board is solved. 
1. Takes each of the 81 cells and examines the associated cells in that row, column, and square - for each associated cell that is already filled in, it eliminates that value from the array of possibilities for that cell.
2. Examines each of the 81 cells - if the cell hasn't been filled in, but the array of possibilities has been narrowed down to a single possible value, it fills in that cell with the last possibility. 
3. Takes each of the 27 groups (rows, columns, squares) and, for each one, looks at the numbers 1-9. If there's only one cell left that could house a missing value for that group, it assigns that value to that cell. 
4. If there's an impasse, and steps 1-3 run without filling in any squares, the game needs to bifurcate in order to be solved. The program will find the first cell that has been narrowed down to two possibilities and make a random guess. It stores the value which was **not** chosen as a backup value for that cell.

The program will continue to loop steps 1-3 until it either solves the board or reaches a paradox. If it reaches a paradox, it will go back to the very beginning, but will assume the backup value was correct, and start with that assumption in place.

### Future iterations

* I haven't found a board that requires more than 1 single bifurcation to solve. Would be interested in seeing whether this board can correctly handle forking more than once. 
* Obviously, the process of hardcoding in 81 values, most of which are just "nil" is tedious. Should build a web interface. Could do using Sinatra. Haven't yet. Curious about HAML for input values (not just output values).
* There's a stragegy wherein you can examine a matching pair of possibilities and then eliminate those values as possibilities elsewhere in the row. I haven't found that strategy helpful - every time I hit an impasse, there were no matching pairs in any given row, so it may actually be redundant with the more basic systematic solving. Would love to see a board where this is a key method in avoiding branching.
* If this program works for n=3 (81 cells, values 1-9), it'd be fun to refactor it so that I could also solve for n=4 (256 cells, 1-16).
* There appear to be a lot of [mysteries left in sudoku](https://en.wikipedia.org/wiki/Mathematics_of_Sudoku), so it would be fun to tackle a completely new project that does the opposite of this one - exhaustively generates all boards instead of efficiently solving one. 
