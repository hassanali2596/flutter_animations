import 'package:flutter/material.dart';

class AnimatedSizeExample extends StatefulWidget {
  AnimatedSizeExample({super.key});

  Duration duration = Duration(seconds: 2);
  Curve curve= Curves.easeIn;

  @override
  State<AnimatedSizeExample> createState() => _AnimatedSizeExampleState();
}

class _AnimatedSizeExampleState extends State<AnimatedSizeExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Animated Size'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true
        ),
        body: SizedBox(
          width: 200,
          height: 350,
          child: Stack(
            children: <Widget>[
              AnimatedSize(
                duration: widget.duration,
                curve: widget.curve,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = !selected;
                    });
                  },
                  child: SizedBox(
                    width: selected ? 200.0 : 50.0,
                    height: selected ? 50.0 : 200.0,
                    child: const ColoredBox(color: Colors.blue, child: Center(child: Text('Tap me'))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}