/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    float[][][] QTable;

    Tank tank;
    int tankPreviousx;
    int tankPreviousy;

    int currentEpisode = 1;
    int episodes;
    int currentIteration = 1;
    int max_iterations;

    int actionsTaken = 0;
    int nodesVisited = 0;
    int previousTowerPermutation = 0;
    int visitedTowersPermutation = 0;
    int winsAchieved = 0;
    
    final int ACTIONSPACE = 4;

    float exploration_probability = 1;
    float exploration_decay = 0.025;
    float min_exploration = 0.01;
    float discounted_factor = 0.99;
    float learning_rate;

    QLearning(int _episodes, int _maxIter, float _learningRate, Tank _tank){
        QTable = new float[gridSize * gridSize][8][ACTIONSPACE];
        for(int i = 0; i < gridSize * gridSize; i++){
            for(int j = 0; j < 8; j++){
                for(int k = 0; k < ACTIONSPACE; k++){
                    QTable[i][j][k] = 0.0;
                }    
            }
        }

        episodes = _episodes;
        max_iterations = _maxIter;
        learning_rate = _learningRate;
        tank = _tank;
    }

    void draw() {
        if(currentIteration > max_iterations) {
            resetBoard();
            currentEpisode++;
            if(currentEpisode > episodes) {
                System.out.println("Done training!");
                noLoop();
                return;
            }
            exploration_probability = max(min_exploration, 1 - (exploration_decay * currentEpisode) * (exploration_decay * currentEpisode));
            currentIteration = 0;
            System.out.println("New Episode: " + currentEpisode + " Exploration: " + exploration_probability);
        }

        int[] tankPos = new int[]{tank.x, tank.y};

        int action = chooseAction(tankPos);
        int[] newState = applyAction(action);
        actionsTaken++;
        float reward = determineReward(newState);

        updateQValue(tankPos, action, reward, newState);

        if(gameBoard[tank.x][tank.y].type == CellType.LANDMINE 
        || visitedTowersPermutation == 7
        || actionsTaken > 1000) {
            println("Iteration over.");
            println("Actions taken: " + actionsTaken);
            println("Watchtowers visited: " + wtVisited);
            resetBoard();
            actionsTaken = 0;
            currentIteration++;
            println(" * * * * * ");
            println("New Iteration: " + currentIteration);
            println("Exploration probability: " + exploration_probability);
        }
    }

    // Chooses the next action to be performed based on the Q-table.
    // The action can be random or the action with the highest Q-value.
    int chooseAction(int[] tankPosition) {
        if (Math.random() < exploration_probability) {
            return int(random(ACTIONSPACE));
        } else {
            float maxQ = -Float.MAX_VALUE;
            int bestAction = 0;

            for(int i = 0; i < ACTIONSPACE; i++) {
                if(QTable[tankPosition[0] * gridSize + tankPosition[1]][visitedTowersPermutation][i] > maxQ) {
                    maxQ = QTable[tankPosition[0] * gridSize + tankPosition[1]][visitedTowersPermutation][i];
                    bestAction = i;
                }
            }
            return bestAction;
        }
    }

    // Applies the action to the tank and returns the new position.
    int[] applyAction(int action) {
        switch(action) {
            case 0: // Up
                tankPreviousx = tank.x;
                tankPreviousy = tank.y;
                tank.moveUp();
                break;
            case 1: // Down
                tankPreviousx = tank.x;
                tankPreviousy = tank.y;
                tank.moveDown();
                break;
            case 2: // Left
                tankPreviousx = tank.x;
                tankPreviousy = tank.y;
                tank.moveLeft();
                break;
            case 3: // Right
                tankPreviousx = tank.x;
                tankPreviousy = tank.y;
                tank.moveRight();
                break;
        }

        Node activeNode = gameBoard[tank.x][tank.y];

        if(!activeNode.visited){
            nodesVisited++;
            activeNode.visited = true;
        }
        activeNode.visitCount++;

        visitedTowersPermutation = checkVisitedTowers();

        return new int[]{tank.x, tank.y};
    }

    float determineReward(int[] pos) {
        float reward = 0;
        Node nodeToReward = gameBoard[pos[0]][pos[1]];

        switch(gameBoard[pos[0]][pos[1]].type) {
            case EMPTY: // Regular node
                reward = 1.0f;
                break;
            case SWAMP: // Swamp
                reward = 0.5f;
                //reward = -1f;
                break;
            case LANDMINE: // Landmine
                reward = -10f;
                break;
            case WATCHTOWER: // Watchtower
                /*
                if(gameBoard[x][y].visitCount == 1) {
                    reward = 1000f * pow(10, wtVisited);
                } else {
                    reward = 1.0f;
                }*/
                if(!nodeToReward.visited){
                    reward = 1000f;
                }else{
                    reward = 5f;
                }
                break;
        }

        reward = reward * nodesVisited / actionsTaken;

        return reward;
    }

    void updateQValue(int[] prevPos, int action, float reward, int[] newPos) {
        float newQvalue = 0f;
        float oldQValue = QTable[prevPos[0] * gridSize + prevPos[1]][previousTowerPermutation][action];
        newQvalue = learning_rate * (reward + discounted_factor * maxArr(QTable[newPos[0] * gridSize + newPos[1]][visitedTowersPermutation]) - oldQValue);
        QTable[prevPos[0] * gridSize + prevPos[1]][previousTowerPermutation][action] = oldQValue + newQvalue;
        
        gameBoard[prevPos[0]][prevPos[1]].weights[action] = oldQValue + newQvalue;
        previousTowerPermutation = visitedTowersPermutation;
    }

    float maxArr(float[] arr) {
        float max = -Float.MAX_VALUE;
        for(int i = 0; i < arr.length; i++) {
            if(arr[i] > max) {
                max = arr[i];
            }
        }
        return max;
    }

 }