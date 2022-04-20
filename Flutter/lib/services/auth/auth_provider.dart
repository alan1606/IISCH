import 'package:flutter/material.dart';
import 'package:evaluaciones_web/services/auth/auth.dart';

class ProviderLogin extends InheritedWidget {
  final AuthService auth;

  const ProviderLogin({Key ? key, required Widget child, required this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ProviderLogin? of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ProviderLogin>());
}