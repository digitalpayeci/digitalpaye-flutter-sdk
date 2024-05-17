// lib/utils/functions.dart

import 'package:intl/intl.dart';

String formatNumber(int number) {
  final formatter = NumberFormat.decimalPattern('fr');
  return formatter.format(number);
}