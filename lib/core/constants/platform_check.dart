import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformCheck {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
}
