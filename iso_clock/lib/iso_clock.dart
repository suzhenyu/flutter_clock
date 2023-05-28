import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:iso_clock/digit_data.dart';

enum _Element {
  background,
  gradientLighter,
  gradientDarker,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.gradientLighter: [Colors.lightBlue[600]!, Colors.cyan[100]!],
  _Element.gradientDarker: [Colors.lightBlue[300]!, Colors.cyan[100]!],
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.gradientLighter: [Colors.grey[500]!, Colors.grey[900]!],
  _Element.gradientDarker: [Colors.grey[700]!, Colors.grey[900]!],
};

const double _digitWidth = 70.0;
const double _digitHeight = 110.0;

var _currentTheme = _lightTheme;

class IsoClock extends StatefulWidget {
  const IsoClock(this.model, {super.key});

  final ClockModel model;

  @override
  State<IsoClock> createState() => _IsoClockState();
}

class _IsoClockState extends State<IsoClock> {
  var _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(IsoClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  _firstDigit(int n) {
    if (n <= 9) {
      return 0;
    } else {
      return int.parse(n.toString().substring(0, 1));
    }
  }

  _secondDigit(int n) {
    if (n <= 9) {
      return n;
    } else {
      return int.parse(n.toString().substring(1, 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    // set theme so it can be accessed by all children widgets
    _currentTheme = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour = int.parse(DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
        .format(_dateTime));
    final minute = int.parse(DateFormat('mm').format(_dateTime));

    return Scaffold(
      backgroundColor: _currentTheme[_Element.background] as Color,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            Digit(time: _firstDigit(hour), delay: 360),
            Digit(time: _secondDigit(hour), delay: 240),
            const Colon(),
            Digit(time: _firstDigit(minute), delay: 120),
            Digit(time: _secondDigit(minute), delay: 0),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

/// Digit
/// ├── DigitFacade
/// |   ├── ThreeDimensionalHole
/// |   └── ThreeDimensionalBox
/// └── AntiAliasPerimeterPadding

class Digit extends StatelessWidget {
  final int time;
  final int delay;

  const Digit({
    super.key,
    required this.time,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.skewX(-0.2),
        child: Container(
          width: _digitWidth,
          height: _digitHeight,
          color: _currentTheme[_Element.background] as Color,
          child: Stack(
            children: [
              DigitFacade(time: time, delay: delay),
              const AntiAliasPerimeterPadding(),
            ],
          ),
        ),
      ),
    );
  }
}

/// DigitFacade contains the Digit's backdrop, ThreeDimensionalHole,
/// and animations for ThreeDimensionalBox.
/// See README for explanation of anti-aliasing work around
class DigitFacade extends StatefulWidget {
  final int time;
  final int delay;

  const DigitFacade({
    super.key,
    required this.time,
    required this.delay,
  });
  @override
  State<DigitFacade> createState() => _DigitFacadeState();
}

class _DigitFacadeState extends State<DigitFacade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late int _currentTime;
  bool _box1First = true;

  final Interval _quickerCurve =
      const Interval(0.05, 1, curve: Curves.easeInOutQuad);
  final Interval _slowerCurve =
      const Interval(0.15, 1, curve: Curves.easeInOutQuad);

  final List<DigitData> _digits = ListOfDigitData().digits;

  // Box One
  _animationStateBox1(time) {
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          _digits[time].box1LTWH[0], _digits[time].box1LTWH[1], 0.0, 0.0),
      end: RelativeRect.fromLTRB(_digits[time].box1LTWH[0] + 120.0,
          _digits[time].box1LTWH[1] + 120.0, 0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: _box1First ? _quickerCurve : _slowerCurve,
    ));
  }

  // Box Two
  _animationStateBox2(time) {
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          _digits[time].box2LTWH[0], _digits[time].box2LTWH[1], 0.0, 0.0),
      end: RelativeRect.fromLTRB(_digits[time].box2LTWH[0] + 120.0,
          _digits[time].box2LTWH[1] + 120.0, 0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: _box1First ? _slowerCurve : _quickerCurve,
    ));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _currentTime = widget.time;
  }

  @override
  void didUpdateWidget(DigitFacade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.time != oldWidget.time) {
      // Recess the Boxes currently in view
      Future.delayed(Duration(milliseconds: widget.delay), () {
        setState(() {
          _controller.forward();
          _currentTime == 1 ? _box1First = false : _box1First = true;
        });
      });
      // Bring new Boxes into view
      Future.delayed(Duration(milliseconds: 600 + widget.delay), () {
        setState(() {
          _currentTime = widget.time;
          _controller.reverse();
          _currentTime == 1 ? _box1First = true : _box1First = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _digitWidth - 1,
        height: _digitHeight - 1,
        child: ClipRect(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const ThreeDimensionalHole(),
              PositionedTransition(
                rect: _animationStateBox1(_currentTime),
                child:
                    ThreeDimensionalBox(ltwh: _digits[_currentTime].box1LTWH),
              ),
              if (_digits[_currentTime].hasTwo)
                PositionedTransition(
                  rect: _animationStateBox2(_currentTime),
                  child:
                      ThreeDimensionalBox(ltwh: _digits[_currentTime].box2LTWH),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreeDimensionalHole extends StatelessWidget {
  const ThreeDimensionalHole({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: _currentTheme[_Element.gradientDarker] as List<Color>,
        ),
      ),
      child: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Transform(
          alignment: FractionalOffset.topLeft,
          transform: Matrix4.skewX(0.7),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _currentTheme[_Element.gradientLighter] as List<Color>,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThreeDimensionalBox extends StatelessWidget {
  /// ltwh: left, top, width, height of Box in relation
  /// to top left corner of parent container DigitFacade
  final List ltwh;
  const ThreeDimensionalBox({
    super.key,
    required this.ltwh,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Main Face
        Container(
          width: ltwh[2],
          height: ltwh[3],
          color: _currentTheme[_Element.background] as Color,
        ),

        // Right Face
        Padding(
          padding: EdgeInsets.only(left: ltwh[2]),
          child: Transform(
            alignment: FractionalOffset.topLeft,
            transform: Matrix4.skewY(0.9),
            child: Container(
              width: 80.0, // grows down
              height: ltwh[3],
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _currentTheme[_Element.gradientDarker] as List<Color>,
                ),
              ),
            ),
          ),
        ),

        // Bottom Face
        Padding(
          padding: EdgeInsets.only(top: ltwh[3]),
          child: Transform(
            alignment: FractionalOffset.topLeft,
            transform: Matrix4.skewX(0.7), // skew will not go out of y bounds
            child: Container(
              width: ltwh[2],
              height: 80.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      _currentTheme[_Element.gradientLighter] as List<Color>,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Perimeter padding is an inset "border" used to cover the scaled
/// down DigitFacade's edges that contain anti-aliasing artifacts
class AntiAliasPerimeterPadding extends StatelessWidget {
  const AntiAliasPerimeterPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _aliasBumperLR(),
            _aliasBumperLR(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _aliasBumperTB(),
            _aliasBumperTB(),
          ],
        ),
      ],
    );
  }

  Widget _aliasBumperLR() {
    return Container(
      width: 1,
      color: _currentTheme[_Element.background] as Color,
    );
  }

  Widget _aliasBumperTB() {
    return Container(
      height: 1,
      color: _currentTheme[_Element.background] as Color,
    );
  }
}

class Colon extends StatelessWidget {
  const Colon({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.skewX(-0.2),
      child: SizedBox(
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SizedBox(
              height: 15,
              width: 15,
              child: ThreeDimensionalHole(),
            ),
            SizedBox(
              height: 15,
              width: 15,
              child: ThreeDimensionalHole(),
            ),
          ],
        ),
      ),
    );
  }
}
