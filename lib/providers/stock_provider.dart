import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

/// Étape 1 du TP : provider dédié à la gestion du stock.
/// Toute modification appelle notifyListeners() : toutes les pages
/// qui écoutent StockProvider se reconstruisent automatiquement.
class StockProvider with ChangeNotifier {
  StockProvider(this._products);

  final List<Product> _products;

  void increment(Product p) {
    p.stock++;
    _changed();
  }

  void decrement(Product p) {
    if (p.stock > 0) p.stock--;
    _changed();
  }

  void setStock(Product p, int value) {
    p.stock = value < 0 ? 0 : value;
    _changed();
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  // ---------- Étape 5 (facultatif) : persistance SharedPreferences ----------

  static String _key(Product p) => 'stock_${p.id}';

  /// Recharge les stocks sauvegardés au démarrage.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final p in _products) {
      final saved = prefs.getInt(_key(p));
      if (saved != null) p.stock = saved;
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final p in _products) {
      await prefs.setInt(_key(p), p.stock);
    }
  }
}
