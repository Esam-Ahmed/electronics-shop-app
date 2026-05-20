import 'package:flutter/material.dart';
import '../screens/main_navigation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // نعرض شاشة التنقل الرئيسية دائماً حتى يتمكن الزائر من التصفح.
    return const MainNavigationScreen();
  }
}
