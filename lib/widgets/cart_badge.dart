import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page.dart';
import '../providers/cart_provider.dart';

/// Exercice avancé : badge du panier optimisé avec Selector.
/// Selector n'écoute que totalQuantity : le badge ne se reconstruit
/// que si ce nombre change (pas à chaque modification du panier).
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, int>(
      selector: (_, cart) => cart.totalQuantity,
      builder: (context, count, _) => IconButton(
        tooltip: 'Panier',
        icon: Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        ),
      ),
    );
  }
}
