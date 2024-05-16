import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_brick_breaker/ball.dart';
import 'package:game_brick_breaker/bricks.dart';
import 'package:game_brick_breaker/coverscreen.dart';
import 'package:game_brick_breaker/gameoverscreen.dart';
import 'package:game_brick_breaker/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrement = 0.02;
  double ballYincrement = 0.01;
  // var ballDirection = direction.DOWN;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // player variables
  double playerX = -0.2;
  double playerWidth = 0.4;

  // bricks variables
  static double fisrtBrickX = -1 + wallGap;
  static double fisrtBrickY = -0.9;
  static double bricksWidth = 0.2; // out of 2
  static double bricksHeight = 0.05; // out of 2
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 8;
  static int numberOfBricksInColumn = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * bricksWidth -
          (numberOfBricksInRow - 1) * brickGap);
  bool isBrickHit = false;

  List myBricks = List.generate(
    numberOfBricksInRow * numberOfBricksInColumn,
    (index) => [
      fisrtBrickX +
          (index % numberOfBricksInRow) *
              (bricksWidth + brickGap), // x position
      fisrtBrickY +
          (index ~/ numberOfBricksInRow) *
              (bricksHeight + brickGap), // y position
      false, // not hit
    ],
  );

  // mặc định khi game chưa khởi động là false
  bool hasGameStarted = false;
  // mặc định khi game chưa kết thúc là false
  bool isGameOver = false;
  // make sure the ball is not hit the bricks

  // Start game
  void StartGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // update direction
      updateDirection();
      // move ball
      moveBall();
      // check if game is over
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check if bricks are hit
      checkForBrickHit();
      if (isBricksHit()) {
        isBrickHit = true;
      }
    });
  }

  // Restart game
  void restartGame() {
    setState(() {
      // reset ball
      ballX = 0;
      ballY = 0;
      // reset game
      hasGameStarted = false;
      isGameOver = false;
      // reset player
      playerX = -0.2;

      // reset bricks
      myBricks = List.generate(
        numberOfBricksInRow * numberOfBricksInColumn,
        (index) => [
          fisrtBrickX +
              (index % numberOfBricksInRow) *
                  (bricksWidth + brickGap), // x position
          fisrtBrickY +
              (index ~/ numberOfBricksInRow) *
                  (bricksHeight + brickGap), // y position
          false, // not hit
        ],
      );
    });
  }

  // check bricks are hit
  bool isBricksHit() {
    if (ballY <= myBricks[0][0] + bricksHeight &&
        ballX >= myBricks[0][0] &&
        ballX <= myBricks[0][0] + bricksWidth) {
      return true;
    }
    return false;
  }

  // check player is dead
  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  // move ball
  void moveBall() {
    setState(() {
      // move horizontally
      if (ballXDirection == direction.RIGHT) {
        ballX += ballXincrement;
      } else if (ballXDirection == direction.LEFT) {
        ballX -= ballXincrement;
      }

      // move vertically
      if (ballYDirection == direction.DOWN) {
        ballY += ballYincrement;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincrement;
      }
    });
  }

  // update direction
  void updateDirection() {
    setState(() {
      // ball goes up when it hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      // ball goes down when it hit the top screen
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
      // ball goes left when it hits the left screen
      if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
      // ball goes right when it hits the right screen
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
    });
  }

  // check for brick hit, update isBrickHit
  void checkForBrickHit() {
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + bricksWidth &&
          ballY <= myBricks[i][1] + bricksHeight &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;
          // since the ball is hit, change the direction
          // base on which side of the brick is hit

          // caculate the distance of the ball from each side of the brick
          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + bricksWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballY).abs();
          double bottomSideDist = (myBricks[i][1] + bricksHeight - ballY).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          switch (min) {
            case 'left':
              ballXDirection = direction.LEFT;
              break;
            case 'right':
              ballXDirection = direction.RIGHT;
              break;
            case 'up':
              ballYDirection = direction.UP;
              break;
            case 'down':
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return "left";
    } else if ((currentMin - b).abs() < 0.01) {
      return "right";
    } else if ((currentMin - c).abs() < 0.01) {
      return "up";
    } else if ((currentMin - d).abs() < 0.01) {
      return "down";
    }
    return '';
  }

  // move left
void moveLeft() {
  setState(() {
    // only move left if left doesn't move player off the screen
    if (playerX - 0.2 >= -1) {
      playerX -= 0.2;
    }
  });
}

// move right
void moveRight() {
  setState(() {
    // only move right if right doesn't move player off the screen
    if (playerX + playerWidth + 0.2 <= 1) {
      playerX += 0.2;
    }
  });
}

  // Hàm build được gọi mỗi khi Flutter cần "vẽ" lại giao diện
  @override
  Widget build(BuildContext context) {
    // Scaffold là một widget cung cấp các thành phần cơ bản của giao diện như appBar, drawer, snackbar, etc.
    return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          }
        },
        child: GestureDetector(
          onTap: StartGame,
          child: Scaffold(
              backgroundColor: Colors.blue[100],
              // Body của Scaffold, ở đây là một widget Center để căn giữa các widget con
              body: Center(
                // Stack cho phép chồng các widget lên nhau
                child: Stack(
                  children: [
                    // Tap to play
                    CoverScreen(hasGameStarted: hasGameStarted),

                    // Game Over
                    GameOverScreen(
                      isGameOver: isGameOver,
                      function: restartGame,
                    ),

                    // myBall
                    MyBall(
                      ballX: ballX,
                      ballY: ballY,
                      hasGameStarted: hasGameStarted,
                      isGameOver: isGameOver,
                    ),

                    // myPlayer
                    MyPlayer(
                      playerX: playerX,
                      playerWidth: playerWidth,
                    ),

                    // bricks
                    // MyBrick(
                    //   bricksX: myBricks[0][0],
                    //   bricksY: myBricks[0][1],
                    //   bricksWidth: bricksWidth,
                    //   bricksHeight: bricksHeight,
                    //   isBrickHit: myBricks[0][2],
                    // ),

                    for (int i = 1; i < myBricks.length; i++)
                      MyBrick(
                        bricksX: myBricks[i][0],
                        bricksY: myBricks[i][1],
                        bricksWidth: bricksWidth,
                        bricksHeight: bricksHeight,
                        isBrickHit: myBricks[i][2],
                      ),

                    // where is Player exactly ??
                    Container(
                        alignment: Alignment(playerX, 0.9),
                        child: Container(
                          height: 15,
                          width: 4,
                        )),

                    Container(
                        alignment: Alignment(playerX + playerWidth, 0.9),
                        child: Container(
                          height: 15,
                          width: 4,
                        )),
                  ],
                ),
              )),
        )
        // Đặt màu nền cho Scaffold
        );
  }
}
