# Assignment_3

## Authors
- Group 03
- Erik Gustafsson
- August Hafvenström

## Prerequisites
- This project uses no external libraries except for Processing itself.
- It has been verified to run in both VSCODE and Processing IDE on Windows without issue.

### Instructions for Processing IDE
- Un-Zip the file at a convenient location.
- In Processing, open the "Assignment_1_Grid.pde"-file.
- Press the "play"-button.

### Instructions for VSCODE
- Un-Zip the file at a convenient location.
- Use "Open Folder" in the file-menu to open the folder containing the .pde-files.
- Open the Command Palette and select "Processing: Run Processing Project".
- If this does not work, try opening the Command Palette and select "Processing: Create Task File" to remake tasks.json.

## What am I looking at?
### The program's purpose
- This program displays the process of using Q-learning to teach a tank to find its way around the game world.
- The goal is to visit three watchtowers spread out on the 16x16 grid without hitting a landmine.
- This means that the Q-table's dimensions are defined as the amount of nodes, the permutations of visited watchtowers and finally the action space (moving in 4 all directions). Thus, the size of the table is (16x16) x 8 x 4.
- In total, the simulation runs for 100 000 iterations spread accross 1000 episodes.

### Reward System
As the program uses Q-learning, which is a kind of reinforcement learning, a reward system needs to be established. The tank is supposed to want to explore the grid and find all three watchtowers. In addition to that, it needs to avoid landmines and evaluate whether it is worth driving over swamps. Thus, the rewards look like this:
- Entering an empty node for the first time: 1.0
- Entering a swamp for the first time: 0.5
- Entering a node with a landmine: -100.0
- Entering a node with a watchtower for the first time: 1000.0

Each reward is then also multiplied with the amount of nodes visited to encourage exploration and finally divided by the amount of actions taken in total to punish visiting the same nodes over and over.

### Debugging information
- The display window shows each iteration simultaneously of every third episode.
- To the right, information about the currently shown episode and the total amount currently simulated is shown such as total episodes and successful iterations.
- You can click on any node on the grid and then all weights for each permutation of visited nodes will be shown in the debug window.

The permutations are presented in binary form, that is each digit represents the "visited" state of one watchtower. Therefor, 0/0/0 means no visited towers, 0/1/1 means the first two towers are visited etc.
- 0/0/0 
- 0/0/1
- 0/1/0
- 0/1/1
- 1/0/0
- 1/0/1
- 1/1/0
- 1/1/1
