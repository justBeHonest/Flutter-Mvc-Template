// Flutter imports:
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;
  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;
  double get w => MediaQuery.of(this).size.width;
  double get h => MediaQuery.of(this).size.height;
}
