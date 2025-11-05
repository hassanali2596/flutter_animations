import 'package:flutter/material.dart';

class AnimatedPositionedExample extends StatefulWidget {
   AnimatedPositionedExample({super.key});

  Duration duration = Duration(seconds: 2);
  Curve curve= Curves.fastOutSlowIn;

  @override
  State<AnimatedPositionedExample> createState() => _AnimatedPositionedExampleState();
}

class _AnimatedPositionedExampleState extends State<AnimatedPositionedExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
            title: const Text('Animated Positioned')),
    body: SizedBox(
      width: 200,
      height: 350,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            width: selected ? 200.0 : 50.0,
            height: selected ? 50.0 : 200.0,
            top: selected ? 50.0 : 150.0,
            duration: widget.duration,
            curve: widget.curve,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = !selected;
                });
              },
              child: const ColoredBox(color: Colors.blue, child: Center(child: Text('Tap me'))),
            ),
          ),
        ],
      ),
    ));
  }
}