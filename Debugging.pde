Node currentlySelectedNode;

void drawDebugging(){
    textSize(24);
    text("Current Episode: " + qLearning.currentEpisode, gridSize * cellSize + 20, 50); 
    text("Current Iteration: " + qLearning.currentIteration, gridSize * cellSize + 20, 100);
    if(currentlySelectedNode != null) {
        text("Current Node: " + currentlySelectedNode.x + ", " + currentlySelectedNode.y, gridSize * cellSize + 20, 150);
        drawDebugNode();
    }
}

void drawDebugNode() {
    Node node = currentlySelectedNode;
    strokeWeight(1);
    if (node.type == CellType.TREE) {
        fill(treeColor, 50);
    } else if (node.type == CellType.NATO) {
        fill(natoColor, 80);
    } else if (node.type == CellType.PACT) {
        fill(pactColor, 90);
    } else if (node.type == CellType.SWAMP) {
        fill(swampColor, 50);
    } else if (node.type == CellType.EMPTY) {
        fill(exploredColor, 50);
    } else if (node.type == CellType.LANDMINE) {
        fill(landmineColor, 50);
    } else {
        fill(emptyColor, 50);
    }

    rect(1300, 300, 200, 200);
    textSize(16);
    fill(0);

    text(nf(node.weights[0], 3, 3), 1380, 315); // Up
    text(nf(node.weights[3], 3, 3), 1445, 405); // Right
    text(nf(node.weights[1], 3, 3), 1380, 490); // Down
    text(nf(node.weights[2], 3, 3), 1305, 405); // Left

}