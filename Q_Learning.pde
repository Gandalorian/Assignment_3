/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    float[][] QTable;

    Tank tank;

    int currentEpisode = 0;
    int episodes;
    int currentIteration = 0;
    int max_iterations;
    final int ACTIONSPACE = 4;
    float exploration_probability = 1;
    float exploration_decay = 0.001;
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
        int action = chooseAction(tank.x, tank.y);

        int[] newState = applyAction(tank.x, tank.y, action);
        float reward = determineReward(newState[0], newState[1]);

        updateQValue(tank.x, tank.y, action, reward, newState[0], newState[1]);

        if(gameBoard[tank.x][tank.y].type == CellType.LANDMINE || allNodesVisited()) {
            resetBoard();
            currentEpisode++;

            if(currentEpisode > episodes) {
                System.out.println("Done training!");
                noLoop();
            } 
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
                tank.moveUp();
                break;
            case 1: // Down
                tank.moveDown();
                break;
            case 2: // Left
                tank.moveLeft();
                break;
            case 3: // Right
                tank.moveRight();
                break;
        }
        return new int[]{tank.x, tank.y};
    }

    float determineReward(int x, int y) {
        float reward = 0;

        switch(gameBoard[x][y].type) {
            case EMPTY: // Regular node
                if(gameBoard[x][y].visitCount > 1) {
                    reward = 0.0f;
                } else {
                    reward = 1.0f;
                }
                break;
            case SWAMP: // Swamp
                if(gameBoard[x][y].visited) {
                    reward = -0.5f;
                } else {
                    reward = 0.5f;
                }
                break;
            case LANDMINE: // Landmine
                reward = -10f;
                break;
        }
        return reward;
    }

    void updateQValue(int x, int y, int action, float reward, int newX, int newY) {
        QTable[x * gridSize + y][action] = QTable[x * gridSize + y][action] + learning_rate * (reward + discounted_factor * maxArr(QTable[newX * gridSize + newY]) - QTable[x * gridSize + y][action]);
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