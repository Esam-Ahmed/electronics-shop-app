
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _userId => _auth.currentUser?.uid;

  static DocumentReference get _favoritesDoc => _db
      .collection('users')
      .doc(_userId)
      .collection('favorites')
      .doc('my_favorites');

  static Future<void> add(String productId) async {
    final doc = await _favoritesDoc.get();
    if (!doc.exists) {
      await _favoritesDoc.set({
        'productIds': [productId]
      });
    } else {
      await _favoritesDoc.update({
        'productIds': FieldValue.arrayUnion([productId])
      });
    }
  }

  static Future<void> remove(String productId) async {
    await _favoritesDoc.update({
      'productIds': FieldValue.arrayRemove([productId])
    });
  }

  static Stream<Set<String>> stream() {
    if (_userId == null) return Stream.value({});
    return _favoritesDoc.snapshots().map((doc) {
      if (doc.exists) {
        List<String> list = List<String>.from(doc.get('productIds') ?? []);
        return list.toSet();
      }
      return {};
    });
  }

  static Future<void> toggle(String productId) async {
    final favorites = await stream().first;
    if (favorites.contains(productId)) {
      await remove(productId);
    } else {
      await add(productId);
    }
  }
}
