import 'package:flutter/material.dart';

class AnimatedPhysicalModelDemo extends StatefulWidget {
  const AnimatedPhysicalModelDemo({super.key});

  @override
  _AnimatedPhysicalModelDemoState createState() =>
      _AnimatedPhysicalModelDemoState();
}

class _AnimatedPhysicalModelDemoState extends State<AnimatedPhysicalModelDemo> {
  bool _isElevated = false;

  void _toggleElevation() {
    setState(() {
      _isElevated = !_isElevated; // Toggle elevation state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedPhysicalModel Demo'),
        automaticallyImplyLeading: true,// App bar title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedPhysicalModel(
              duration: Duration(seconds: 2), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              elevation: _isElevated ? 28.0 : 0.0, // Animate elevation
              shape: BoxShape.rectangle, // Shape of the container
              shadowColor: Colors.green, // Color of the shadow
              color: Colors.green, // Color of the container
              borderRadius: BorderRadius.circular(8.0), // Border radius
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    'Animated',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Empty space between elements
            ElevatedButton(
              onPressed: _toggleElevation, // Button click handler
              child: Text(_isElevated
                  ? 'Remove Elevation'
                  : 'Add Elevation'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}