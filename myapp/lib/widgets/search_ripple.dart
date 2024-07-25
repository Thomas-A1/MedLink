import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RippleAnimationWidget extends StatefulWidget {
  final LatLng position;

  const RippleAnimationWidget({Key? key, required this.position}) : super(key: key);

  @override
  _RippleAnimationWidgetState createState() => _RippleAnimationWidgetState();
}

class _RippleAnimationWidgetState extends State<RippleAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController rippleController1;
  late Animation<double> rippleRadius1;
  late Animation<double> rippleOpacity1;

  late AnimationController rippleController2;
  late Animation<double> rippleRadius2;
  late Animation<double> rippleOpacity2;

  @override
  void initState() {
    super.initState();
    rippleController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2550),
    );
    rippleRadius1 = Tween<double>(begin: 0, end: 250).animate(
      CurvedAnimation(
        parent: rippleController1,
        curve: Curves.ease,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            rippleController1.repeat();
          } else if (status == AnimationStatus.dismissed) {
            rippleController1.forward();
          }
        },
      );

    rippleOpacity1 = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: rippleController1,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    rippleController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    rippleRadius2 = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(
        parent: rippleController2,
        curve: Curves.ease,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            rippleController2.repeat();
          } else if (status == AnimationStatus.dismissed) {
            rippleController2.forward();
          }
        },
      );

    rippleOpacity2 = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: rippleController2,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    rippleController1.forward();
    Timer(
      Duration(milliseconds: 1250),
      () {
        rippleController2.forward();
      },
    );
  }

  @override
  void dispose() {
    rippleController1.dispose();
    rippleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        rippleRadius1.value,
        rippleOpacity1.value,
        rippleRadius2.value,
        rippleOpacity2.value,
      ),
      child: Container(),
    );
  }
}

class MyPainter extends CustomPainter {
  final double rippleRadius1;
  final double rippleOpacity1;
  final double rippleRadius2;
  final double rippleOpacity2;

  MyPainter(
    this.rippleRadius1,
    this.rippleOpacity1,
    this.rippleRadius2,
    this.rippleOpacity2,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var firstPaint = Paint()
      ..color = Colors.blue.withOpacity(rippleOpacity1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      rippleRadius1,
      firstPaint,
    );

    var secondPaint = Paint()
      ..color = const Color.fromARGB(255, 6, 38, 63).withOpacity(rippleOpacity2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      rippleRadius2,
      secondPaint,
    );

    var centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width / 11,
      centerCirclePaint,
    );

    var innerCirclePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width / 16,
      innerCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
