// lib/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // نعرض شاشة التنقل الرئيسية دائماً حتى يتمكن الزائر من التصفح.
    // التحكم بحظر الوصول للمفضلات/الحساب أو طلب تسجيل الدخول يتم داخل MainNavigationScreen.
    return const MainNavigationScreen();
  }
}