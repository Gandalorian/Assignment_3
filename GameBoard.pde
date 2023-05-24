/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

/*
 * This file holds some functions that are used to set up the game board.
 */

/*
 * Resets the board state to the default setup. 
 * Called when an iteration ends.
 */
void resetBoard() {
    qLearning.calculationTank.x = qLearning.calculationTank.team.homebase[0] + 1;
    qLearning.calculationTank.y = qLearning.calculationTank.team.homebase[1] + 1;

    wtVisited = 0;

    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j].visited = false;
            gameBoard[i][j].visitCount = 0;
        }
    }
}

/*
 * Checks if all nodes have been visited, and thus if the game is over.
 */
boolean allNodesVisited() {
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            if(!gameBoard[i][j].visited && !gameBoard[i][j].obstacle) {
                return false;
            }
        }
    }
    return true;
}

/*
 * Updates the state of the primary win condition (if all towers have been visited).
 * Described as all permutations of towers visited.
 */
int checkVisitedTowers(){
    int visitedPermutation = 0;
    if(gameBoard[watchtowers[0]][watchtowers[1]].visited){
        visitedPermutation += 1;
        wtVisited++;
    }
    if(gameBoard[watchtowers[2]][watchtowers[3]].visited){
        visitedPermutation += 2;
        wtVisited++;
    }
    if(gameBoard[watchtowers[4]][watchtowers[5]].visited){
        visitedPermutation += 4;
        wtVisited++;
    }
    if(visitedPermutation == 7){
        println("All towers visited!");
        qLearning.winsAchieved++;
    }
    return visitedPermutation;
}

/*
 * Checks if all towers have been visited.
 * This is the primary win condition.
 */
boolean allWatchtowersVisited(){
    int w = 0;
    for(int i = 0; i < watchtowers.length; i+= 2){
        if(!gameBoard[watchtowers[i]][watchtowers[i+1]].visited){
            return false;
        }
        w++;
        wtVisited = w;
    }
    println("All towers visited!");
    qLearning.winsAchieved++;
    return true;
}

/*
 * This function is used to set up the game board.
 */
void setGameBoard16() {
    setHomeBases16();
    setTrees16();
    setSwamps16();
    setLandmines16();
    setWatchtowers16();
}


/*
 * Defines the locations of PACT and NATOs home bases.
 * The bases are defined as a 3x7 rectangle in the top left and bottom right corners.
 */
void setHomeBases16() {
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 7; j++){
            gameBoard[i][j].type = CellType.PACT;
        }
    }

    for(int i = 15; i > 12; i--){
        for(int j = 15; j > 8; j--){
            gameBoard[i][j].type = CellType.NATO;
        }
    }
}

/*
 * Defines the locations of trees on the map.
 */
void setTrees16() {
    trees = new Tree[3];
    trees[0] = new Tree(5,12);
    trees[1] = new Tree(6,5);
    trees[2] = new Tree(11,10);
    for(int i = 4; i < 6; i ++) {
        for(int j = 11; j < 13; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }

    for(int i = 5; i < 7; i ++) {
        for(int j = 4; j < 6; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }

    for(int i = 10; i < 12; i ++) {
        for(int j = 9; j < 11; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
}

/*
 * Defines the locations of minefields on the map.
 * Mines instantly kill the tank and end the iteration.
 */
void setLandmines16() {
    //Minefield 1 {(9, 3), (9, 4), (9, 5), (10, 5)}
    gameBoard[9][3].type = CellType.LANDMINE;
    gameBoard[9][4].type = CellType.LANDMINE;
    gameBoard[9][5].type = CellType.LANDMINE;
    gameBoard[10][5].type = CellType.LANDMINE;

    //Minefield 2 {(2, 9), (3, 9), (4, 9), (3, 8)}
    gameBoard[2][9].type = CellType.LANDMINE;
    gameBoard[3][9].type = CellType.LANDMINE;
    gameBoard[4][9].type = CellType.LANDMINE;
    gameBoard[3][8].type = CellType.LANDMINE;

    //Minefield 3 {(7, 13), (8, 13), (9, 13), (7, 14), (8, 14), (9, 14)}
    gameBoard[7][13].type = CellType.LANDMINE;
    gameBoard[8][13].type = CellType.LANDMINE;
    gameBoard[9][13].type = CellType.LANDMINE;
    gameBoard[7][14].type = CellType.LANDMINE;
    gameBoard[8][14].type = CellType.LANDMINE;
    gameBoard[9][14].type = CellType.LANDMINE;
}

/*
 * Defines the locations of swamps on the map.
 * Swamps punish the tank due to the difficulty of traversing them.
 */
void setSwamps16() {
    //Swamp 1 {(4, 0), (5, 0), (6, 0), (5, 1), (6, 1)}
    gameBoard[4][0].type = CellType.SWAMP;
    gameBoard[5][0].type = CellType.SWAMP;
    gameBoard[6][0].type = CellType.SWAMP;
    gameBoard[5][1].type = CellType.SWAMP;
    gameBoard[6][1].type = CellType.SWAMP;

    //Swamp 2 {(8, 4), (8, 5), (8, 6), (7, 5), (7, 6), (6, 6)}
    gameBoard[8][4].type = CellType.SWAMP;
    gameBoard[8][5].type = CellType.SWAMP;
    gameBoard[8][6].type = CellType.SWAMP;
    gameBoard[7][5].type = CellType.SWAMP;
    gameBoard[7][6].type = CellType.SWAMP;
    gameBoard[6][6].type = CellType.SWAMP;

    //Swamp 3 {(13, 1), (14, 1), (15, 1), (12, 2), (13, 2), (14, 2), (12, 3), (13, 3), (14, 3), (12, 4)}
    gameBoard[13][1].type = CellType.SWAMP;
    gameBoard[14][1].type = CellType.SWAMP;
    gameBoard[15][1].type = CellType.SWAMP;
    gameBoard[12][2].type = CellType.SWAMP;
    gameBoard[13][2].type = CellType.SWAMP;
    gameBoard[14][2].type = CellType.SWAMP;
    gameBoard[12][3].type = CellType.SWAMP;
    gameBoard[13][3].type = CellType.SWAMP;
    gameBoard[14][3].type = CellType.SWAMP;
    gameBoard[12][4].type = CellType.SWAMP;

    //Swamp 4 {(1, 13), (2, 13), (1, 14), (2, 14), (3, 14), (2, 15), (3, 15), (4, 15)}
    gameBoard[1][13].type = CellType.SWAMP;
    gameBoard[2][13].type = CellType.SWAMP;
    gameBoard[1][14].type = CellType.SWAMP;
    gameBoard[2][14].type = CellType.SWAMP;
    gameBoard[3][14].type = CellType.SWAMP;
    gameBoard[2][15].type = CellType.SWAMP;
    gameBoard[3][15].type = CellType.SWAMP;
    gameBoard[4][15].type = CellType.SWAMP;
}

/*
 * Defines the locations of the three watchtowers.
 * Visiting all three is the objective of the game.
 */
void setWatchtowers16(){
    //Watchtower 1 {(4, 7)}
    gameBoard[watchtowers[0]][watchtowers[1]].type = CellType.WATCHTOWER;

    //Watchtower 2 {(14, 5)}
    gameBoard[watchtowers[2]][watchtowers[3]].type = CellType.WATCHTOWER;

    //Watchtower 3 {(7, 11)}
    gameBoard[watchtowers[4]][watchtowers[5]].type = CellType.WATCHTOWER;
}