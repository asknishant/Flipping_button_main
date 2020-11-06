import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(FlipHome());
}

class FlipHome extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FlippingButton(
            color: const Color(0xFFFFFF00),
            background: const Color(0xFF333333),
            leftLabel: 'Free',
            rightLabel: 'Premium',
          ),
        ),
      ),
    );
  }
}

class FlippingButton extends StatefulWidget {
  final Color color;
  final Color background;
  final String leftLabel;
  final String rightLabel;

  const FlippingButton(
      {Key key, this.color, this.background, this.leftLabel, this.rightLabel})
      : super(key: key);

  @override
  _FlippingButtonState createState() => _FlippingButtonState();
}

class _FlippingButtonState extends State<FlippingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _shiftPosition(true);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _shiftPosition(bool leftEnabled) {
    _flipController.value = leftEnabled ? 1.0 : 0.0;
  }

  void _switchState() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _buildBtnBackground(),
      AnimatedBuilder(
          animation: _flipController,
          builder: (context, snapshot) {
            return _buildFlippingBtn(pi * _flipController.value);
          }),
    ]);
  }

  Container _buildBtnBackground() {
    return Container(
      width: 250,
      height: 64,
      decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(width: 5, color: widget.color)),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.leftLabel,
                style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.rightLabel,
                style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFlippingBtn(double angle) {
    final isLeft = angle > (pi / 2);
    final transformAngle = isLeft ? angle - pi : angle;

    return Positioned(
      top: 0,
      bottom: 0,
      right: isLeft ? null : 0,
      left: isLeft ? 0 : null,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002) //Perspective matrix
          ..rotateY(transformAngle),
        alignment:
            isLeft ? FractionalOffset(1.0, 1.0) : FractionalOffset(0.0, 1.0),
        child: Container(
          width: 125,
          height: 64,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.only(
                topRight: isLeft ? Radius.zero : Radius.circular(32),
                bottomRight: isLeft ? Radius.zero : Radius.circular(32),
                topLeft: isLeft ? Radius.circular(32) : Radius.zero,
                bottomLeft: isLeft ? Radius.circular(32) : Radius.zero,
              )),
          child: Center(
            child: Text(
              isLeft ? widget.leftLabel : widget.rightLabel,
              style: TextStyle(
                  color: widget.background,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
