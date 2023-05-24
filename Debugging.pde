Node currentlySelectedNode;

void drawDebugging(){
    textSize(20);
    text("Currently showing episode: " + (qLearning.currentlySimulatedEpisode + 1), gridSize * cellSize + 20, 50);
    text("Exploration rate this episode: " + (max(qLearning.min_exploration, 1 - qLearning.exploration_decay * (qLearning.currentlySimulatedEpisode + 1)) * 100) + "%", gridSize * cellSize + 20, 75);  
    text("Wins achieved this episode: " + (qLearning.winsPerEpisode[qLearning.currentlySimulatedEpisode]), gridSize * cellSize + 20, 100);
    text("Wins achieved over " + qLearning.currentEpisode + " episodes: ", gridSize * cellSize + 20, 125);
    text(qLearning.winsAchieved, gridSize * cellSize + 20, 150);
    text("Watchtowers visited: " + wtVisited, gridSize * cellSize + 20, height - 100);
    text("Actions taken: " + qLearning.currentlySimulatedAction, gridSize * cellSize + 20, height - 120);
    //text("Nodes visited: " + qLearning.nodesVisited, gridSize * cellSize + 20, height - 80);
    if(currentlySelectedNode != null) {
        text("Current Node: " + currentlySelectedNode.x + ", " + currentlySelectedNode.y, gridSize * cellSize + 20, 200);
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
    int y = 225;
    int w = 60;
    int h = 60;
    rect(x, y, w, h);               // 0
    rect(x + 70, y, w, h);          // 1
    rect(x + 140, y, w, h);         // 2
    rect(x + 210, y, w, h);         // 3
    rect(x, y + 70, w, h);          // 4
    rect(x + 70, y + 70, w, h);     // 5
    rect(x + 140, y + 70, w, h);    // 6
    rect(x + 210, y + 70, w, h);    // 7
    textSize(w/8);
    fill(0);

    
    // 0
    text(nf(node.weights[0][0], 3, 3), x + w * 0.33, y + h * 0.1); // Up
    text(nf(node.weights[3][0], 3, 3), x + w * 0.575, y + h * 0.525); // Right
    text(nf(node.weights[1][0], 3, 3), x + w * 0.33, y + h * 0.95); // Down
    text(nf(node.weights[2][0], 3, 3), x + w * 0.025, y + h * 0.525); // Left

    // 1
    text(nf(node.weights[0][1], 3, 3), x + 70 + w * 0.33, y + h * 0.1); // Up
    text(nf(node.weights[3][1], 3, 3), x + 70 + w * 0.575, y + h * 0.525); // Right
    text(nf(node.weights[1][1], 3, 3), x + 70 + w * 0.33, y + h * 0.95); // Down
    text(nf(node.weights[2][1], 3, 3), x + 70 + w * 0.025, y + h * 0.525); // Left

    // 2
    text(nf(node.weights[0][2], 3, 3), x + 140 + w * 0.33, y + h * 0.1); // Up
    text(nf(node.weights[3][2], 3, 3), x + 140 + w * 0.575, y + h * 0.525); // Right
    text(nf(node.weights[1][2], 3, 3), x + 140 + w * 0.33, y + h * 0.95); // Down
    text(nf(node.weights[2][2], 3, 3), x + 140 + w * 0.025, y + h * 0.525); // Left

    // 3
    text(nf(node.weights[0][3], 3, 3), x + 210 + w * 0.33, y + h * 0.1); // Up
    text(nf(node.weights[3][3], 3, 3), x + 210 + w * 0.575, y + h * 0.525); // Right
    text(nf(node.weights[1][3], 3, 3), x + 210 + w * 0.33, y + h * 0.95); // Down
    text(nf(node.weights[2][3], 3, 3), x + 210 + w * 0.025, y + h * 0.525); // Left

    // 4
    text(nf(node.weights[0][4], 3, 3), x + w * 0.33, y + 70 + h * 0.1); // Up
    text(nf(node.weights[3][4], 3, 3), x + w * 0.575, y + 70 + h * 0.525); // Right
    text(nf(node.weights[1][4], 3, 3), x + w * 0.33, y + 70 + h * 0.95); // Down
    text(nf(node.weights[2][4], 3, 3), x + w * 0.025, y + 70 + h * 0.525); // Left

    // 5
    text(nf(node.weights[0][5], 3, 3), x + 70 + w * 0.33, y + 70 + h * 0.1); // Up
    text(nf(node.weights[3][5], 3, 3), x + 70 + w * 0.575, y + 70 + h * 0.525); // Right
    text(nf(node.weights[1][5], 3, 3), x + 70 + w * 0.33, y + 70 + h * 0.95); // Down
    text(nf(node.weights[2][5], 3, 3), x + 70 + w * 0.025, y + 70 + h * 0.525); // Left

    // 6
    text(nf(node.weights[0][6], 3, 3), x + 140 + w * 0.33, y + 70 + h * 0.1); // Up
    text(nf(node.weights[3][6], 3, 3), x + 140 + w * 0.575, y + 70 + h * 0.525); // Right
    text(nf(node.weights[1][6], 3, 3), x + 140 + w * 0.33, y + 70 + h * 0.95); // Down
    text(nf(node.weights[2][6], 3, 3), x + 140 + w * 0.025, y + 70 + h * 0.525); // Left

    // 7
    text(nf(node.weights[0][7], 3, 3), x + 210 + w * 0.33, y + 70 + h * 0.1); // Up
    text(nf(node.weights[3][7], 3, 3), x + 210 + w * 0.575, y + 70 + h * 0.525); // Right
    text(nf(node.weights[1][7], 3, 3), x + 210 + w * 0.33, y + 70 + h * 0.95); // Down
    text(nf(node.weights[2][7], 3, 3), x + 210 + w * 0.025, y + 70 + h * 0.525); // Left

}