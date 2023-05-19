/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 /*
  * This class is used to represent a node on the game board.
  * It contains information about the type of node, its position on the board and if it has been explored or visited.
  */

// Enum that represents the different types of nodes on the board.
enum CellType {
    TREE, NATO, PACT, TANK, SWAMP, EMPTY, LANDMINE, WATCHTOWER
}

class Node {

    // Enum that represents the different types of nodes on the board.
    CellType type;

    // The position of the node on the board.
    int x;
    int y;

    // Flags that represent if the node has been explored or visited.
    boolean explored = false;
    boolean visited = false;
    int visitCount = 0;

    // Flag that represents if the node can be used as a path.
    boolean obstacle = false;

    // The weight of entering the node.
    int value = 1;

    // Weights for leaving the node
    float[][] weights = new float[4][8];

    // Constructor
    Node(CellType type, int x, int y) {
        this.type = type;
        this.x = x;
        this.y = y;
        if(this.type == CellType.SWAMP){
            this.value = 2;
        }
    }

    // Constructor
    Node(int x, int y){
        this.x = x;
        this.y = y;
    }

    // Method that draws the node on the board.
    // Draws it in different colors depending on the type of node.
    // If the node has been explored or visited it will also have a circle drawn on it for debugging purposes.
    void draw(color _teamcolor) {
        strokeWeight(1);
        if (type == CellType.TREE) {
            fill(treeColor, 50);
        } else if (type == CellType.NATO) {
            fill(natoColor, 80);
        } else if (type == CellType.PACT) {
            fill(pactColor, 90);
        } else if (type == CellType.SWAMP) {
            fill(swampColor, 50);
        } else if (type == CellType.EMPTY) {
            fill(exploredColor, 50);
        } else if (type == CellType.LANDMINE) {
            fill(landmineColor, 50);
        } else if (type == CellType.WATCHTOWER) {
            fill(watchtowerColor, 50);
        } else {
            fill(emptyColor, 50);
        }
        rect(x * cellSize, y * cellSize, cellSize, cellSize);
        if(visited){
            fill(_teamcolor);
            ellipse(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
        }else if(explored){
            fill(0, 255 , 0, 120);
            ellipse(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
        }
        if(obstacle){
            fill(0, 0, 0, 120);
            ellipse(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
        }
        textSize(8);
        fill(0);
        //text(x + "," + y, x * cellSize, y * cellSize + 8);
        //text(nf(weights[0], 3, 3), x * cellSize + 10, y * cellSize + 10); // Up
        //text(nf(weights[3], 3, 3), x * cellSize + 20, y * cellSize + 20); // Right
        //text(nf(weights[1], 3, 3), x * cellSize + 10, y * cellSize + 40); // Down
        //text(nf(weights[2], 3, 3), x * cellSize + 2, y * cellSize + 20); // Left
    }
}
