import 'package:flutter/material.dart';

import '../models/product.dart';

/// Panier : produit -> quantité commandée.
class CartProvider with ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => Map.unmodifiable(_items);

  /// Nombre total d'articles (utilisé par le badge du panier).
  int get totalQuantity => _items.values.fold(0, (sum, q) => sum + q);

  double get totalPrice =>
      _items.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  int quantityOf(Product p) => _items[p] ?? 0;

  /// Ajoute un exemplaire si le stock le permet. Retourne false sinon.
  bool add(Product p) {
    if (quantityOf(p) >= p.stock) return false;
    _items[p] = quantityOf(p) + 1;
    notifyListeners();
    return true;
  }

  void removeOne(Product p) {
    final q = quantityOf(p);
    if (q <= 1) {
      _items.remove(p);
    } else {
      _items[p] = q - 1;
    }
    notifyListeners();
  }

  void remove(Product p) {
    _items.remove(p);
    notifyListeners();
  }
}
