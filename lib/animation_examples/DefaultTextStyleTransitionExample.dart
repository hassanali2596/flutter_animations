import 'package:flutter/material.dart';

class DefaultTextStyleTransitionExample extends StatefulWidget {
  const DefaultTextStyleTransitionExample({super.key});

  @override
  State<DefaultTextStyleTransitionExample> createState() =>
      _DefaultTextStyleTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _DefaultTextStyleTransitionExampleState extends State<DefaultTextStyleTransitionExample>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late TextStyleTween _styleTween;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _styleTween = TextStyleTween(
      begin: const TextStyle(fontSize: 50, color: Colors.blue, fontWeight: FontWeight.w900),
      end: const TextStyle(fontSize: 50, color: Colors.red, fontWeight: FontWeight.w100),
    );
    _curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
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
        title: const Text('DefaultTextStyleTransition Example'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: DefaultTextStyleTransition(
          style: _styleTween.animate(_curvedAnimation),
          child: const Text('Flutter'),
        ),
      ),
    );
  }
}