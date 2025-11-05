import 'package:flutter/material.dart';



class SpotlightDemo extends StatefulWidget {
  @override
  _SpotlightDemoState createState() => _SpotlightDemoState();
}

class _SpotlightDemoState extends State<SpotlightDemo>
    with TickerProviderStateMixin {
  late List<GlobalKey> _targetKeys;
  late List<SpotlightStep> _steps;
  int _currentIndex = 0;

  OverlayEntry? _overlayEntry;

  late AnimationController _spotlightController;
  late Animation<double> _spotlightAnimation;

  late AnimationController _cardController;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;

  Rect? _oldRect;
  Rect? _newRect;

  @override
  void initState() {
    super.initState();

    _targetKeys = List.generate(3, (_) => GlobalKey());

    _steps = [
      SpotlightStep(
        key: _targetKeys[0],
        description: "This is a star icon.",
        position: SpotlightPosition.below,
      ),
      SpotlightStep(
        key: _targetKeys[1],
        description: "Click this button to proceed.",
        position: SpotlightPosition.right,
      ),
      SpotlightStep(
        key: _targetKeys[2],
        description: "Here’s a container widget.",
        position: SpotlightPosition.above,
      ),
    ];

    _spotlightController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _spotlightAnimation = CurvedAnimation(
      parent: _spotlightController,
      curve: Curves.easeInOut,
    );

    _cardController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardFadeAnimation = CurvedAnimation(parent: _cardController, curve: Curves.easeIn);
  }

  void _startSpotlight() {
    _currentIndex = 0;
    _showSpotlight(_currentIndex);
  }

  void _showSpotlight(int index) {
    final step = _steps[index];
    final renderBox = step.key.currentContext!.findRenderObject() as RenderBox;
    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    final newRect = Rect.fromLTWH(
      targetPosition.dx - 10,
      targetPosition.dy - 10,
      targetSize.width + 20,
      targetSize.height + 20,
    );

    _oldRect = _newRect ?? newRect;
    _newRect = newRect;

    _overlayEntry?.remove();
    _cardController.reset();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _spotlightAnimation,
          builder: (context, child) {
            final interpolatedRect =
            Rect.lerp(_oldRect, _newRect, _spotlightAnimation.value)!;
            return Stack(
              children: [
                GestureDetector(
                  onTap: _nextOrEnd,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: SpotlightPainter(holeRect: interpolatedRect),
                  ),
                ),
                if (_spotlightAnimation.isCompleted)
                  _buildAnimatedDescription(interpolatedRect, _steps[_currentIndex]),
              ],
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _spotlightController.forward(from: 0).whenComplete(() {
      _cardController.forward();
    });
  }

  Widget _buildAnimatedDescription(Rect rect, SpotlightStep step) {
    final offset = 10.0;

    final descriptionCard = SlideTransition(
      position: _cardSlideAnimation,
      child: FadeTransition(
        opacity: _cardFadeAnimation,
        child: Card(
          elevation: 6,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(step.description,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: _endSpotlight, child: Text("Skip")),
                    TextButton(
                        onPressed: _nextOrEnd,
                        child: Text(_currentIndex == _steps.length - 1
                            ? "Done"
                            : "Next")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    switch (step.position) {
      case SpotlightPosition.above:
        return Positioned(
          left: rect.left,
          bottom: MediaQuery.of(context).size.height - rect.top + offset,
          child: descriptionCard,
        );
      case SpotlightPosition.below:
        return Positioned(
          left: rect.left,
          top: rect.bottom + offset,
          child: descriptionCard,
        );
      case SpotlightPosition.left:
        return Positioned(
          top: rect.top,
          right: MediaQuery.of(context).size.width - rect.left + offset,
          child: descriptionCard,
        );
      case SpotlightPosition.right:
        return Positioned(
          top: rect.top,
          left: rect.right + offset,
          child: descriptionCard,
        );
    }
  }

  void _nextOrEnd() {
    if (_currentIndex < _steps.length - 1) {
      _currentIndex++;
      _showSpotlight(_currentIndex);
    } else {
      _endSpotlight();
    }
  }

  void _endSpotlight() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _spotlightController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spotlight Example")),
      body: Column(
        children: [
          Icon(Icons.star, key: _targetKeys[0], size: 50, color: Colors.amber),
          SizedBox(height: 30),
          ElevatedButton(
            key: _targetKeys[1],
            onPressed: () {},
            child: Text("Click Me"),
          ),
          SizedBox(height: 30),
          Spacer(),
          Container(
            key: _targetKeys[2],
            width: 200,
            height: 100,
            color: Colors.greenAccent,
            alignment: Alignment.center,
            child: Text("I'm a container"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startSpotlight,
            child: Text("Start Spotlight"),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SpotlightStep {
  final GlobalKey key;
  final String description;
  final SpotlightPosition position;

  SpotlightStep({
    required this.key,
    required this.description,
    this.position = SpotlightPosition.below,
  });
}

enum SpotlightPosition { above, below, left, right }

class SpotlightPainter extends CustomPainter {
  final Rect holeRect;

  SpotlightPainter({required this.holeRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, Radius.circular(12)));
    final combined = Path.combine(PathOperation.difference, overlayPath, holePath);

    canvas.drawPath(combined, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

