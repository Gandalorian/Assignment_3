/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    float[][] QTable;

    Tank tank;
    int tankPreviousx;
    int tankPreviousy;

    int currentEpisode = 1;
    int episodes;
    int currentIteration = 1;
    int max_iterations;

    int actionsTaken = 0;
    int nodesVisited = 0;
    int winsAchieved = 0;
    
    final int ACTIONSPACE = 4;

    float exploration_probability = 1;
    float exploration_decay = 0.025;
    float min_exploration = 0.01;
    float discounted_factor = 0.99;
    float learning_rate;

    QLearning(int _episodes, int _maxIter, float _learningRate, Tank _tank){
        QTable = new float[gridSize * gridSize][4];
        for(int i = 0; i < gridSize * gridSize; i++){
            for(int j = 0; j < 4; j++){
                QTable[i][j] = 0.0;
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

        int action = chooseAction(tank.x, tank.y);

        int[] newState = applyAction(tank.x, tank.y, action);
        actionsTaken++;
        nodesVisited = updateVisited();
        checkVisitedTowers();
        float reward = determineReward(newState[0], newState[1]);

        updateQValue(tankPreviousx, tankPreviousy, action, reward, newState[0], newState[1]);

        if(gameBoard[tank.x][tank.y].type == CellType.LANDMINE 
        || wtVisited == 3
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
    int chooseAction(int x, int y) {
        if (Math.random() < exploration_probability) {
            return int(random(ACTIONSPACE));
        } else {
            float maxQ = -Float.MAX_VALUE;
            int bestAction = 0;

            for(int i = 0; i < ACTIONSPACE; i++) {
                if(QTable[x * gridSize + y][i] > maxQ) {
                    maxQ = QTable[x * gridSize + y][i];
                    bestAction = i;
                }
            }
            return bestAction;
        }
    }

    // Applies the action to the tank and returns the new position.
    int[] applyAction(int x, int y, int action) {
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
        return new int[]{tank.x, tank.y};
    }

    float determineReward(int x, int y) {
        float reward = 0;

        switch(gameBoard[x][y].type) {
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
                if(wtVisited == 3){
                    reward = 1000f;
                }else{
                    reward = 5f;
                }
                break;
        }

        reward = reward * nodesVisited / actionsTaken;

        return reward;
    }

    void updateQValue(int x, int y, int action, float reward, int newX, int newY) {
        QTable[x * gridSize + y][action] = QTable[x * gridSize + y][action] + learning_rate * (reward + discounted_factor * maxArr(QTable[newX * gridSize + newY]) - QTable[x * gridSize + y][action]);
        updateNodeValues();
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

    void updateNodeValues() {
        for(int i = 0; i < QTable.length; i++) {
            int x = i / gridSize;
            int y = i % gridSize;

            for(int j = 0; j < 4; j++) {
                gameBoard[x][y].weights[j] = QTable[i][j];
            }
        }
    }

 }