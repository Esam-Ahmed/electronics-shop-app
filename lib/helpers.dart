// lib/utils/helpers.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

/// يعرض حوار يطلب من المستخدم تسجيل الدخول عند الحاجة.
/// - يعيد Future<bool?>: true إذا تم تسجيل الدخول بنجاح، false أو null إذا لم يسجل.
Future<bool?> showLoginDialog(BuildContext context) async {
  // إذا المستخدم مسجل بالفعل لا نعرض الحوار
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }

  // أولاً: اسأل المستخدم إذا يريد الانتقال لتسجيل الدخول
  final shouldLogin = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('تسجيل الدخول مطلوب'),
      content: const Text('يجب تسجيل الدخول لإضافة منتجات للسلة والمفضلات'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('لاحقاً'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          child: const Text('تسجيل الدخول'),
        ),
      ],
    ),
  );

  if (shouldLogin != true) return false;

  // افتح شاشة الدخول وانتظر نتيجتها (login screen يجب أن تعيد true عند نجاح الدخول)
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return result == true;
}
