part of pong;

abstract class View {
  Control controller; 
  
  View(this.controller);

  void update() {
    // banana
  }
}

class BoardView extends View {
  final playerScore = querySelector("#playerScore");
  final aiScore = querySelector("#aiScore");
  final rounds = querySelector("#round");
  final level = querySelector("#level");
  
  static const String TEXT_WIN = "YOU WON";
  static const String TEXT_LOSE = "YOU LOST";
  static String defaultFillStyle = "#fff";
  
  GameModel model;
  
  BoardView(controller, this.model) : super(controller);
  
  void drawCanvas() {
    controller.context.beginPath();
    controller.context.rect(0, 0, GameModel.canvasWidth, GameModel.canvasHeight);
    controller.context.closePath();
    controller.context.fillStyle = "#00A19A";
    controller.context.fill();
  }
  
  void canvasLose(x, y) {
    model.aiWin();
    controller.context.fillStyle = defaultFillStyle;
    controller.context.fillText(TEXT_LOSE, x, y);
  }
  
  void canvasWin(x, y) {
    model.playerWin();
    controller.context.fillStyle = defaultFillStyle;
    controller.context.fillText(TEXT_WIN, x, y);
  }
  
  void update() {
    playerScore.innerHtml = "<span>" + model.playerWins.toString() + "</span>";
    aiScore.innerHtml = "<span>" + model.aiWins.toString() + "</span>";
    rounds.innerHtml = (model.gamesTotal + 1).toString();
    level.innerHtml = model.level.toString();
  }
}

class BallView extends View {
  BallModel model; 
  
  BallView(controller, this.model) : super(controller);
  
  /**
   * Delegator to model's method
   */
  void move() {
    model.move();
  }
  
  void update() {
    controller.context.beginPath();
    controller.context.arc(model.x, model.y, model.r, 0, PI * 2, true);
    controller.context.closePath();
    controller.context.fillStyle = model.color;
    controller.context.fill();
  }
  
  void fadeOut() {  
    double alpha = 1.0;
    
    controller.context.save();
    
    Timer t = new Timer.periodic(const Duration(milliseconds : 100), (t) {
      controller.context.globalAlpha -= 0.1;
      alpha -= 0.1;
      
      controller.context.beginPath();
      controller.context.arc(model.x, model.y, model.r, 0, PI * 2, true);
      controller.context.closePath();
      controller.context.clip();
      controller.context.clearRect(model.leftBoundary, model.upperBoundary, model.rightBoundary, model.lowerBoundary); 
      
      controller.context.beginPath();
      controller.context.arc(model.x, model.y, model.r, 0, PI * 2, true);
      controller.context.closePath();
      controller.context.fillStyle = "rgba(255, 0, 0," + alpha.toString() + ")";//model.color;
      controller.context.fill();

      if (alpha <= 0) t.cancel();
    });
    
    
    controller.context.globalAlpha = 1;
    controller.context.restore();
  }
}

class RacketView extends View { 
  RacketModel model;
  
  RacketView(controller, this.model) : super(controller);
  
  void update() {    
    controller.context.beginPath();
    controller.context.rect(model.x, model.y, RacketModel.width, RacketModel.height);
    controller.context.closePath();
    controller.context.fillStyle = model.color;
    controller.context.fill();
  }
}