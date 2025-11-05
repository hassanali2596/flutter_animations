import 'package:flutter/material.dart';

class LogoFadeWithAnimatedOpacity extends StatefulWidget {
  const LogoFadeWithAnimatedOpacity({super.key});

  @override
  State<LogoFadeWithAnimatedOpacity> createState() => LogoFadeWithAnimatedOpacityState();
}

class LogoFadeWithAnimatedOpacityState extends State<LogoFadeWithAnimatedOpacity> {
  double opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logo Fade with Animated Opacity'),
        backgroundColor: Colors.white ,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: opacityLevel,
              duration: const Duration(seconds: 3),
              child: const FlutterLogo(size: 50,),
            ),
            ElevatedButton(
              onPressed: _changeOpacity,
              child: const Text('Fade Logo'),
            ),
          ],
        ),
      ),
    );
  }
}