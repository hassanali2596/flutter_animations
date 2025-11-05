import 'package:flutter/material.dart';

class RelativePositionedTransitionExample extends StatefulWidget {
  const RelativePositionedTransitionExample({super.key});

  @override
  State<RelativePositionedTransitionExample> createState() =>
      _RelativePositionedTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _RelativePositionedTransitionExampleState extends State<RelativePositionedTransitionExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RelativePositionedTransition Example'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size biggest = constraints.biggest;
          return Stack(
            children: <Widget>[
              RelativePositionedTransition(
                size: biggest,
                rect: RectTween(
                  begin: const Rect.fromLTWH(0, 0, bigLogo, bigLogo),
                  end: Rect.fromLTWH(
                    biggest.width - smallLogo,
                    biggest.height - smallLogo,
                    smallLogo,
                    smallLogo,
                  ),
                ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut)),
                child: const Padding(padding: EdgeInsets.all(8), child: FlutterLogo()),
              ),
            ],
          );
        },
      ),
    );
  }
}