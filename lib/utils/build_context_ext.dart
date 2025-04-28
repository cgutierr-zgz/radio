import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  /// Returns the nearest [NavigatorState] instance.
  NavigatorState get navigator => Navigator.of(this);

  /// Pushes a new route onto the navigator stack.
  Future<T?> push<T extends Object?>(Widget page) =>
      navigator.push(MaterialPageRoute<T>(builder: (context) => page));
}
