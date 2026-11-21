import 'package:flutter/material.dart';

import '../models/product.dart';

/// Source unique de la liste des produits + filtre "rupture de stock".
class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: 1, name: 'Ordinateur portable', description: 'PC 15" – 16 Go RAM, SSD 512 Go.', price: 7990, icon: Icons.laptop, stock: 5),
    Product(id: 2, name: 'Smartphone', description: 'Écran 6,5", 128 Go, double SIM.', price: 3490, icon: Icons.smartphone, stock: 8),
    Product(id: 3, name: 'Casque audio', description: 'Bluetooth, réduction de bruit active.', price: 899, icon: Icons.headphones, stock: 0),
    Product(id: 4, name: 'Montre connectée', description: 'Suivi d\'activité et notifications.', price: 1290, icon: Icons.watch, stock: 3),
    Product(id: 5, name: 'Clavier mécanique', description: 'Switchs rouges, rétroéclairage RGB.', price: 650, icon: Icons.keyboard, stock: 12),
    Product(id: 6, name: 'Souris sans fil', description: 'Ergonomique, 6 boutons.', price: 249, icon: Icons.mouse, stock: 1),
  ];

  bool _onlyOutOfStock = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get onlyOutOfStock => _onlyOutOfStock;

  /// Exercice avancé : filtre des produits en rupture de stock.
  List<Product> get visibleProducts => _onlyOutOfStock
      ? _products.where((p) => p.isOutOfStock).toList()
      : List.unmodifiable(_products);

  void toggleOutOfStockFilter() {
    _onlyOutOfStock = !_onlyOutOfStock;
    notifyListeners();
  }
}
