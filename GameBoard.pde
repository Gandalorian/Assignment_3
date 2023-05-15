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

    tree1 = new Tree(5, 12);
    tree2 = new Tree(6, 5);
    tree3 = new Tree(11, 10);

    trees[0] = tree1;
    trees[1] = tree2;
    trees[2] = tree3;

    setGameBoard();
}

void setGameBoard() {
    setHomeBases();
    setSwamps(int(random(128,192)));
    setTrees(int(random(5, 15)));
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