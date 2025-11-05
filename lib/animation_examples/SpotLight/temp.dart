import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SpotlightDemo()));
}

enum SpotlightPosition { above, below, left, right }

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

class SpotlightDemo extends StatefulWidget {
  @override
  _SpotlightDemoState createState() => _SpotlightDemoState();
}

class _SpotlightDemoState extends State<SpotlightDemo> with TickerProviderStateMixin {
  final List<SpotlightStep> _steps = [
    SpotlightStep(
      key: GlobalKey(),
      description: "This is a star icon.",
      position: SpotlightPosition.below,
    ),
    SpotlightStep(
      key: GlobalKey(),
      description: "This is an elevated button.",
      position: SpotlightPosition.right,
    ),
    SpotlightStep(
      key: GlobalKey(),
      description: "This container is at the bottom.",
      position: SpotlightPosition.above,
    ),
  ];

  OverlayEntry? _overlayEntry;
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;
  Rect? _oldRect;
  Rect? _newRect;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final interpolatedRect = Rect.lerp(_oldRect, _newRect, _animation.value)!;

            return Stack(
              children: [
                GestureDetector(
                  onTap: _nextOrEnd,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: SpotlightPainter(holeRect: interpolatedRect),
                  ),
                ),
                _buildDescription(interpolatedRect, _steps[_currentIndex]),
              ],
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(from: 0);
  }

  Widget _buildDescription(Rect rect, SpotlightStep step) {
    final offset = 10.0;
    Widget descriptionBox = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              step.description,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: _endSpotlight,
                child: Text("Skip", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: _nextOrEnd,
                child: Text(
                  _currentIndex == _steps.length - 1 ? "Done" : "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Position the description box based on enum
    switch (step.position) {
      case SpotlightPosition.above:
        return Positioned(
          left: rect.left,
          bottom: MediaQuery.of(context).size.height - rect.top + offset,
          child: descriptionBox,
        );
      case SpotlightPosition.below:
        return Positioned(
          left: rect.left,
          top: rect.bottom + offset,
          child: descriptionBox,
        );
      case SpotlightPosition.left:
        return Positioned(
          top: rect.top,
          right: MediaQuery.of(context).size.width - rect.left + offset,
          child: descriptionBox,
        );
      case SpotlightPosition.right:
        return Positioned(
          top: rect.top,
          left: rect.right + offset,
          child: descriptionBox,
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
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Spotlight")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.star, key: _steps[0].key, size: 50, color: Colors.amber),
              SizedBox(height: 30),
              ElevatedButton(
                key: _steps[1].key,
                onPressed: () {},
                child: Text("Click Me"),
              ),
              SizedBox(height: 30),
              Spacer(),
              Container(
                key: _steps[2].key,
                width: 200,
                height: 100,
                color: Colors.greenAccent,
                alignment: Alignment.center,
                child: Text("I'm a container"),
              ),
              SizedBox(height: 50), // Additional padding for scroll or small screens
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSpotlight(_currentIndex),
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

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
