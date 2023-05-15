/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

/*
 * This class is used to represent tanks for both NATO and the Warsaw Pact.
 * It contains the logic for drawing the tanks and moving them around the map.
 */

class Tank {
    // Coordinates of the tank on the game board
    int x, y;
    int xHome, yHome;

    // Real coordinates of the tank on the screen
    int xCoord, yCoord;

    // Rotation of the tank
    float rotation;

    // Team of the tank (PACT or NATO)
    Team team;
    int id;

    // Boolean for if the tank is controlled by the user or AI
    boolean userControl;

    // Constructor for the tank class
    Tank(int x, int y, int id, Team team) {
        this.x = x;
        this.y = y;
        this.xHome = x;
        this.yHome = y;
        this.team = team;
        this.id = id;

        xCoord = x * 25;
        yCoord = y * 25;

        if(this.team == redTeam) {
            rotation = 0;
        } else {
            rotation = 180;
        }
    }

    // Run every frame to update the tank's state
    void update() {

    }

    // Move the tank in a given direction
    void moveRight() {
        if(!checkCollision(this.x + 1, this.y)) {
            this.x += 1;
            this.xCoord = x * 25;
            this.rotation = 0;
        }
    }

    void moveLeft() {
        if(!checkCollision(this.x - 1, this.y)) {
            this.x -= 1;
            this.xCoord = x * 25;
            this.rotation = 180;
        }
    }

    void moveUp() {
        if(!checkCollision(this.x, this.y - 1)) {
            this.y -= 1;
            this.yCoord = y * 25;
            this.rotation = 270;
        }
    }

    void moveDown() {
        if(!checkCollision(this.x, this.y + 1)) {
            this.y += 1;
            this.yCoord = y * 25;
            this.rotation = 90;
        }
    }

    // Check if a given move will collide with a tree or another tank
    boolean checkCollision(int targetX, int targetY) {
        if(targetX < 0 || targetX > 31 || targetY < 0 || targetY > 31) {
            return true;
        }

        Node targetNode = gameBoard[targetX][targetY];
        if(targetNode.type == CellType.TREE) {
            return true;
        }

        for(Tank tank : tanks) {
            if(tank == null){
                continue;
            }
            if(tank.x == targetX && tank.y == targetY) {
                return true;
            }
        }

        return false;
    }

    // Draw the tank on the screen each frame
    void draw() {
        stroke(0);
        strokeWeight(2);
        if (team == redTeam) {
            fill(255, 0, 0);
        } else {
            fill(0, 0, 255);
        }

        ellipse(xCoord+25/2, yCoord+25/2, 25, 25);
        strokeWeight(3);
        line(xCoord + 25/2, yCoord + 25/2, xCoord + 25/2 + cos(radians(this.rotation)) * 25/2, yCoord + 25/2 + sin(radians(this.rotation)) * 25/2);
        textSize(25);
        fill(255);
        text(this.id, xCoord+25/2, yCoord+25/2);
    }
    
}