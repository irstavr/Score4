%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose Next Move for PC
% PC has to decide about its next move - here we give the possible moves it can
% perform. And restrict to the ones that seem better on each turn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STRATEGY OF THE GAME:
% PC first checks if there is an available quartet it can perform.
% If there is one, it plays for that move.
% If there is none available quartet for PC, checks if enemy player can complete
% a quartet. If yes, it attacks on that cell and prevents enemy of winning.
% If there is none available quartet for both PC and enemy player, it tries to
% form a triplet. If it's not possible it prevents enemy of doing so.

% Possible moves are checked either on a row, column or the two diagonals.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Apply a rule 'play' whenever we have a playable cell.
% We get the playable cells from Computer.lp code
1{play(R,C): playable(R,C)}1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% computer %%%%%%%%%

%%%%%% check if PC can complete a triplet

% code of these 'triplets' is found on DefenseComputer.lp file

% Possible triplet on a row
prefTripletRow(R,C,R1,C1) :-
	tripleInARow(R,C), not tripleInARow(R1,C1),
  	playable(R,C), playable(R1,C1).

% Possible triplet on a column
prefTripletCol(R,C,R1,C1) :-
	tripleInACol(R,C), not tripleInACol(R1,C1),
  	playable(R,C), playable(R1,C1).

% Possible triplet on a diagonal
prefTripletDiag(R,C,R1,C1) :-
	tripleInADiagonal(R,C), not tripleInADiagonal(R1,C1),
  	playable(R,C), playable(R1,C1).

%%%%%% check if PC can complete a quartet

% Possible quartet on a row
prefFourRow(R,C,R1,C1) :-
	fourInARow(R,C), not fourInARow(R1,C1),
  	playable(R,C), playable(R1,C1).

% Possible quartet on a column
prefFourCol(R,C,R1,C1) :-
	fourInACol(R,C), not fourInACol(R1,C1),
  	playable(R,C), playable(R1,C1).

% Possible quartet on a diagonal
prefFourDiag(R,C,R1,C1) :-
	fourInADiag(R,C), not fourInADiag(R1,C1),
  	playable(R,C), playable(R1,C1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% enemy %%%%%%%%%

%%%%%% check here if enemy player can complete a quartet
% Use these rules in order to make PC to attack on these cells
% if it doesn't have a quartet to complete for its own.

% Possible quartet on a row
prefFourRowEnemy(R,C,R1,C1) :-
	fourInARowEnemy(R,C), not fourInARowEnemy(R1,C1),
  	playableByPlayer(R,C), playableByPlayer(R1,C1).

% Possible quartet on a column
prefFourColEnemy(R,C,R1,C1) :-
	fourInAColEnemy(R,C), not fourInAColEnemy(R1,C1),
  	playableByPlayer(R,C), playableByPlayer(R1,C1).

% Possible quartet on a diagonal
prefFourDiagEnemy(R,C,R1,C1) :-
	fourInADiagEnemy(R,C), not fourInADiagEnemy(R1,C1),
  	playableByPlayer(R,C), playableByPlayer(R1,C1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% check the combinations %%%%%%%%%


% Check if there is an available quartet to be filled from the PC
% That means there's either a quartet on a row, col or diagonal that it can
% complete and win the game.
allFour(R,C) :-
	1{prefFourDiag(R,C,R1,C1) ; prefFourCol(R,C,R1,C1) ; prefFourRow(R,C,R1,C1)}3 ,
	cell(R1,C1),
	cell(R,C).

% Check if there is an available quartet to be filled from the enemy player
% That means there's either a quartet on a row, col or diagonal that it can
% complete and win the game.
allFourEnemy(R,C) :-
	1{prefFourRowEnemy(R,C,R1,C1) ; prefFourColEnemy(R,C,R1,C1) ; prefFourDiagEnemy(R,C,R1,C1)}3,
	cell(R1,C1),
	cell(R,C).

% Check if there is an available triplet to be filled from the PC
% That means there's either a quartet on a row, col or diagonal that it can
% complete and win the game.
allTriplets(R,C) :-
	1{prefTripletRow(R,C,R1,C1) ; prefTripletCol(R,C,R1,C1) ; prefTripletDiag(R,C,R1,C1)}3 ,
	cell(R1,C1),
	cell(R,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% priorities between rules %%%%%%

% Here we define the order that we want PC to check its available moves.
% First it checks if rule 'allFour' activates. If so, it plays on that cell.
% Otherwise, it continues to 'allFourEnemy'  and 'allTriplets' rules.


%:-  allFour(R,C,R1,C1), play(R1,C1), not play(R,C).

:-  allFour(R,C), not allFour(R1,C1), play(R1,C1), not play(R,C).

%:-  allFourEnemy(R,C,R1,C1), not allFour(R1,C1,R,C),
%	play(R1,C1), not play(R,C).

:-  allFourEnemy(R,C), not allFour(R1,C1), not allFourEnemy(R1,C1),
	play(R1,C1), not play(R,C).

%:-  allTriplets(R,C,R1,C1), not allFourEnemy(R1,C1,R,C), not allFour(R1,C1,R,C),
%	play(R1,C1), not play(R,C).

:-  allTriplets(R,C), not allTriplets(R1,C1), not allFourEnemy(R1,C1), not allFour(R1,C1),
	play(R1,C1), not play(R,C).

%:- allFour(R,C,R1,C1), play(R1,C1), not play(R,C), allFourEnemy(R,C,R1,C1), allTriplets(R,C,R1,C1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% output %%%%%%
#show play/2.
