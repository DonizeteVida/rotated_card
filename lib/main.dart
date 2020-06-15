import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatelessWidget {
  const HomeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnimatedCard(),
                ClipPath(
                  child: Container(
                    height: 150,
                    color: Colors.cyan,
                  ),
                  clipper: CustomPath(),
                ),
                CustomPaint(
                  child: ClipPath(
                    child: Container(
                      height: 150,
                      color: Colors.cyan,
                    ),
                    clipper: CustomPath(),
                  ),
                  painter: CustomPathPainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  AnimatedCard({Key key}) : super(key: key);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _angleAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1250),
    );
    _angleAnimation = Tween<double>(begin: 0, end: .5).animate(
      CurvedAnimation(
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn,
        parent: _animationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (_animationController.status) {
          case AnimationStatus.dismissed:
            _animationController.forward();
            break;
          case AnimationStatus.completed:
            _animationController.reverse();
            break;
          default:
          //Do nothing
        }
      },
      child: RotationTransition(
        animation: _angleAnimation,
        builder: (value) {
          if (value >= .25) {
            return Transform(
              transform: Matrix4.rotationY(-math.pi),
              alignment: Alignment.center,
              child: Material(
                elevation: 5,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.red,
                  height: 150,
                  width: double.infinity,
                  child: Text(
                    "RED",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
            );
          }
          return Material(
            elevation: 5,
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              height: 150,
              width: double.infinity,
              child: Text(
                "BLUE",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
          );
        },
        transform: (v) {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(v * math.pi * 2);
        },
      ),
    );
  }
}

class RotationTransition extends AnimatedWidget {
  final Matrix4 Function(double) transform;
  final Widget Function(double) builder;
  RotationTransition({
    @required Animation<double> animation,
    @required this.transform,
    @required this.builder,
  }) : super(listenable: animation);
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: transform(animation.value),
      child: builder(animation.value),
      alignment: Alignment.center,
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final counter = 10;
    final path = Path();
    path.lineTo(0, size.height - (size.height * .2));
    final distance = size.width / counter;
    for (var i = 0; i < counter; i++) {
      path.arcTo(
        Rect.fromLTWH(
          distance * i,
          size.height - (size.height * .2) - (distance / 2),
          distance,
          distance,
        ),
        0,
        math.pi,
        false,
      );
    }
    path.lineTo(size.width, size.height - (size.height * .2));
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final counter = 10;
    final path = Path();
    path.lineTo(0, size.height - (size.height * .2));
    final distance = size.width / counter;
    for (var i = 0; i < counter; i++) {
      path.arcTo(
        Rect.fromLTWH(
          distance * i,
          size.height - (size.height * .2) - (distance / 2),
          distance,
          distance,
        ),
        0,
        math.pi,
        false,
      );
    }
    path.lineTo(size.width, size.height - (size.height * .2));
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
