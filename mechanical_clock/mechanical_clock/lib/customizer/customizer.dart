import 'package:mechanical_clock/clock.dart';
import 'package:mechanical_clock/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

export 'automatic.dart';
export 'manual.dart';

typedef ClockModelBuilder = Widget Function(
    BuildContext context, ClockModel model);

/// Customization flows control the behavior of the clock.
///
/// The selected mode is determined by the [customizationFlowMode]
/// constants.
enum CustomizationFlow {
  manual,
  automatic,
}

class Customizer extends StatelessWidget {
  final ClockModelBuilder builder;

  final CustomizationFlow mode;

  /// Inserts a [SemanticsDebugger] when `true`.
  ///
  /// It does not matter where the debugger is inserted.
  /// It will always show semantics information for the parent
  /// widgets as well. Thus, it is fine to wrap the customizers
  /// in the debugger.
  final bool debugSemantics;

  const Customizer({
    super.key,
    required this.mode,
    this.debugSemantics = false,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (mode == CustomizationFlow.automatic) {
      result = AutomatedCustomizer(builder: builder);
    } else {
      result = ManualCustomizer(builder: builder);
    }

    if (debugSemantics) {
      result = SemanticsDebugger(child: result);
    }

    return result;
  }
}
