import 'package:humanbeans_clock/BottomLeftBranch.dart';
import 'package:humanbeans_clock/BottomRightBranch.dart';
import 'package:humanbeans_clock/ClockUiInheritedModel.dart';
import 'package:humanbeans_clock/ClockCounter.dart';
import 'package:humanbeans_clock/TopLeftBranch.dart';
import 'package:humanbeans_clock/TopRightBranch.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

// Widget holding all the four branches on the screen
//
// Each branch is aligned to one of the corners of the parent
// widget and it goes litle bit off the screen to hide any
// edges of the iamges when rotating animation plays
// The bird [FlareActor] is positioned so that simulates
// position behind the bottom right branch
class BranchesLayout extends StatelessWidget {
  const BranchesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Positioned(
        top: 0,
        left: -1,
        child: TopLeftBranch(),
      ),
      Positioned(
        top: 0,
        right: -1,
        child: TopRightBranch(),
      ),
      Center(child: ClockCounter()),
      const Positioned(bottom: 0, left: -1, child: BottomLeftBranch()),
      // The [FlareActor] subscirbes to the 'birdControls' aspect of
      // the [ClockUiInheritedModel] to use it's value. Shoudn't get notified
      // to rebuild as the model don't check for that aspect
      FlareActor(
        'assets/rive/Bird_Final_2.flr',
        controller:
            ClockUiInheritedModel.of(context, 'birdControls').birdControls,
        fit: BoxFit.contain,
        shouldClip: false,
      ),
      const Positioned(
        bottom: 0,
        right: -1,
        child: BottomRightBranch(),
      )
    ]);
  }
}
