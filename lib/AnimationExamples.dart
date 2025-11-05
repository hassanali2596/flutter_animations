import 'package:flutter/material.dart';

import 'animation_examples/AlignTransition.dart';
import 'animation_examples/AnimatedAlign.dart';
import 'animation_examples/AnimatedBuilder.dart';
import 'animation_examples/AnimatedContainerExample.dart';
import 'animation_examples/AnimatedCrossFadeEcample.dart';
import 'animation_examples/AnimatedList.dart';
import 'animation_examples/AnimatedPhysicalModelDemo.dart';
import 'animation_examples/AnimatedPositionedExample.dart';
import 'animation_examples/AnimatedPositionedRelativeExample.dart';
import 'animation_examples/AnimatedSizeExample.dart';
import 'animation_examples/DecoratedBoxTransitionExample.dart';
import 'animation_examples/DefaultTextStyleTransitionExample.dart';
import 'animation_examples/HeroExample.dart';
import 'animation_examples/LogoFadeWithAnimatedOpacity.dart';
import 'animation_examples/MatrixTransition.dart';
import 'animation_examples/RotationTransitionExample.dart';
import 'animation_examples/ScaleTransitionExample.dart';
import 'animation_examples/SizeTransitionExample.dart';
import 'animation_examples/SpotLight/SpotLightExample.dart';
import 'animation_examples/StaggerAnimation/StaggerDrawerMenuExample.dart';
import 'animation_examples/StaggerAnimation/StaggerExample.dart';

class AnimationExamples extends StatelessWidget {
  const AnimationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Align Transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AlignTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated Positioned'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedPositionedExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated relative positioned'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => RelativePositionedTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated rotation transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => RotationTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated Size'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedSizeExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated Builder'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedBuilderExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated Container'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedContainerExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated Align'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedAlignExample()),);
            },
          ),
          ListTile(
            title: const Text('Logo Fade With Animated Opacity'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => LogoFadeWithAnimatedOpacity()),);
            },
          ),
          ListTile(
            title: const Text('Animated Cross Fade'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedCrossFadeExample()),);
            },
          ),
          ListTile(
            title: const Text('Animated list'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedListSample()),);
            },
          ),
          ListTile(
            title: const Text('Animated physical model'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => AnimatedPhysicalModelDemo()),);
            },
          ),
          ListTile(
            title: const Text('Decorated box transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => DecoratedBoxTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Default text style transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => DefaultTextStyleTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Hero animation'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => HeroExample()),);
            },
          ),
          ListTile(
            title: const Text('Matrix transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => MatrixTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Scale transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => ScaleTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Size transition'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => SizeTransitionExample()),);
            },
          ),
          ListTile(
            title: const Text('Staggered animation'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => StaggerAnimationExample()),);
            },
          ),
          ListTile(
            title: const Text('Staggered Drawer Menu'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => ExampleStaggeredDrawerMenuExample()),);
            },
          ),
          ListTile(
            title: const Text('Spotlight Example'),
            onTap: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => SpotlightDemo()),);
            },
          ),
        ],
      ),
    );
  }
}
