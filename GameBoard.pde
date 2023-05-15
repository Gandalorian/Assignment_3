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

void resetBoard() {
    activeTank.x = activeTank.team.homebase[0] + 1;
    activeTank.y = activeTank.team.homebase[1] + 1;

    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j].visited = false;
            gameBoard[i][j].visitCount = 0;
        }
    }
}

void updateVisited() {
    Node activeNode = gameBoard[activeTank.x][activeTank.y];

    if(!activeNode.visited) {
        activeNode.visited = true;
    }
    activeNode.visitCount++;
}

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

void setGameBoard() {
    setHomeBases();
    setTrees();
    setSwamps();
    setLandmines();
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

void setLandmines() {
    
    // Minefield (7, 6), (7,7), (6,7)
    gameBoard[7][6].type = CellType.LANDMINE;
    gameBoard[7][7].type = CellType.LANDMINE;
    gameBoard[6][7].type = CellType.LANDMINE;

    // Minefield (21, 6), (22, 6), (23, 6), (21, 7), (22, 7)
    gameBoard[21][6].type = CellType.LANDMINE;
    gameBoard[22][6].type = CellType.LANDMINE;
    gameBoard[23][6].type = CellType.LANDMINE;
    gameBoard[21][7].type = CellType.LANDMINE;
    gameBoard[22][7].type = CellType.LANDMINE;

    // Minefield (7, 14), (8, 14), (8, 15), (9, 15)
    gameBoard[7][14].type = CellType.LANDMINE;
    gameBoard[8][14].type = CellType.LANDMINE;
    gameBoard[8][15].type = CellType.LANDMINE;
    gameBoard[9][15].type = CellType.LANDMINE;

    // Minefield (1, 17), (2, 17), (3, 17), (1, 18), (2, 18), (3, 18)
    gameBoard[1][17].type = CellType.LANDMINE;
    gameBoard[2][17].type = CellType.LANDMINE;
    gameBoard[3][17].type = CellType.LANDMINE;
    gameBoard[1][18].type = CellType.LANDMINE;

    // Minefield (13, 12), (13, 13), (14, 12), (14, 13)
    gameBoard[13][12].type = CellType.LANDMINE;
    gameBoard[13][13].type = CellType.LANDMINE;
    gameBoard[14][12].type = CellType.LANDMINE;
    gameBoard[14][13].type = CellType.LANDMINE;

    // Minefield (17, 18), (17, 19), (18, 19), (17, 20), (18, 20), (19, 20)
    gameBoard[17][8].type = CellType.LANDMINE;
    gameBoard[17][9].type = CellType.LANDMINE;
    gameBoard[18][9].type = CellType.LANDMINE;
    gameBoard[17][10].type = CellType.LANDMINE;
    gameBoard[18][10].type = CellType.LANDMINE;
    gameBoard[19][10].type = CellType.LANDMINE;

    // Minefield (19, 28), (19, 29), (19, 30), (19, 31), (18, 31)
    gameBoard[19][28].type = CellType.LANDMINE;
    gameBoard[19][29].type = CellType.LANDMINE;
    gameBoard[19][30].type = CellType.LANDMINE;
    gameBoard[19][31].type = CellType.LANDMINE;
    gameBoard[18][31].type = CellType.LANDMINE;

    // Minefield (11, 27), (11, 28), (10, 28), (10, 29)
    gameBoard[11][27].type = CellType.LANDMINE;
    gameBoard[11][28].type = CellType.LANDMINE;
    gameBoard[10][28].type = CellType.LANDMINE;
    gameBoard[10][29].type = CellType.LANDMINE;

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