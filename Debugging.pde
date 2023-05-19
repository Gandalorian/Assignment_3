Node currentlySelectedNode;

void drawDebugging(){
    textSize(20);
    text("Currently showing episode: " + (qLearning.currentlySimulatedEpisode + 1), gridSize * cellSize + 20, 50); 
    text("Wins achieved: " + qLearning.winsAchieved, gridSize * cellSize + 20, 75);
    //text("Current Iteration: " + qLearning.currentIteration, gridSize * cellSize + 20, 100);
    text("Watchtowers visited: " + wtVisited, gridSize * cellSize + 20, height - 100);
    text("Actions taken: " + qLearning.currentlySimulatedAction, gridSize * cellSize + 20, height - 120);
    //text("Nodes visited: " + qLearning.nodesVisited, gridSize * cellSize + 20, height - 80);
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
    } else if (node.type == CellType.WATCHTOWER) {
            fill(watchtowerColor, 50);
    } else {
        fill(emptyColor, 50);
    }

    int x = width - 300;
    int y = 200;
    int w = 200;
    int h = 200;
    rect(x, y, w, h);
    textSize(16);
    fill(0);

    text(nf(node.weights[0][qLearning.visitedTowersPermutation], 3, 3), x + 80, y + 15); // Up
    text(nf(node.weights[3][qLearning.visitedTowersPermutation], 3, 3), x + 145, y + 105); // Right
    text(nf(node.weights[1][qLearning.visitedTowersPermutation], 3, 3), x + 80, y + 190); // Down
    text(nf(node.weights[2][qLearning.visitedTowersPermutation], 3, 3), x + 5, y + 105); // Left

}