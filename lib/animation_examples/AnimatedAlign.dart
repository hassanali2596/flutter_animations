import 'package:flutter/material.dart';

class AnimatedAlignExample extends StatefulWidget {
   AnimatedAlignExample({super.key});

   Duration duration = Duration(seconds: 1);
   Curve curve= Curves.decelerate;

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Align'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),      body: GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          child: Container(
            width: 250.0,
            height: 250.0,
            color: Colors.red,
            child: AnimatedAlign(
              alignment: selected ? Alignment.topRight : Alignment.bottomLeft,
              duration: widget.duration,
              curve: widget.curve,
              child: const FlutterLogo(size: 50.0),
            ),
          ),
        ),
      ),
    );
  }
}