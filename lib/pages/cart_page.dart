import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_widgets.dart';

/// Étape 4 du TP : le panier affiche le stock en temps réel.
/// Consumer2 écoute CartProvider ET StockProvider.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon panier')),
      body: Consumer2<CartProvider, StockProvider>(
        builder: (context, cart, _, __) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Votre panier est vide'));
          }
          final cs = Theme.of(context).colorScheme;
          final entries = cart.items.entries.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (_, i) {
                    final p = entries[i].key;
                    final qty = entries[i].value;
                    final tooMany = qty > p.stock;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(p.icon, color: cs.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, overflow: TextOverflow.ellipsis),
                                  Text('${(p.price * qty).toStringAsFixed(2)} DH'),
                                  const SizedBox(height: 4),
                                  StockBadge(p),
                                  if (tooMany)
                                    Text('Quantité > stock disponible',
                                        style: TextStyle(color: cs.error, fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => cart.removeOne(p),
                            ),
                            Text('$qty'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: qty < p.stock ? () => cart.add(p) : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: cs.surfaceContainerHighest,
                child: Text(
                  'Total : ${cart.totalPrice.toStringAsFixed(2)} DH '
                  '(${cart.totalQuantity} articles)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
