import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product.dart';
import 'favorite_service.dart';
import 'cart_service.dart';

class StoreProvider with ChangeNotifier {
  List<Product> _products = [];
  Map<String, int> _cart = {};
  Set<String> _favorites = {};
  bool _isLoading = true;

  StoreProvider() {
    _init();
  }

  void _init() {
    _listenToProducts();
    _listenToFavorites();
    _listenToCart();
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  void _listenToProducts() {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          title: data['title'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          isFavorite: _favorites.contains(doc.id),
        );
      }).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _listenToFavorites() {
    FavoriteService.stream().listen((favorites) {
      _favorites = favorites;
      for (var product in _products) {
        product.isFavorite = _favorites.contains(product.id);
      }
      notifyListeners();
    });
  }

  void _listenToCart() {
    CartService.streamCart().listen((cart) {
      _cart = cart;
      notifyListeners();
    });
  }

  // Getters
  List<Product> get products => _products;
  Map<String, int> get cart => _cart;
  bool get isLoading => _isLoading;

  List<Product> get favoriteProducts =>
      _products.where((p) => _favorites.contains(p.id)).toList();

  int get cartCount => _cart.values.fold(0, (sum, q) => sum + q);

  List<String> get categories =>
      _products.map((p) => p.category).toSet().toList();

  double get totalBill {
    return _cart.entries.fold(0.0, (sum, entry) {
      final product = _products.firstWhere((p) => p.id == entry.key);
      return sum + (product.price * entry.value);
    });
  }

  Future<bool> addToCart(String id) async {
    if (!isLoggedIn) return false;
    await CartService.addItem(id);
    return true;
  }

  Future<bool> decreaseCartQuantity(String id) async {
    if (!isLoggedIn) return false;
    await CartService.decreaseItem(id);
    return true;
  }

  Future<bool> removeFromCart(String id) async {
    if (!isLoggedIn) return false;
    await CartService.removeItem(id);
    return true;
  }

  Future<bool> clearCart() async {
    if (!isLoggedIn) return false;
    await CartService.clearCart();
    return true;
  }

  Future<bool> toggleFav(String id) async {
    if (!isLoggedIn) return false;
    await FavoriteService.toggle(id);
    return true;
  }
}
