%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFENCE - PC CHECKS IF ENEMY (PLAYER) HAS
% COMPLETED A POTENTIAL THREAT FOR THE GAME
%
% checks first if there is a quartet that player can complete
% in every dimension: row,column,diagonal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find all the cells with indeces R,C that player can move to in his next move.
% For a constant C, find the R (row num) that is the bigger one and not taken
% by any other player.
playableByPlayer(R, C) :-
    R1 = R + 1,
    R < 5,
    empty(R,C),
    1{taken(1,R1,C) ; taken(2,R1,C)}1.
    %cellTaken(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in a row R
% take two combinations of two already formed doubles and check if next move
% on R,C can implement a quartet in a row R.

% move to the 1st in a row
fourInARowEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	C = C1 + 3,
	C = C2 + 2,
	C = C3 + 1,
	R = R1,
	R2 = R1,
	R2 = R3,
	playableByPlayer(R,C).

% move to the 2nd in a row
fourInARowEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	C = C1 + 2,
	C = C2 + 1,
	C = C3 - 1,
	R = R1,
	R2 = R1,
	R2 = R3,
	playableByPlayer(R,C).

% move to the 3rd in a row
fourInARowEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	C = C1 + 1,
	C = C2 - 1,
	C = C3 - 2,
	R = R1,
	R2 = R1,
	R2 = R3,
	playableByPlayer(R,C).

% move to the 4th in a row
fourInARowEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	C = C1 - 1,
	C = C2 - 2,
	C = C3 - 3,
	R = R1,
	R2 = R1,
	R2 = R3,
	playableByPlayer(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in a column C
%

% find two doubles in same column C that are sequential and
% can complete a quartet in a column C.
fourInAColEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 - 3,
	R = R2 - 2,
	R = R3 - 1,
	C = C1,
	C2 = C1,
	C3 = C1,
	playableByPlayer(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find empty cells that if completed can perform a quartet in diagonal
%

% 1h diagwnios 1o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R3 - 1,
	R = R2 - 2,
	R = R1 - 3,
	C = C1 + 3,
	C = C3 + 1,
	C = C2 + 2,
	R<R1, R<R2, R<R3,
	C>C1, C>C2,	C>C3,
	playableByPlayer(R,C).

% 1h diagwnios 2o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R3 + 1,
	R = R2 - 1,
	R = R1 - 2,
	C = C1 + 2,
	C = C3 - 1,
	C = C2 + 1,
	R>R1, R<R2, R<R3,
	C>C1, C<C2,	C>C3,
	playableByPlayer(R,C).

% 1h diagwnios 3o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 - 1,
	R = R2 + 1,
	R = R3 + 2,
	C = C1 + 1,
	C = C3 - 2,
	C = C2 - 1,
	R<R1, R>R2, R>R3,
	C>C1, C<C2,	C<C3,
	playableByPlayer(R,C).

% 1h diagwnios 4o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 - 1,
	R = R2 - 2,
	R = R3 - 3,
	C = C1 + 1,
	C = C2 + 2,
	C = C3 + 3,
	R>R1, R>R2,  R>R3,
	C<C1, C>C2,  C<C3,
	playableByPlayer(R,C).


% 2h diagwnios 1o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 - 1,
	R = R3 - 3,
	R = R2 - 2,
	C = C1 - 1,
	C = C2 - 2,
	C = C3 - 3,
	R<R1, R<R2, R<R3,
	C<C1, C<C2,	C<C3,
	playableByPlayer(R,C).

% 2h diagwnios 2o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 + 1,
	R = R2 - 1,
	R = R3 - 2,
	C = C1 + 1,
	C = C3 - 2,
	C = C2 - 1,
	R>R1, R<R2, R<R3,
	C>C1, C<C2,	C<C3,
	playableByPlayer(R,C).

% 2h diagwnios 3o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 + 2,
	R = R2 + 1,
	R = R3 - 1,
	C = C1 + 2,
	C = C3 - 1,
	C = C2 + 1,
	playableByPlayer(R,C).

% 2h diagwnios 4o deksia
fourInADiagEnemy(R, C) :-
    taken(1, R1, C1),
    taken(1, R2, C2),
    taken(1, R3, C3),
	R = R1 + 3,
	R = R2 + 2,
	R = R3 + 1,
	C = C1 + 3,
	C = C2 + 2,
	C = C3 + 1,
	R>R1, R>R2, R>R3,
	C>C1, C>C2,	C>C3,
	playableByPlayer(R,C).
