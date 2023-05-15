/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

/*
 * This file holds some functions that are used to set up the game board.
 */

void resetGame(){
    gameBoard = new Node[gridSize][gridSize];
    trees = new Tree[3];
    tanks = new Tank[6];
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j] = new Node(CellType.EMPTY, i, j);
        }
    }
    redTeam = new Team(pactColor, redHomebase);
    blueTeam = new Team(natoColor, blueHomebase);

    tanks[0] = redTeam.tanks[0];
    tanks[1] = redTeam.tanks[1];
    tanks[2] = redTeam.tanks[2];
    tanks[3] = blueTeam.tanks[0];
    tanks[4] = blueTeam.tanks[1];
    tanks[5] = blueTeam.tanks[2];

    setGameBoard();
}

void setGameBoard() {
    setHomeBases();
    setTrees();
    setSwamps();
}

void setHomeBases() {
    for(int i = 0; i < 3; i++) {
        for(int j = 0; j < 7; j++){
            gameBoard[i][j].type = CellType.PACT;
        }
    }

    for(int i = 31; i > 28; i --) {
        for(int j = 31; j > 24; j--) {
            gameBoard[i][j].type = CellType.NATO;
        }
    }
}

void setTrees() {
    trees[0] = new Tree(5,12);
    trees[1] = new Tree(6,5);
    trees[2] = new Tree(11,10);
    trees[3] = new Tree(19,4);
    trees[4] = new Tree(23,11);
    trees[5] = new Tree(6,21);
    trees[6] = new Tree(16,20);
    trees[7] = new Tree(17,28);
    trees[8] = new Tree(28,4);
    trees[9] = new Tree(28,13);
    trees[10] = new Tree(23,16);
    trees[11] = new Tree(22,20);
    trees[12] = new Tree(30,20);
    trees[13] = new Tree(24,27);
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

    for(int i = 18; i < 20; i ++) {
        for(int j = 3; j < 5; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }

    for(int i = 22; i < 24; i ++) {
        for(int j = 10; j < 12; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 5; i < 7; i ++) {
        for(int j = 20; j < 22; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 15; i < 17; i ++) {
        for(int j = 19; j < 21; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 16; i < 18; i ++) {
        for(int j = 27; j < 29; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 27; i < 29; i ++) {
        for(int j = 3; j < 5; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 27; i < 29; i ++) {
        for(int j = 12; j < 14; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 22; i < 24; i ++) {
        for(int j = 15; j < 17; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 21; i < 23; i ++) {
        for(int j = 19; j < 21; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 29; i < 31; i ++) {
        for(int j = 19; j < 21; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
    for(int i = 23; i < 25; i ++) {
        for(int j = 26; j < 28; j++) {
            gameBoard[i][j].type = CellType.TREE;
        }
    }
}

void setSwamps(){
    gameBoard[9][2].type = CellType.SWAMP;
    gameBoard[9][2].value = 2;
    gameBoard[9][3].type = CellType.SWAMP;
    gameBoard[9][3].value = 2;
    for(int i = 1; i < 5; i++){
        gameBoard[10][i].type = CellType.SWAMP;
        gameBoard[10][i].value = 2;
    }
    for(int i = 2; i < 6; i++){
        gameBoard[11][i].type = CellType.SWAMP;
        gameBoard[11][i].value = 2;
    }
    for(int i = 2; i < 7; i++){
        gameBoard[12][i].type = CellType.SWAMP;
        gameBoard[12][i].value = 2;
    }
    for(int i = 1; i < 6; i++){
        gameBoard[13][i].type = CellType.SWAMP;
        gameBoard[13][i].value = 2;
    }
    for(int i = 2; i < 9; i++){
        gameBoard[14][i].type = CellType.SWAMP;
        gameBoard[14][i].value = 2;
    }
    for(int i = 3; i < 8; i++){
        gameBoard[15][i].type = CellType.SWAMP;
        gameBoard[15][i].value = 2;
    }

    for(int i = 14; i < 16; i++){
        gameBoard[16][i].type = CellType.SWAMP;
        gameBoard[16][i].value = 2;
    }
    for(int i = 13; i < 17; i++){
        gameBoard[17][i].type = CellType.SWAMP;
        gameBoard[17][i].value = 2;
    }
    for(int i = 13; i < 17; i++){
        gameBoard[18][i].type = CellType.SWAMP;
        gameBoard[18][i].value = 2;
    }
    for(int i = 14; i < 16; i++){
        gameBoard[19][i].type = CellType.SWAMP;
        gameBoard[19][i].value = 2;
    }

    for(int i = 25; i < 27; i++){
        gameBoard[3][i].type = CellType.SWAMP;
        gameBoard[3][i].value = 2;
    }
    for(int i = 24; i < 28; i++){
        gameBoard[4][i].type = CellType.SWAMP;
        gameBoard[4][i].value = 2;
    }
    for(int i = 24; i < 29; i++){
        gameBoard[5][i].type = CellType.SWAMP;
        gameBoard[5][i].value = 2;
    }
    for(int i = 23; i < 27; i++){
        gameBoard[6][i].type = CellType.SWAMP;
        gameBoard[6][i].value = 2;
    }
    for(int i = 23; i < 27; i++){
        gameBoard[7][i].type = CellType.SWAMP;
        gameBoard[7][i].value = 2;
    }
    for(int i = 20; i < 26; i++){
        gameBoard[8][i].type = CellType.SWAMP;
        gameBoard[8][i].value = 2;
    }
    for(int i = 19; i < 28; i++){
        gameBoard[9][i].type = CellType.SWAMP;
        gameBoard[9][i].value = 2;
    }
    for(int i = 20; i < 26; i++){
        gameBoard[10][i].type = CellType.SWAMP;
        gameBoard[10][i].value = 2;
    }
    for(int i = 21; i < 23; i++){
        gameBoard[11][i].type = CellType.SWAMP;
        gameBoard[11][i].value = 2;
    }
}

void setTrees(int number){
    trees = new Tree[number];
    for(int i = 0; i < number; i++){
        int x = int(random(1, 31));
        int y = int(random(1, 31));

        if(gameBoard[x][y].type == CellType.EMPTY
        && gameBoard[x-1][y].type == CellType.EMPTY
        && gameBoard[x][y-1].type == CellType.EMPTY
        && gameBoard[x-1][y-1].type == CellType.EMPTY){
            gameBoard[x][y].type = CellType.TREE;
            gameBoard[x-1][y].type = CellType.TREE;
            gameBoard[x][y-1].type = CellType.TREE;
            gameBoard[x-1][y-1].type = CellType.TREE;
            trees[i] = new Tree(x, y);
        }
    }

}

void setSwamps(int number){
    for(int i = 0; i < number; i++){
        int x = int(random(0, 31));
        int y = int(random(0, 31));
        if(gameBoard[x][y].type == CellType.EMPTY){
            gameBoard[x][y].type = CellType.SWAMP;
            gameBoard[x][y].value = 2;
        }
    }
}