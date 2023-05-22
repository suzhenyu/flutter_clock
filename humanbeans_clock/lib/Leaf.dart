import 'package:humanbeans_clock/ClockUiInheritedModel.dart';
import 'package:flutter/material.dart';
import 'package:supernova_flutter_ui_toolkit/keyframes.dart';
import 'BranchAnimation.dart';
import 'LeafAnimation.dart';

// Widget that wraps the leaf elements.
//
// It holds both the 'Idle animation' and 'active animation' [AnimatedBuilders]. Both builders are
// build no matter if the animations are going to play.
// The [Leaf] widget requires an enclosing stack as it uses Positioned.
class Leaf extends StatelessWidget {
  // The width of the widget in dp.
  final double width;
  // The height of the widgt in dp.
  final double height;
  // The top position of the [Positioned] element in the stack.
  double? top;
  // The left position of the [Positioned] element in the stack.
  double? left;
  // The right position of the [Positioned] element in the stack.
  double? right;
  // The bottom position of the [Positioned] element in the stack.
  double? bottom;
  // The [Keyframe] that decribes the 'idle animation' movement
  final List<Keyframe<double>> keyframes;
  // The [Interval] used by the 'idle animation'
  final Interval interval;
  // The transform origin for the 'idle animation' of the leaf
  final FractionalOffset offset;
  // The asset uri for the image
  final String imageUri;
  // The index used to evaluate if the 'active animation' should play for this widget
  final int index;
  // [bool] governing the direciton of the 'active animation'
  final bool toRight;

  Leaf(
      {super.key,
      this.top,
      this.left,
      this.right,
      this.bottom,
      this.interval = const Interval(0, 1, curve: Curves.easeOutQuad),
      this.offset = const FractionalOffset(0, 0),
      this.toRight = true,
      required this.width,
      required this.height,
      required this.keyframes,
      required this.imageUri,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Get hold of the model for access to scaling and [AnimationController]
    //
    // 'Size' aspect should not cause rebuilds unless the size of the screen changes
    final model = ClockUiInheritedModel.of(context, 'size');

    return Positioned(
      top: top != null ? model.utils.scaleDimentions(top!) : null,
      left: left != null ? model.utils.scaleDimentions(left!) : null,
      right: right != null ? model.utils.scaleDimentions(right!) : null,
      bottom: bottom != null ? model.utils.scaleDimentions(bottom!) : null,
      child: SizedBox(
        width: model.utils.scaleDimentions(width),
        height: model.utils.scaleDimentions(height),
        // The widget doing the 'idle animation'. It runs continiously
        child: BranchAnimation(
          animationController: model.idleAnimation,
          keyframes: keyframes,
          interval: interval,
          transformOrigin: offset,
          // The widget doing the 'active animation' it runs
          child: LeafAnimation(
            transformOrigin: offset,
            activeController: model.activeAnimation,
            // Here we refference he [ClockUiInheritedModel] in a different way.
            // We want this widget to rebuild on [ClockUiInheritedModel.activeAnimationWidgetIndex] change,
            // so we subscribe it to the aspect including the index.
            isActive:
                ClockUiInheritedModel.of(context, 'activeAnimationIndex$index')
                        .activeAnimationWidgetIndex ==
                    index,
            toRight: toRight,
            child: Image.asset(imageUri, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
