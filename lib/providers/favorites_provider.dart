import 'package:flutter/material.dart';

import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<Product> _favorites = {};

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Product p) => _favorites.contains(p);

  void toggle(Product p) {
    if (!_favorites.remove(p)) _favorites.add(p);
    notifyListeners();
  }
}
