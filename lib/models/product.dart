import 'package:flutter/material.dart';

/// Modèle Produit. Le champ [stock] est mutable : il est modifié
/// uniquement par le StockProvider, qui notifie ensuite l'interface.
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    this.stock = 0,
  });

  bool get isOutOfStock => stock == 0;
}
