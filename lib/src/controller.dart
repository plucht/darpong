part of pong;

class Control {
  GameModel game;
  BoardView boardView;

  BallView ball;
  RacketView player;
  RacketView computer;

  AiRacketModel aiModel;
  PlayerRacketModel playerModel;
  BallModel ballModel;

  Timer timer;

  bool rightDown = false;
  bool leftDown = false;

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  
  num originX = 0; 

  Control(this.canvas) {
    double centerX = canvas.width / 2 - RacketModel.width / 2;

    game = new GameModel(canvas.width, canvas.height);
    boardView = new BoardView(this, game);

    aiModel = new AiRacketModel.toPosition(centerX, 0);
    playerModel = new PlayerRacketModel.toPosition(centerX, GameModel.canvasHeight - RacketModel.height);
    // ballModel = new BallModel.toPosition(centerX, 120);

    context = canvas.getContext("2d");
    boardView.drawCanvas();

    document.querySelector('#spielen').onClick.listen((e) {
      if (timer is Timer) timer.cancel();
      originX = e.page.x; 
      init();
    });

    document.onKeyDown.listen((event) {
      if (event.keyCode == 39) rightDown = true;
      if (event.keyCode == 37) leftDown = true;
    });

    document.onKeyUp.listen((event) {
      if (event.keyCode == 39) rightDown = false;
      if (event.keyCode == 37) leftDown = false;
    });
    
    
  }

  void init() {
    double centerX = GameModel.canvasWidth / 2 - RacketModel.width / 2;
 
    // Reset AI Racket Position
    aiModel.x = centerX; 
    aiModel.y = 0;

    
    ball = new BallView(this, new BallModel.toPosition(centerX, 120));
    computer = new RacketView(this, aiModel);
    player = new RacketView(this, playerModel);
    
    
    int canvasMin = canvas.offsetLeft; 
    int canvasMax = canvasMin + canvas.width; 
    
    document.onMouseMove.listen((event) {
      if (event.page.x > canvasMin && event.page.x < canvasMax) {
        playerModel.x = event.page.x - canvas.offsetLeft - (RacketModel.width / 2); 
        
        if (playerModel.x < 0) playerModel.x = 0; 
        if (playerModel.x > canvas.width - RacketModel.width) playerModel.x = canvas.width - RacketModel.width; 
      }
    });
    timer = new Timer.periodic(const Duration(milliseconds: 10), (t) => redraw());
    
    boardView.update();
  }

  void clear() {
    context.clearRect(0, 0, GameModel.canvasWidth, GameModel.canvasHeight);
    boardView.drawCanvas();
  }

  void aiMove() {
    if (ball.model.isMovingUp()) {
      num expectedBallX = ball.model.x; //ball.model.triangulateX();

      if (expectedBallX > computer.model.x + RacketModel.width) computer.model.moveRight();
      if (expectedBallX < computer.model.x) computer.model.moveLeft();
      computer.model._checkMovementOperation();
    }
  }

  void redraw() {

    context.font = '30pt Montserrat, sans-serif';
    context.textAlign = 'center';

    clear();

    ball.move();
    ball.update();

    // computer move
    aiMove();

    if (rightDown) {
      player.model.moveRight();
    }

    if (leftDown) {
      player.model.moveLeft();
    }

    computer.update();
    player.update();

    num centerX = GameModel.canvasWidth / 2;
    num centerY = GameModel.canvasHeight / 2;

    
    if (ball.model.upperBoundary < RacketModel.height) {
   
      if (ball.model.rightBoundary > computer.model.x && ball.model.leftBoundary < computer.model.x + RacketModel.width) {
        ball.model.dy = -ball.model.dy;
        game.racketHit();
      } else {
        timer.cancel();
        playerWin(centerX, centerY);
      }
    }

   
    if (ball.model.lowerBoundary + ball.model.dy > GameModel.canvasHeight) {
     if (ball.model.rightBoundary > player.model.x && ball.model.leftBoundary < player.model.x + RacketModel.width) {
        ball.model.dy = -ball.model.dy;
        game.racketHit();
      } else {
        timer.cancel();
        playerLose(centerX, centerY);
      }
    }
  }

  void playerWin(x, y) {
    boardView.canvasWin(x, y);
    boardView.update();

    increaseDifficulty();
  }

  void playerLose(x, y) {
    boardView.canvasLose(x, y);
    boardView.update();
  }

  void increaseDifficulty() {
    RacketModel.decreaseSize();
    game.level += 1;

    aiModel.adjustSpeed(game.level);
    playerModel.adjustSpeed(game.level);
  }
}
