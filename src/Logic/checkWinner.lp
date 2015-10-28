%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WINNER CODE
% Check in every run of the game if there is already a winner.
% To have a winner, a player needs to have 4 taken cells in the
% same row, or same column or in a diagonal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check on rows if there are 4 sequential cells
% We give 4 different cells as arguments with their dimension R(ow),C(olumn)
% In order to form a row, cells need to have the same Row number and their
% column numbers to be incremented between each other.
checkQuartet(R,C, R1,C1, R2,C2, R3,C3) :-
	cell(R,C),
	cell(R1,C1),
	cell(R2,C2),
	cell(R3,C3),
	R = R1,
	R = R2,
	R = R3,
	C1 = C + 1,
	C2 = C + 2,
	C3 = C + 3.

% check on columns if there are 4 sequential cells
% We give 4 different cells as arguments with their dimension R(ow),C(olumn)
% In order to form a column, cells need to have the same Column number and their
% row numbers to be incremented between each other.
checkQuartet(R,C, R1,C1, R2,C2, R3,C3) :-
	cell(R,C),
	cell(R1,C1),
	cell(R2,C2),
	cell(R3,C3),
	C = C1,
	C = C2,
	C = C3,
	R1 = R + 1,
	R2 = R + 2,
	R3 = R + 3.

% check on diagonal A if there are 4 sequential cells
% We give 4 different cells as arguments with their dimension R(ow),C(olumn)
% In order to form a diagonal A, cells need to have their row numbers in
% incremented order, same as well for their column numbers.
checkQuartet(R,C, R1,C1, R2,C2, R3,C3) :-
	cell(R,C),
	cell(R1,C1),
	cell(R2,C2),
	cell(R3,C3),
	R1 = R + 1,
	R2 = R + 2,
	R3 = R + 3,
	C1 = C + 1,
	C2 = C + 2,
	C3 = C + 3.

% check on diagonal B if there are 4 sequential cells
% We give 4 different cells as arguments with their dimension R(ow),C(olumn)
% In order to form a diagonal A, cells need to have their row numbers in
% incremented order, and their column number in decreasing order.
checkQuartet(R,C, R1,C1, R2,C2, R3,C3) :-
	cell(R,C),
	cell(R1,C1),
	cell(R2,C2),
	cell(R3,C3),
	R1 = R + 1,
	R2 = R + 2,
	R3 = R + 3,
	C1 = C - 1,
	C2 = C - 2,
	C3 = C - 3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if player P is a possible winner in the game.
% We have a winner P if there is an available quartet on the game
% and player P has occupied all of these cells.
winner(P) :-
	checkQuartet(R,C, R1,C1, R2,C2, R3,C3),
	taken(P, R,C),
	taken(P, R1,C1),
	taken(P, R2,C2),
	taken(P, R3,C3).

% Returns back both the player P and the winnery quartet of the game.
% We retrieve the winner of the game through 'winner' rule
% and check again if all the cells of the quartet of the game are
% taken by this winner player P.
winneryQuartet(P, R,C, R1,C1, R2,C2, R3,C3) :-
	winner(P),
	checkQuartet(R,C,R1,C1,R2,C2,R3,C3),
	taken(P, R,C),
	taken(P, R1,C1),
	taken(P, R2,C2),
	taken(P, R3,C3).

% Checks if rule winner activates and we have a winnery quartet
% Returns back the winner player P.
weHaveWinner(P) :-
	winner(P),
	winneryQuartet(P, R,C, R1,C1, R2,C2, R3,C3).

% Check if the board is full and there is none winner yet on the game
% In this case, we have a tie.
weHaveATie(yes) :-
	#count{R,C: empty(R,C)}=0,
	cell(R,C),
	not weHaveWinner(P),
	player(P).


% Marks the end of the game, either when we have a tie or have a winner.
endOfGame() :-
    1 {weHaveATie(R); weHaveWinner(P)} 1.


#show winner/1.
