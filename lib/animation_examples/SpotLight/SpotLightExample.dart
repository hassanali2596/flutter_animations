import 'package:flutter/material.dart';

class SpotlightDemo extends StatefulWidget {
  const SpotlightDemo({super.key});

  @override
  _SpotlightDemoState createState() => _SpotlightDemoState();
}

class _SpotlightDemoState extends State<SpotlightDemo> with TickerProviderStateMixin {
  late List<GlobalKey> _targetKeys;
  late List<SpotlightStep> _steps;
  int _currentIndex = 0;

  OverlayEntry? _overlayEntry;

  late AnimationController _spotlightController;
  late Animation<double> _spotlightAnimation;

  Rect? _oldRect;
  Rect? _newRect;

  Rect? _oldCardRect;
  Rect? _newCardRect;

  @override
  void initState() {
    super.initState();

    _targetKeys = List.generate(3, (_) => GlobalKey());

    _steps = [
      SpotlightStep(
        key: _targetKeys[0],
        description: "This is a star icon.",
        position: SpotlightPosition.below,
        rotateCard: false, // <-- This card will rotate on transition
      ),
      SpotlightStep(
        key: _targetKeys[1],
        description: "Click this button to proceed.",
        position: SpotlightPosition.right,
      ),
      SpotlightStep(
        key: _targetKeys[2],
        description: "Here’s a container widget gggggggggg.",
        position: SpotlightPosition.above,
        rotateCard: true, // Another rotating card example
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

    _oldCardRect = _oldCardRect ?? _buildCardRectForStep(_oldRect!, _steps[_currentIndex]);
    _newCardRect = _buildCardRectForStep(_newRect!, step);

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _spotlightAnimation,
          builder: (context, child) {
            final interpolatedRect =
            Rect.lerp(_oldRect, _newRect, _spotlightAnimation.value)!;
            final interpolatedCardRect =
            Rect.lerp(_oldCardRect, _newCardRect, _spotlightAnimation.value)!;

            final step = _steps[_currentIndex];

            // Determine rotation angle based on rotateCard flag
            final isAnimating = _spotlightController.isAnimating || _spotlightAnimation.value < 1.0;
            final rotationAngle = (step.rotateCard && isAnimating)
                ? Tween<double>(begin: 0.0, end: 0.25).transform(_spotlightAnimation.value) *
                3.1415926535 *
                2
                : 0.0;

            return Stack(
              children: [
                GestureDetector(
                  onTap: _nextOrEnd,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: SpotlightPainter(holeRect: interpolatedRect),
                  ),
                ),
                Positioned(
                  left: interpolatedCardRect.left,
                  top: interpolatedCardRect.top,
                  child: Transform.rotate(
                    angle: rotationAngle,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: interpolatedCardRect.width),
                      child: _buildDescriptionCard(step),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );


    Overlay.of(context)!.insert(_overlayEntry!);
    _spotlightController.forward(from: 0);
  }

  Rect _buildCardRectForStep(Rect holeRect, SpotlightStep step) {
    const double offset = 10.0;
    const double maxWidth = 250.0;

    final screenSize = MediaQuery.of(context).size;

    double left = holeRect.left;
    double top = holeRect.top;

    switch (step.position) {
      case SpotlightPosition.above:
        top = holeRect.top - offset - 150;
        break;
      case SpotlightPosition.below:
        top = holeRect.bottom + offset;
        break;
      case SpotlightPosition.left:
        left = holeRect.left - offset - maxWidth;
        break;
      case SpotlightPosition.right:
        left = holeRect.right + offset;
        break;
    }

    if (left < 0) left = 0;
    if (left + maxWidth > screenSize.width) left = screenSize.width - maxWidth;
    if (top < 0) top = 0;

    return Rect.fromLTWH(left, top, maxWidth, 0); // height is flexible
  }

  Widget _buildDescriptionCard(SpotlightStep step) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 6,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                step.description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: _endSpotlight, child: Text("Skip")),
                  TextButton(
                    onPressed: _nextOrEnd,
                    child: Text(_currentIndex == _steps.length - 1 ? "Done" : "Next"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _nextOrEnd() {
    if (_currentIndex < _steps.length - 1) {
      _oldCardRect = _newCardRect;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spotlight Example"),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Icon(Icons.star, key: _targetKeys[0], size: 50, color: Colors.amber),
          SizedBox(height: 30),
          ElevatedButton(
            key: _targetKeys[1],
            onPressed: () {},
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.blueAccent, width: 1),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
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
  final bool rotateCard; // new flag

  SpotlightStep({
    required this.key,
    required this.description,
    this.position = SpotlightPosition.below,
    this.rotateCard = false, // default no rotation
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
