import 'package:flutter/material.dart';
import 'package:flutter_tusi_couple_animation/random_color.dart';
import 'package:flutter_tusi_couple_animation/tusi_couple_painter.dart';

class TusiCoupleScreen extends StatefulWidget {
  const TusiCoupleScreen({Key? key}) : super(key: key);

  @override
  State<TusiCoupleScreen> createState() => _TusiCoupleScreenState();
}

class _TusiCoupleScreenState extends State<TusiCoupleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isTracePathChecked = false;
  bool isInnerCircleChecked = false;
  int numberOfCircle = 1;
  List<Color> dotColors = [Colors.blue];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberOfDots = Row(
      children: [
        const Text(
          'Number of Dots: ',
          style: TextStyle(color: Colors.white),
        ),
        Slider(
          value: numberOfCircle.toDouble(),
          min: 1,
          max: 24,
          divisions: 23,
          label: numberOfCircle.round().toString(),
          onChanged: (double value) {
            setState(() {
              numberOfCircle = value.toInt();
              dotColors = List<Color>.generate(
                  numberOfCircle, (index) => RandomColor.random());
            });
          },
        ),
      ],
    );

    final checkboxes = Row(
      children: [
        Checkbox(
          checkColor: Colors.blue,
          value: isTracePathChecked,
          onChanged: (bool? value) {
            print('isTracePathChecked: $value');
            setState(() {
              isTracePathChecked = value!;
            });
          },
        ),
        const Text(
          'Trace Path',
          style: TextStyle(color: Colors.black),
        ),
        Checkbox(
          checkColor: Colors.blue,
          value: isInnerCircleChecked,
          onChanged: (bool? value) {
            setState(() {
              isInnerCircleChecked = value!;
            });
          },
        ),
        const Text(
          'Inner Circle',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tusi Couple'),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                numberOfDots,
                checkboxes,
                Expanded(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget? child) {
                        return CustomPaint(
                          painter: TusiCouplePainter(
                              angle: animationController.value * 360,
                              numberOfLines: numberOfCircle,
                              innerCircleVisible: isInnerCircleChecked,
                              isTracePathVisible: isTracePathChecked,
                              colors: dotColors),
                          child: Container(),
                        );
                      },
                    )),
              ],
            ),
          ),
        ));
  }
}