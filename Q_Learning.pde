/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

 class QLearning{
    float[][] QTable;

    int episodes;
    int max_iterations;
    float exploration_probability = 1;
    float exploration_decay = 0.001;
    float min_exploration = 0.01;
    float discounted_factor = 0.99;
    float learning_rate;

    QLearning(int _episodes, int _maxIter, float _learningRate){
        QTable = new float[gridSize * gridSize][4];
        for(int i = 0; i < gridSize * gridSize; i++){
            for(int j = 0; j < 4; j++){
                QTable[i][j] = 0.0;
            }
        }

        episodes = _episodes;
        max_iterations = _maxIter;
        learning_rate = _learningRate;
    }


 }