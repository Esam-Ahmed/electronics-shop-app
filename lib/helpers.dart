
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

Future<bool?> showLoginDialog(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }

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

  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return result == true;
}
