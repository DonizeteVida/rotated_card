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
          Column(
            children: <Widget>[
              AnimatedCard(),
              ClipPath(
                child: Container(
                  height: 150,
                  color: Colors.cyan,
                ),
                clipper: CustomPath(),
              ),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 20,
              ),
            ],
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
      duration: Duration(seconds: 1),
    );
    _angleAnimation = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: _animationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.status == AnimationStatus.completed
            ? _animationController.reverse()
            : _animationController.forward();
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: RotationYTransition(
          angle: _angleAnimation,
          child1: Material(
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
          child2: Material(
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
          ),
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child1;
  final Widget child2;
  RotationYTransition({
    @required Animation<double> angle,
    @required this.child1,
    @required this.child2,
  }) : super(listenable: angle);
  @override
  Widget build(BuildContext context) {
    final v = listenable as Animation<double>;
    final angle = (v.value / 360) * math.pi * 2;
    final t = Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..rotateY(angle);
    debugPrint("$angle");

    final resolvedChild = v.value > 90
        ? Transform(
            child: child2,
            transform: Matrix4.rotationY(-math.pi),
            alignment: Alignment.center,
          )
        : child1;
    return Transform(
      child: resolvedChild,
      transform: t,
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
