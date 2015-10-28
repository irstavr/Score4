%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTER -
% Code that is run when PC is chosen to play its next move.
%
% This file is given as input only when PC plays.
% Whenever a player makes a move, writes the predicate 'taken' on a file
% that represents the state of the game board. Using this predicate, Computer
% can see which are the taken cells and select one that it is playable, empty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the player and enemy of this turn of the game.
player(2).
enemy(1).

% Define the rows and columns for making all the combinations on the grid
% for the cells of the game
row(0..5).
column(0..6).
cell(R,C) :- row(R), column(C).

% Generates all possible split of the "playable" cells into two sets,
% the  selected  for  the  next move, and the rest.
occupiedCell(R,C) | not occupiedCell(R,C) :- playable(R,C).

% Mark as 'cellTaken' all the cells that are taken either by player 1 or player 2
cellTaken(R,C) :- taken(1,R,C).
cellTaken(R,C) :- taken(2,R,C).

% Taken are the cells that the enemy occupied on its last move.
taken(A,R,C)   :- lastEnemyMove(A,R,C), enemy(A).

% Find all the empty cells
empty(R,C)     :- not cellTaken(R,C),   cell(R,C).

% playable predicate finds the cell that a player can play in, given a number
% of column. If a man is put in one of the columns,
% it will fall down to the lowest unoccupied square in the column.
playable(R,C) :-
    cellTaken(R1,C),
    R1 = R + 1,
    R < 5,
    empty(R,C).

% This predicate is expected to run the first time
% Makes sure that if the bottom line of the grid is empty, the next move
% will be there (R = 5)
playable(R,C):- empty(R,C), R = 5.

% A first strategic glimpse: if cell (5,3) [the middle cell] is still available,
% the  player  has  to  occupy  it ==> give the  player an advantage.
:- not occupiedCell(5,3),  playable(5,3).

% The player can occupy only one cell at each turn
% This is a basic player, with no particular intelligent behaviour.
:- not #count{R,C: occupiedCell(R,C)} = 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POSSIBLE MOVES FOR THE PC -- ATTACK --
% find all the combination of the possible moves that PC can perform
% without taking into mind enemy's moves.
% find all the possible double, triple and quartet moves.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check if two cells (R,C) and (R1,C1) form a double in a row, col or diagonal.


% Two cells adjacent in a row R
twoInRow(R, C, R1, C1) :-
	taken(2, R, C),
    taken(2, R1, C1),
    1 {C1 = C + 1; C1 = C - 1} 1 ,
    R = R1.

% Two cells between each other in a row R
twoBetween(R, C, R1, C1) :-
	taken(2, R, C),
    taken(2, R1, C1),
    1 {C1 = C + 2; C1 = C - 2} 1 ,
    R = R1.

% Two cells in a diagonal A
twoInDiagonal(R, C, R1, C1) :-
	taken(2, R, C),
    taken(2, R1, C1),
    C1 = C + 1,
    R1 = R + 1.

% Two cells adjacent in a diagonal B
twoInDiagonal(R, C, R1, C1) :-
	taken(2, R, C),
    taken(2, R1, C1),
    C1 = C - 1,
    R1 = R - 1.

% Two cells adjacent in a col C
twoInColumn(R, C, R1, C1) :-
	taken(2, R, C),
    taken(2, R1, C1),
    1 {R1 = R + 1 ; R1 = R - 1} 1 ,
    C = C1.

% Two cells between in a diagonal.
twoInBetween(R1, C1, R2, C2) :-
	taken(2, R2, C2),
    taken(2, R1, C1),
    1 {C1 = C2 - 2 ; C1 = C2 + 2} 1,
    1 {R1 = R2 - 2 ; R1 = R2 + 2} 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in a row R
% take a combination of two already formed doubles and check if next move
% on R,C can implement a triple in a row, col or diagonal.

% Move to R,C that is the first left empty cell on a row R, col C
% that can complete a triple
tripleInARow(R, C) :-
	twoInRow(R1,C1, R2,C2),
	%twoInRow(R,C, R3,C3),
	C = C1 + 2,
	C = C2 + 1,
	C = C3 - 1,
	R = R1,
	R2 = R1,
	R3 = R,
	empty(R3,C3),
	playable(R,C).

% Move to R,C that is the empty cell between two adjacent on a row R, col C
% that can complete a triple
tripleInARow(R, C) :-
	twoBetween(R1, C1, R2, C2),
	%twoInRow(R,C, R3,C3),
	C = C1 + 1,
	C = C2 - 1,
	1 {C = C3 - 2 ; C = C3 + 2} 1,
	R = R1,
	R2 = R1,
	R3 = R,
	empty(R3,C3),
	playable(R,C).

% Move to R,C that is the third right cell between two adjacent on a row R, col C
% that can complete a triple
tripleInARow(R, C) :-
	twoInRow(R1,C1, R2,C2),
	1 {C = C3 - 1 ; C = C3 - 3} 1,
	C = C1 - 1,
	C = C2 - 2,
	R = R1,
	R2 = R1,
	R3 = R,
	empty(R3,C3),
	playable(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Third Right
tripleInACol(R, C) :-
	twoInColumn(R1,C1, R2,C2),
	R = R1 - 2,
	R = R2 - 1,
	C = C1,
	C2 = C1,
	playable(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diagonals in the grid:

% 2h diagwnios terma katw deksia
tripleInADiagonal(R,C):-
	twoInDiagonal(R1, C1, R2, C2),
	R = R1 + 1,
	R = R2 + 2,
	C = C1 + 1,
	C = C2 + 2 ,
	playable(R,C).


% 2h diagwnios between
tripleInADiagonal(R,C):-
	twoInBetween(R2, C2, R1, C1),
	R = R1 + 1,
	R = R2 - 1,
	C = C1 + 1,
	C = C2 - 1,
	playable(R,C).

% 2h diagwnios terma panw deksia
tripleInADiagonal(R,C):-
	twoInDiagonal(R1, C1, R2, C2),
	R = R2 - 2,
	R = R1 - 1,
	C = C1 - 1,
	C = C2 - 2,
	playable(R,C).


% 1h diagwnios terma katw aristera
tripleInADiagonal(R,C):-
	twoInDiagonal(R1, C1, R2, C2),
	R = R1 + 1,
	R = R2 + 2,
	C = C1 - 1,
	C = C2 - 2 ,
	playable(R,C).


% 1h diagwnios between
tripleInADiagonal(R,C):-
	twoInBetween(R2, C2, R1, C1),
	R = R1 + 1,
	R = R2 - 1,
	C = C1 + 1,
	C = C2 - 1,
	playable(R,C).

% 1h diagwnios terma panw aristera
tripleInADiagonal(R,C):-
	twoInDiagonal(R1, C1, R2, C2),
	R = R2 - 2,
	R = R1 - 1,
	C = C1 + 1,
	C = C2 + 2,
	playable(R,C).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in a row R
%

% take two combinations of two already formed doubles and check if next move
% on R,C can implement a quartet in a row R.
fourInARow(R, C) :-
	twoInRow(R1,C1, R2,C2),
	twoInRow(R2,C2, R3,C3),
	C = C1 + 3,
	C = C2 + 2,
	C = C3 + 1,
	R = R1,
	R2 = R1,
	R2 = R3,
	playable(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in a column C
%

% find two doubles in same column C that are sequential and
% can complete a quartet in a column C.
fourInACol(R, C) :-
	twoInColumn(R1,C1, R2,C2),
	twoInColumn(R2,C2, R3,C3),
	R = R1 - 3,
	R = R2 - 2,
	R = R3 - 1,
	C = C1,
	C2 = C1,
	C3 = C1,
	playable(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in diagonal
%

% 1h diagwnios 1o deksia
fourInADiag(R, C) :-
    taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R3 - 1,
	R = R2 - 2,
	R = R1 - 3,
	C = C1 + 3,
	C = C3 + 1,
	C = C2 + 2,
	R<R1, R<R2, R<R3,
	C>C1, C>C2,	C>C3,
	playable(R,C).

% 1h diagwnios 2o deksia
fourInADiag(R, C) :-
    taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R3 + 1,
	R = R2 - 1,
	R = R1 - 2,
	C = C1 + 2,
	C = C3 - 1,
	C = C2 + 1,
	R>R1, R<R2, R<R3,
	C>C1, C<C2,	C>C3,
	playable(R,C).

% 1h diagwnios 3o deksia
fourInADiag(R, C) :-
    taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 - 1,
	R = R2 + 1,
	R = R3 + 2,
	C = C1 + 1,
	C = C3 - 2,
	C = C2 - 1,
	R<R1, R>R2, R>R3,
	C>C1, C<C2,	C<C3,
	playable(R,C).

% 1h diagwnios 4o deksia
fourInADiag(R, C) :-
    taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 - 1,
	R = R2 - 2,
	R = R3 - 3,
	C = C1 + 1,
	C = C2 + 2,
	C = C3 + 3,
	R>R1, R>R2,  R>R3,
	C<C1, C>C2,  C<C3,
	playable(R,C).


% 2h diagwnios 1o deksia
fourInADiag(R, C) :-
    taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 - 1,
	R = R3 - 3,
	R = R2 - 2,
	C = C1 - 1,
	C = C2 - 2,
	C = C3 - 3,
	R<R1, R<R2, R<R3,
	C<C1, C<C2,	C<C3,
	playable(R,C).

% 2h diagwnios 2o deksia
fourInADiag(R, C) :-
	taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 + 1,
	R = R2 - 1,
	R = R3 - 2,
	C = C1 + 1,
	C = C3 - 2,
	C = C2 - 1,
	R>R1, R<R2, R<R3,
	C>C1, C<C2,	C<C3,
	playable(R,C).

% 2h diagwnios 3o deksia
fourInADiag(R, C) :-
	taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 + 2,
	R = R2 + 1,
	R = R3 - 1,
	C = C1 + 2,
	C = C3 - 1,
	C = C2 + 1,
	playable(R,C).

% 2h diagwnios 4o deksia
fourInADiag(R, C) :-
	taken(2, R1, C1),
    taken(2, R2, C2),
    taken(2, R3, C3),
	R = R1 + 3,
	R = R2 + 2,
	R = R3 + 1,
	C = C1 + 3,
	C = C2 + 2,
	C = C3 + 1,
	R>R1, R>R2, R>R3,
	C>C1, C>C2,	C>C3,
	playable(R,C).
