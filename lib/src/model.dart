part of pong;

class GameModel {
  static num canvasWidth;
  static num canvasHeight;
  double startBallX;
  double startBallY;
  
  int racketBounces = 0;
  
  num level = 0; 
  
  num playerWins = 0;
  num aiWins = 0;
  
  GameModel(width, height) {
    canvasWidth = width; 
    canvasHeight = height; 
    
    startBallX = width / 2; 
    startBallY = height / 2; 
  }
  
  void playerWin() {
    playerWins++;
  }
  
  void aiWin() {
    aiWins++;
  }
  
  void racketHit() {
    racketBounces++;
  }
  
  get gamesTotal => playerWins + aiWins;
}

class BallModel {
  num x = 0; 
  num y = 0; 
  num r = 12; 
  
  String color = "#fff"; 
  
  /** 
   * ball movement 
   */
  int dx = 5; 
  int dy = 5; 
  
  BallModel() {
    _randomizeInitialMovement();
  }
  
  BallModel.toPosition(this.x, this.y) {
    _randomizeInitialMovement();
  }
  
  _randomizeInitialMovement() {
    Random r = new Random();
    
    dx *= r.nextBool() ? -1 : 1;
    dy *= r.nextBool() ? -1 : 1;
  }
  
  void move() {
      if (x + dx > GameModel.canvasWidth || x + dx < 0) 
        dx = -dx;
      
      if (y + dy > GameModel.canvasHeight || y + dy < 0) 
              dy = -dy;

      x += dx;
      y += dy;
      
     // print("x: " + x.toString() + " y: " + y.toString());
  }
  
  double triangulateX() {
    return dy / y * (x + dx);
  }
  
  bool isMovingUp() {
    return dy < 0;
  }
  
  int get upperBoundary => (y - r).toInt();
  int get lowerBoundary => (y + r).toInt();
  int get leftBoundary => (x - r).toInt();
  int get rightBoundary => (x + r).toInt();
}

abstract class RacketModel {
  static num height = 12; 
  static num width = 120; 
  
  var moveSteps = [5, 5, 5, 5, 5];
  
  num x; 
  num y; 
  
  static int sizeMalus = 20;
  static int minSize = 20;
  
  num moveDist = 5;
  
  String color = "#fff";
  
  RacketModel.toPosition(x, y) {
    this.x = x; 
    this.y = y; 
    
    adjustSpeed(0);
  }
  
  int getMovingSpeed(int level) {
    level = min(level, moveSteps.length - 1);
    return moveSteps[level];
  }
  
  void adjustSpeed(level) {
    moveDist = getMovingSpeed(level);
  }
  
  void moveRight() {
    x += moveDist;
    _checkMovementOperation();
  }
  
  void moveLeft() {
    x -= moveDist;
    _checkMovementOperation();
  }
  
  void _checkMovementOperation() {
    if (x > GameModel.canvasWidth - width) x = GameModel.canvasWidth - width;
    if (x < 0) x = 0;
  }
  
  static void decreaseSize() {
    width -= (width - sizeMalus) > minSize ? sizeMalus : 0;
  }
}

class PlayerRacketModel extends RacketModel {
  String color = "#ff0000";
  var moveSteps = [5, 5, 5, 7, 10];
  PlayerRacketModel.toPosition(x, y) : super.toPosition(x, y);
}

class AiRacketModel extends RacketModel {
  var moveSteps = [3, 4, 4, 6, 10];
  
  AiRacketModel.toPosition(x, y) : super.toPosition(x, y);
}