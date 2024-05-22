import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/*
This class is used to simplify duplication code when initializing animation controller
*/
class CustomAnimation {
  // Variables
  late TickerProvider ticker;
  late AnimationController animationController;
  late int shakingCounter, animationDuration, maxShakingCounter;

  // Constructor
  CustomAnimation({
    required this.ticker,
    this.shakingCounter = 0,
    this.animationDuration = 50,
    this.maxShakingCounter = 2,
  }) {
    // As the class not support initState() due to not a StatefulWidget, so need to initialize it here
    initializeClass();
  }

  // Initialise class
  void initializeClass() {
    // Initialize animation controller
    animationController = AnimationController(
      vsync: ticker,
      duration: Duration(milliseconds: animationDuration),
    );

    animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
        if (status == AnimationStatus.dismissed &&
            shakingCounter < maxShakingCounter) {
          animationController.forward();
          shakingCounter++;
        }
      },
    );
  }

  /*
  Retrieve animation offset controller
  */
  Animation<Offset> returnAnimationOffset({double dx = 0.01, double dy = 0.0}) {
    return Tween<Offset>(
      begin: Offset(dx * -1, dy),
      end: Offset(dx, dy),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
  }
}
