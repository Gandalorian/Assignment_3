/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    float[][][] QTable;

    Tank[] simulationTanks;
    Tank calculationTank;
    int tankPreviousx;
    int tankPreviousy;

    int currentEpisode = 1;
    int episodes;
    int currentIteration = 1;
    int max_iterations;

    ArrayList<Integer>[][] simulatedEpisodes;
    ArrayList<Integer>[] iterations;
    ArrayList<Integer> iterationActions;
    int[] maxActionsPerEpisode;
    int[] longestIterationPerEpisode;
    int[] winsPerEpisode;
    int currentlySimulatedEpisode = 0;
    int currentlySimulatedAction = 0; 

    int actionsTaken = 0;
    int nodesVisited = 0;
    int previousTowerPermutation = 0;
    int visitedTowersPermutation = 0;
    int winsAchieved = 0;
    
    final int ACTIONSPACE = 4;

    float exploration_probability = 1;
    float exploration_decay = 0.005;
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
        
        simulationTanks = new Tank[max_iterations];
        calculationTank = _tank;
        maxActionsPerEpisode = new int[episodes];
        longestIterationPerEpisode = new int[episodes];
        winsPerEpisode = new int[episodes];
        iterations = new ArrayList[max_iterations];
        iterationActions = new ArrayList<>();

        for(int i = 0; i < max_iterations; i++){
            simulationTanks[i] = new Tank(_tank.x,_tank.y, i, _tank.team);
        }

        for(int i = 0; i < episodes; i++){
            maxActionsPerEpisode[i] = 0;
            winsPerEpisode[i] = 0;
        }

        simulatedEpisodes = new ArrayList[episodes][max_iterations];
    }
    /*
    void draw() {
        while(currentEpisode < episodes){
            println("New Episode: " + currentEpisode);
            exploration_probability = max(min_exploration, 1 - exploration_decay * currentEpisode);

            currentIteration = 1;
            
            ArrayList<Integer>[] iterations = new ArrayList[max_iterations];
            ArrayList<Integer> iterationActions = new ArrayList<>();

            int maxActions = 0;
            
            while(currentIteration < max_iterations){
                println("New Iteration: " + currentIteration + ". --- Exploration probability: " + exploration_probability);

                int[] tankPos = new int[]{tank.x, tank.y};

                while(simulateIteration(iterations, iterationActions, tankPos, maxActions)){
                    tankPos = new int[]{tank.x, tank.y};
                }
            }

            println("Max actions taken this episode: " + maxActions);

            simulateEpisode(iterations, maxActions);
            currentEpisode++;
        }
    }*/

    boolean simulateIteration(int[] tankPos){
        //println("Simulate iteration " + currentIteration);
        int action = chooseAction(tankPos);
        int[] newState = applyAction(action, calculationTank);
        float reward = determineReward(newState);

        updateQValue(tankPos, action, reward, newState);
        
        if(endIterationCheck(tankPos)){
            int maxActions = resetIteration();
            if(maxActions > maxActionsPerEpisode[currentEpisode - 1]){
                maxActionsPerEpisode[currentEpisode - 1] = maxActions;
                longestIterationPerEpisode[currentEpisode - 1] = currentIteration;
            }
            return false;
        }
        return true;
    }

    boolean endIterationCheck(int[] tankPos){
        //println("Checking for end");
        if(gameBoard[tankPos[0]][tankPos[1]].type == CellType.LANDMINE){
            return true;
        }
        if(allNodesVisited()){
            winsPerEpisode[currentEpisode - 1]++;
            return true;
        }
        if(visitedTowersPermutation == 7){
            winsPerEpisode[currentEpisode - 1]++;
            return true;
        }
        if(actionsTaken >= 1000){
            return true;
        }
        return false;
    }

    int resetIteration(){
        int maxActions = actionsTaken;
        println("Iteration over.");
        println("Actions taken: " + actionsTaken);
        println("Watchtowers visited: " + wtVisited);
        iterations[currentIteration - 1] = iterationActions;
        actionsTaken = 0;
        nodesVisited = 0;
        currentIteration++;
        resetBoard();
        println(" * * * * * ");
        return maxActions;
    }

    // Chooses the next action to be performed based on the Q-table.
    // The action can be random or the action with the highest Q-value.
    int chooseAction(int[] tankPosition) {
        //println("Choosing action");
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
    int[] applyAction(int action, Tank tank) {
        //println("Applying action");
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

        actionsTaken++;

        iterationActions.add(action);

        return new int[]{tank.x, tank.y};
    }

    float determineReward(int[] pos) {
        //println("Determining reward");
        float reward = 0;
        Node nodeToReward = gameBoard[pos[0]][pos[1]];
        
        switch(nodeToReward.type) {
            case EMPTY: // Regular node
                if(nodeToReward.visitCount < 2){
                    reward = 1.0f;
                }
                break;
            case SWAMP: // Swamp
                if(nodeToReward.visitCount < 2){
                    reward = 0.5f;
                }
                //reward = -1f;
                break;
            case LANDMINE: // Landmine
                reward = -100f;
                break;
            case WATCHTOWER: // Watchtower
                if(nodeToReward.visitCount < 2){
                    reward = 1000f;
                }
                break;
        }

        reward = reward * nodesVisited / actionsTaken;

        return reward;
    }

    void updateQValue(int[] prevPos, int action, float reward, int[] newPos) {
        //println("Update Q Value");
        float newQvalue = 0f;
        float oldQValue = QTable[prevPos[0] * gridSize + prevPos[1]][previousTowerPermutation][action];
        float bestEstimate = maxArr(QTable[newPos[0] * gridSize + newPos[1]][visitedTowersPermutation]);
        newQvalue = (1 - learning_rate) * oldQValue + learning_rate * (reward + discounted_factor * bestEstimate);
        QTable[prevPos[0] * gridSize + prevPos[1]][previousTowerPermutation][action] = newQvalue;
        
        gameBoard[prevPos[0]][prevPos[1]].weights[action][previousTowerPermutation] = newQvalue;
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

    void calculateNextEpisode(){
        println("New Episode: " + currentEpisode);
        exploration_probability = max(min_exploration, 1 - exploration_decay * (currentEpisode - 1));

        currentIteration = 1;
        iterations = new ArrayList[max_iterations];
            
        while(currentIteration <= max_iterations){
            iterationActions = new ArrayList<>();
            println("New Iteration: " + currentIteration + ". Episode " + currentEpisode + "--- Exploration probability: " + exploration_probability);

            int[] tankPos = new int[]{calculationTank.x, calculationTank.y};

            while(simulateIteration(tankPos)){
                tankPos = new int[]{calculationTank.x, calculationTank.y};
            }
        }

        simulatedEpisodes[currentEpisode - 1] = iterations;

        println("Max actions taken this episode: " + maxActionsPerEpisode[currentEpisode - 1] + ", taken during iteration " + longestIterationPerEpisode[currentEpisode - 1]);
        currentEpisode++;
    }

    void simulateCurrentEpisode(){
        
        if(currentlySimulatedAction > maxActionsPerEpisode[currentlySimulatedEpisode]){
            currentlySimulatedEpisode += 3;
            currentlySimulatedAction = 0;
            resetSimulation();
            println("Simulating episode " + (currentlySimulatedEpisode + 1));
        }

        for(Tank t : simulationTanks){
            t.draw();
        }
        
        for(int i = 0; i < max_iterations; i++){
            if(timeBetweenMoves > timer.getElapsedTime()){
                return;
            }
            if(simulatedEpisodes[currentlySimulatedEpisode][i].size() > 0){
                switch(simulatedEpisodes[currentlySimulatedEpisode][i].get(0)){
                    case 0: // Up
                        simulationTanks[i].moveUp();
                        break;
                    case 1: // Down
                        simulationTanks[i].moveDown();
                        break;
                    case 2: // Left
                        simulationTanks[i].moveLeft();
                        break;
                    case 3: // Right
                        simulationTanks[i].moveRight();
                        break;
                }
                simulatedEpisodes[currentlySimulatedEpisode][i].remove(0);
            }
        }
        currentlySimulatedAction++;
        timeBetweenMoves = timer.setNewTimer(1);
    }

    void resetSimulation(){
        for(int i = 0; i < max_iterations; i++){
            simulationTanks[i].x = simulationTanks[i].team.homebase[0] + 1;
            simulationTanks[i].y = simulationTanks[i].team.homebase[1] + 1;
        }
    }
}
