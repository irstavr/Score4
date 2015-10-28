%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAYER -
% Code that is run when user player is chosen to play its next move.
%
% This file is given as input only when User Player plays.
% Whenever a player makes a move, writes the predicate 'taken' on a file
% that represents the state of the game board. Using this predicate, Computer
% can see which are the taken cells and select one that it is playable, empty.
%
% When user plays from GUI, sends to ASP a predicate 'showLine' with the number
% of column that the user decided to play on. ASP returns back the last available
% cell that is not occupied by anyone on this column. So, player plays on that
% cell.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the player and enemy of this turn of the game.
player(1).
enemy(2).

% Define the rows and columns for making all the combinations on the grid
% for the cells of the game
row(0..5).
column(0..6).
cell(R,Y) :- row(R), column(Y).

% Generates all possible split of the "playable" cells into two sets,
% the  selected  for  the  next move, and the rest.
occupiedCell(R,C) | not occupiedCell(R,C) :- playable(R,C).

% Mark as 'cellTaken' all the cells that are taken either by player 1 or player 2
cellTaken(R,C) :- taken(_,R,C).

% Taken are the cells that the enemy occupied on its last move.
taken(A,R,C)   :- lastEnemyMove(A,R,C), enemy(A).

% Find all the empty cells
empty(R,C)     :- not cellTaken(R,C),   cell(R,C).

% playable predicate finds the cell that a player can play in, given a number
% of column. If a man is put in one of the columns,
% it will fall down to the lowest unoccupied square in the column.
playable(R,C) :-
    cellTaken(R1,C),
    R1=R+1,
    R<5,
    empty(R,C).

% This predicate is expected to run the first time
% Makes sure that if the bottom line of the grid is empty, the next move
% will be there (R = 5)
playable(R,C):- empty(R,C), R = 5.

% The player can occupy only one cell at each turn
% This is a basic player, with no particular intelligent behaviour.
:- not #count{R,C: occupiedCell(R,C)} = 1.

% predicate used from user to take back the unoccupied last cell
% on the column C that is selected from user through predicate inputLine.
showLine(R) :-
	playable(R,C),
	inputLine(C).

#show showLine/1.
