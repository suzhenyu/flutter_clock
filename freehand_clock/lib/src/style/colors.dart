import 'package:flutter/material.dart';

Color primaryColor(BuildContext context) {
  final ThemeData theme = Theme.of(context);

  switch (theme.brightness) {
    case Brightness.dark:
      return Colors.white.withOpacity(.8);
    case Brightness.light:
      return Colors.black.withOpacity(.85);
  }
}

Color secondaryColor(BuildContext context) {
  final ThemeData theme = Theme.of(context);

  switch (theme.brightness) {
    case Brightness.dark:
      return Colors.white.withOpacity(.3);
    case Brightness.light:
      return Colors.black.withOpacity(.3);
  }
}

Color backgroundColor(BuildContext context) {
  final ThemeData theme = Theme.of(context);

  switch (theme.brightness) {
    case Brightness.dark:
      return Colors.black;
    case Brightness.light:
      return Colors.white.withOpacity(.9);
  }
}
