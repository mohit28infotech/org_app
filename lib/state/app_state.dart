import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppState extends ValueNotifier<bool> {
  AppState() : super(false);

  void toggle() => value = !value;
  notifyListeners();
}
