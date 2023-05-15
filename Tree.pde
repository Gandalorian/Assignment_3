/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 /*
  * This class represents a tree in the game.
 */

class Tree {

    // Coordinate of the tree on the game board
    int x, y;

    // Actual coordinate of the tree on the screen
    int xCoord, yCoord;
    
    // Constructor
    Tree(int x, int y) {
        this.x = x;
        this.y = y;

        xCoord = x * 25;
        yCoord = y * 25;
    }

    // Draws the tree on the screen
    void draw() {
        fill(treeColor, 50);
        ellipse(xCoord, yCoord, 110, 110);
        fill(color(139, 69, 19));
        ellipse(xCoord, yCoord, 50, 50);
    }
}