import 'dart:math';

import 'package:mechanical_clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

class AnimatedDigitalTime extends AnimatedWidget {
  final Animation<double> animation;

  final ClockModel model;
  final Map<ClockColor, Color> palette;

  const AnimatedDigitalTime({
    super.key,
    required this.animation,
    required this.model,
    required this.palette,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();

    return DigitalTime(
      hour: time.hour,
      minute: time.minute,
      minuteProgress: animation.value,
      use24HourFormat: model.is24HourFormat,
      textColor: palette[ClockColor.digitalTimeText]!,
    );
  }
}

class DigitalTime extends LeafRenderObjectWidget {
  /// [hour] is in 24 hour format.
  final int hour, minute;

  /// Range from `0` to `1` ([minuteProgress] >= 0 ∧ [minuteProgress] <= 1)
  /// indicating how far the current minute has progressed.
  ///
  /// This should not be used as an accurate representation of the current second.
  final double minuteProgress;

  final bool use24HourFormat;

  final Color textColor;

  const DigitalTime({
    super.key,
    required this.textColor,
    required this.minuteProgress,
    required this.use24HourFormat,
    required this.hour,
    required this.minute,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDigitalTime(
      textColor: textColor,
      minuteProgress: minuteProgress,
      use24HourFormat: use24HourFormat,
      hour: hour,
      minute: minute,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderDigitalTime renderObject) {
    renderObject
      ..textColor = textColor
      ..minuteProgress = minuteProgress
      ..use24HourFormat = use24HourFormat
      ..hour = hour
      ..minute = minute;
  }
}

/// Provides child with data necessary to position what it draws
/// properly given full size constraints.
///
/// This allows the child to lay itself out when nothing in the
/// parent depends on the layout of the child.
/// Otherwise, the parent would be marked as needing to layout again,
/// which is bad performance wise.
class DigitalTimeParentData extends ClockChildrenParentData {
  late Offset position;
}

class RenderDigitalTime
    extends RenderCompositionChild<ClockComponent, DigitalTimeParentData> {
  RenderDigitalTime({
    required double minuteProgress,
    required int hour,
    required int minute,
    required bool use24HourFormat,
    required Color textColor,
  })  : _minuteProgress = minuteProgress,
        _hour = hour,
        _minute = minute,
        _use24HourFormat = use24HourFormat,
        _textColor = textColor,
        super(ClockComponent.digitalTime);

  double _minuteProgress;

  set minuteProgress(double value) {
    assert(value != null);

    if (_minuteProgress == value) {
      return;
    }

    _minuteProgress = value;
    // The layout depends on the time displayed.
    markNeedsLayout();
  }

  int _hour, _minute;

  set hour(int value) {
    assert(value != null);

    if (_hour == value) {
      return;
    }

    _hour = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set minute(int value) {
    assert(value != null);

    if (_minute == value) {
      return;
    }

    _minute = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  bool _use24HourFormat;

  set use24HourFormat(bool value) {
    assert(value != null);

    if (_use24HourFormat == value) {
      return;
    }

    _use24HourFormat = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  Color _textColor;

  set textColor(Color value) {
    assert(value != null);

    if (_textColor == value) {
      return;
    }

    _textColor = value;
    markNeedsPaint();
  }

  late TextPainter _timePainter, _amPmPainter;

  int get hour => _use24HourFormat ? _hour : _hour % 12;

  String get time => '${hour.twoDigitTime}:${_minute.twoDigitTime}';

  String get amPm => _hour > 12 ? 'PM' : 'AM';

  @override
  bool get isRepaintBoundary => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    compositionData.hasSemanticsInformation = true;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config
      ..label = 'Digital clock showing $time${_use24HourFormat ? '' : ' $amPm'}'
      ..isReadOnly = true
      ..textDirection = TextDirection.ltr;
  }

  /// Determines for how many seconds the moving item (AM/PM or the bar)
  /// should move at the start and end of a minute.
  /// This time is taken both at the start and the end for a total of
  /// [fastMoveSeconds] * 2 per minute.
  static const double fastMoveSeconds = 5;

  late TweenSequence yMovementSequence;

  @override
  void performLayout() {
    // This should ideally not be the whole screen,
    // but rather a constrained size, like the width
    // of the weather component.
    final given = constraints.biggest;

    _timePainter = TextPainter(
      text: TextSpan(
        text: time,
        style: TextStyle(
          color: _textColor,
          fontSize: given.width / 7.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    _amPmPainter = TextPainter(
      text: TextSpan(
        text: amPm,
        style: TextStyle(
          color: _textColor,
          fontSize: given.width / 13,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    _amPmPainter.layout(maxWidth: given.width / 2);
    _timePainter.layout(maxWidth: given.width - _amPmPainter.width);

    size = Size(
      min(
          // See https://github.com/flutter/flutter/issues/49183.
          constraints.biggest.width,
          _timePainter.width +
              // This is always correct because the bar that is used instead of AM-PM
              // should have the same width as the text.
              _amPmPainter.width),
      _timePainter.height,
    );

    // The widget should be painted centered about the position.
    compositionData.offset = compositionData.position - size.offset / 2;

    final
        // The text should go fully off screen about the new minute.
        h = _amPmPainter.height / 2,
        inDistance = _timePainter.text!.style!.fontSize! / 1.5;

    // Describes the center position of the element.
    yMovementSequence = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: size.height + h, end: size.height + h - inDistance)
            .chain(
          CurveTween(
            curve: const Cubic(.32, .62, .06, .95),
          ),
        ),
        weight: fastMoveSeconds,
      ),
      TweenSequenceItem(
        tween: Tween(begin: size.height + h - inDistance, end: inDistance - h),
        weight: 60 - fastMoveSeconds * 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: inDistance - h, end: -h).chain(
          CurveTween(
            curve: const Cubic(.91, .09, .91, .54),
          ),
        ),
        weight: fastMoveSeconds,
      ),
    ]);
  }

  double get movementY => yMovementSequence.transform(_minuteProgress);

  static const barPaddingFactor = .08,
      waveSpeed = 12,
      widthToWaveLengthRatio = 5 / 2,
      widthToWaveHeightRatio = 12 / 1;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Draw the time before clipping as it is out of the clipping
    // area.
    _timePainter.paint(canvas, Offset.zero);

    final width = _amPmPainter.size.width;

    // Need to clip because the moving element can be out of view.
    // Additionally, parts of the wave can be out of view, which is
    // necessary to draw the curves properly.
    canvas.clipRect(
      Rect.fromLTWH(
        _timePainter.width + (_use24HourFormat ? width * barPaddingFactor : 0),
        0,
        width - (_use24HourFormat ? width * barPaddingFactor * 2 : 0),
        size.height,
      ),
    );

    if (_use24HourFormat) {
      final start = _timePainter.width + width * barPaddingFactor,
          path = Path()..moveTo(start, movementY),
          // Want to have a constant spend, hence,
          // using the minute progress.
          waveProgress = (_minuteProgress * waveSpeed) % 1;

      final waveLength = width / widthToWaveLengthRatio, minX = -waveLength;

      for (var i = 0; i < (width - minX) / waveLength + 1; i++) {
        final x = minX + (i + waveProgress * 2) * waveLength;
        path.quadraticBezierTo(
          start + x - waveLength / 2,
          movementY + width / widthToWaveHeightRatio * (i % 2 == 0 ? -1 : 1),
          start + x,
          movementY,
        );
      }

      final end = _timePainter.width + width * (1 - barPaddingFactor);

      path
        ..lineTo(end, movementY)
        ..lineTo(end, size.height)
        ..lineTo(start, size.height)
        ..close();

      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = _textColor
            ..strokeWidth = size.height / 26);
    } else {
      _amPmPainter.paint(canvas,
          Offset(_timePainter.width, movementY - _amPmPainter.height / 2));
    }

    canvas.restore();
  }
}
