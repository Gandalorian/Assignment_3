/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 /*
 * This is the main class for the game. It contains the main method and the setup method.
 * The setup method is called once at the beginning of the game. The main method is called
 * every frame.
 */

int gridSize = 16;
Node gameBoard[][] = new Node[gridSize][gridSize];

color treeColor = color(0, 128, 0);
color natoColor = color(0, 0, 255, 120);
color pactColor = color(255, 0, 0, 120);
color exploredColor = color(128, 128, 128);
color emptyColor = color(0,0,0);

Team redTeam;
Team blueTeam;

int[] redHomebase = {0,0,2,5};
int[] blueHomebase = {13,9,15,15};

Tree tree1;
Tree tree2;
Tree tree3;

Tree[] trees = new Tree[3];

Tank[] tanks = new Tank[6];

Timer timer;

void setup() {
    size(800, 800);
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j] = new Node(CellType.EMPTY, i, j);
        }
    }

    timer = new Timer();

    redTeam = new RedTeam(pactColor, redHomebase);
    blueTeam = new BlueTeam(natoColor, blueHomebase);

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

void draw() {
    timer.tick();

    background(255);

    drawGrid();
    
    redTeam.updateLogic();
    blueTeam.updateLogic();
    
    for(Tank tank : tanks) {
        if(tank == null){
            continue;
        }
        tank.draw();
    }

    tree1.draw();
    tree2.draw();
    tree3.draw();

    blueTeam.teamLogic.knownWorld.draw();
}

void drawGrid() {
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j].draw(color(0,0,0));
        }
    }
}

/*
    TODO:

*/
