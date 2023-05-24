/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    // Array that stores the values for each node
    // The 3 dimensions are 
    // [nodes(256 in total)]
    // [permutations of visited watchtowers (8 in total)]
    // [actionspace (4 in total)]
    float[][][] QTable;

    // Array that stores the tanks used in the simulation
    // of an entire episode
    Tank[] simulationTanks;

    // Tank used in the calculations, only one is needed
    // as the iterations are calculated one by one
    Tank calculationTank;

    // Variables holding the current and max of both
    // episodes and iterations
    int currentEpisode = 1;
    int episodes;
    int currentIteration = 1;
    int max_iterations;

    // Array of Array of ArrayList of Integers
    // Basically every move that the tank makes
    // in an iteration gets stored as an integer,
    // 0 is up, 1 is down, 2 is left, and 3 is right,
    // in an ArrayList that keeps track of the order
    // of the moves made and then every iteration 
    // gets stored in an array, which then represents
    // the entire episode, and this array gets stored
    // in another array that represents all the episodes
    ArrayList<Integer>[][] simulatedEpisodes;
    ArrayList<Integer>[] iterations;
    ArrayList<Integer> iterationActions;

    // Values used to display nice data on the screen
    int[] maxActionsPerEpisode;
    int[] longestIterationPerEpisode;
    int[] winsPerEpisode;
    int winsAchieved = 0;

    // Values used to keep track of which episode is
    // currently being simulated
    int currentlySimulatedEpisode = 0;
    int currentlySimulatedAction = 0; 

    // Values used to determine reward
    int actionsTaken = 0;
    int nodesVisited = 0;

    // Values used to determine which permutation of
    // visited towers the tank is in and entering
    int previousTowerPermutation = 0;
    int visitedTowersPermutation = 0;

    // Max amount of actions the tank can take
    final int ACTIONSPACE = 4;

    // QLearning variables
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

    // Method that calculates a single iteration in the current episode
    // Updates the QTable values and checks for end variables
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

    // Method that checks if the current iteration should end
    // Either because it wins by visiting 3 watchtowers
    // or because it wins by visiting all noes
    // or because it dies by going over a landmine
    // or because it failed by taking too many actions
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

    // Method that resets the iteration and all variables
    // Does not reset the QTable values
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

    // Determines the reward the tank should get by visiting a node at pos[]
    // Returns said reward
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

    // Updats the QTable value at prevPos[] based on the max
    // possible reward after newPos[] and the action taken
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

    // Returns the max value of an array
    // Used to get max possible reward value in the QTable
    float maxArr(float[] arr) {
        float max = -Float.MAX_VALUE;
        for(int i = 0; i < arr.length; i++) {
            if(arr[i] > max) {
                max = arr[i];
            }
        }
        return max;
    }

    // Calculates all the iterations for the next episode
    // and saves the moves for each iteration in an array
    // so that it can be displayed if needed
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

    // Simulates the episodes one by one on the screen
    // Decoupled from the calculation of episodes
    // Basically just takes the actions saved in the simulatedEpisodes
    // array and displays them one by one for each tank so that each
    // tank take their first, second, third, etc, move at the same time
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

    // Resets the position of the tanks for each episode 
    // at the start of a new episode simulation
    void resetSimulation(){
        for(int i = 0; i < max_iterations; i++){
            simulationTanks[i].x = simulationTanks[i].team.homebase[0] + 1;
            simulationTanks[i].y = simulationTanks[i].team.homebase[1] + 1;
        }
    }
}
