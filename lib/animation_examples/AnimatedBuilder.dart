import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({super.key});

  @override
  State<AnimatedBuilderExample> createState() =>
      _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Start with forward animation once
    _controller.forward();
  }

  void _reverseDirection() {



      _controller.forward(from: 0.0);

      // _controller.reverse(from: 1.0);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedBuilder Example'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.green,
            child: const Center(child: Text('Whee!')),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle:  _controller.value * 2.0 * math.pi,
              child: child,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reverseDirection,
        child: const Icon(Icons.sync),
      ),
    );
  }
}
