// lib/services/cart_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _userId => _auth.currentUser?.uid;

  static DocumentReference get _cartDoc =>
      _db.collection('users').doc(_userId).collection('cart').doc('my_cart');

  // حفظ السلة بالكامل
  static Future<void> saveCart(Map<String, int> cart) async {
    if (_userId == null) return;

    final doc = await _cartDoc.get();
    if (!doc.exists) {
      await _cartDoc.set({
        'items': cart,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _cartDoc.update({
        'items': cart,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // إضافة منتج
  static Future<void> addItem(String productId) async {
    if (_userId == null) return;

    final doc = await _cartDoc.get();
    Map<String, int> items = {};

    if (doc.exists) {
      items = Map<String, int>.from(doc.get('items') ?? {});
    }

    items[productId] = (items[productId] ?? 0) + 1;
    await saveCart(items);
  }

  // تقليل الكمية
  static Future<void> decreaseItem(String productId) async {
    if (_userId == null) return;

    final doc = await _cartDoc.get();
    if (!doc.exists) return;

    Map<String, int> items = Map<String, int>.from(doc.get('items') ?? {});

    if (items.containsKey(productId)) {
      if (items[productId]! > 1) {
        items[productId] = items[productId]! - 1;
      } else {
        items.remove(productId);
      }
      await saveCart(items);
    }
  }

  // حذف منتج
  static Future<void> removeItem(String productId) async {
    if (_userId == null) return;

    final doc = await _cartDoc.get();
    if (!doc.exists) return;

    Map<String, int> items = Map<String, int>.from(doc.get('items') ?? {});
    items.remove(productId);
    await saveCart(items);
  }

  // الاستماع للسلة (real-time + offline)
  static Stream<Map<String, int>> streamCart() {
    if (_userId == null) return Stream.value({});

    return _cartDoc.snapshots().map((doc) {
      if (doc.exists) {
        return Map<String, int>.from(doc.get('items') ?? {});
      }
      return {};
    });
  }

  // تفريغ السلة بعد الشراء
  static Future<void> clearCart() async {
    if (_userId == null) return;
    await _cartDoc
        .set({'items': {}, 'updatedAt': FieldValue.serverTimestamp()});
  }
}
