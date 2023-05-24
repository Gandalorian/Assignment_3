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

// The size of the game board is 16x16
int gridSize = 16;
Node[][] gameBoard = new Node[gridSize][gridSize];

// The size of cells in pixels
int cellSize = 40;

// Defines all colors on the game board
color treeColor = color(0, 128, 0); // Green
color natoColor = color(0, 0, 255, 120); // Blue
color pactColor = color(255, 0, 0, 120); // Red
color swampColor = color(139, 69, 19); // Brown
color exploredColor = color(128, 128, 128); // Gray
color emptyColor = color(0,0,0); // White
color landmineColor = color(255, 255, 0); // Yellow
color watchtowerColor = color(0, 249, 159); // Light green

// References to the two Team classes
Team redTeam;
Team blueTeam;

// The coordinates of the home bases
int[] redHomebase16 = {0,0,2,5};
int[] blueHomebase16 = {13,9,15,15};

// The coordinates of the watchtowers
int[] watchtowers = {4,7,14,5,7,11};

// Amount of watchtowers visited (0-3, used for debugging)
int wtVisited;

// Data structures for trees and tanks
Tree[] trees;
Tank[] tanks = new Tank[6];

// Reference to the tank with an AI
Tank activeTank;

// Used for timing and debugging
Timer timer;
int timeBetweenMoves = 0;
boolean done;

// Reference to the QLearning class which holds all AI logic
QLearning qLearning;

void setup() {
    //Size of the game window
    size(960, 640);

    // Arbitrarily high value to make the game run as fast as possible
    frameRate(300);

    // Initialize the game board
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j] = new Node(CellType.EMPTY, i, j);
        }
    }

    // Starts the timer
    timer = new Timer();

    // Initializes the team classes
    redTeam = new Team(pactColor, redHomebase16);
    blueTeam = new Team(natoColor, blueHomebase16);

    // Assigns the tanks to the teams
    tanks[0] = redTeam.tanks[0];
    tanks[1] = redTeam.tanks[1];
    tanks[2] = redTeam.tanks[2];
    tanks[3] = blueTeam.tanks[0];
    tanks[4] = blueTeam.tanks[1];
    tanks[5] = blueTeam.tanks[2];

    // Defines tank with AI
    activeTank = tanks[0];
    tanks[0].userControl = true;

    // Sets current amount of watchtowers visited to 0 at the start of the game
    wtVisited = 0;
    done = false;

    // Fills the game board with contents
    setGameBoard16();

    // Initializes the QLearning class
    // The parameters are: episodes, steps, learning rate, tank with AI
    qLearning = new QLearning(1000, 100, 0.1, tanks[0]);
     
}

void draw() {
    // Updates the timer
    timer.tick();

    // Sets the background color to white
    background(255);

    // Draws the game board
    drawGrid();
    
    // Updates the logic for the teams
    redTeam.updateLogic();
    blueTeam.updateLogic();
    
    // Draws the trees
    for(Tree tree : trees){
        if(tree == null){
            continue;
        }
        tree.draw();
    }

    // Calculates the next episode if the current episode is not the last one
    if(qLearning.currentEpisode <= qLearning.episodes){
        qLearning.calculateNextEpisode();
    }else{
        if(!done){
            // If the last episode is calculated, print the results
            println("1000 episodes calculated. Time taken: " + nf(float(timer.getElapsedTime()) / 1000, 3, 3) + " seconds");
            int id = 0;
            int mostwins = 0;
            for(int i = 0; i < qLearning.winsPerEpisode.length; i++){
                if(qLearning.winsPerEpisode[i] > mostwins){
                    mostwins = qLearning.winsPerEpisode[id];
                    id = i;
                }
            }
            println(qLearning.winsAchieved + " wins achieved. Most wins on episode " + id + " with " + mostwins + " wins");
            done = true;
        }
    }

    // Draws debugging information on the screen
    drawDebugging();

    // Draws the episode on the screen for debugging
    qLearning.simulateCurrentEpisode();
}

// Draws the grid pattern on the screen
void drawGrid() {
    for(int i = 0; i < gridSize; i++) {
        for(int j = 0; j < gridSize; j++) {
            gameBoard[i][j].draw(color(0,0,0));
        }
    }
}
