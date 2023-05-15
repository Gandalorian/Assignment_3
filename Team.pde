/* 
 * Authors:
 * - Erik Gustafsson
 * - August Hafvenström
 */

/*
 * Generic class for the teams.
 */

class Team{

    // Team variables
    color teamColor;
    int[] homebase;
    Tank[] tanks;

    // Constructor
    Team(color _color, int[] _homebase){
        this.teamColor = _color;
        this.homebase = _homebase;
        this.tanks = new Tank[3];
        this.tanks[0] = new Tank(this.homebase[0] + 1, this.homebase[1] + 1, 0, this);
        this.tanks[1] = new Tank(this.homebase[0] + 1, this.homebase[1] + 3, 1, this);
        this.tanks[2] = new Tank(this.homebase[0] + 1, this.homebase[1] + 5, 2, this);
    }

    // Runs every frame
    void updateLogic(){
        for(Tank t: this.tanks){
            if(t != null){
                t.update();
            }
        }
    }

    // Dummy
    void init(){
        
    }
}
