import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/cart_badge.dart';
import '../widgets/stock_widgets.dart';
import 'home_page.dart';

/// Étape 5 : DetailsPage lit les mêmes providers que HomePage.
/// Un changement de stock ici est visible immédiatement au retour.
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isFav = context.watch<FavoritesProvider>().isFavorite(product);
    final inCart = context.watch<CartProvider>().quantityOf(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () => context.read<FavoritesProvider>().toggle(product),
          ),
          const CartBadge(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: cs.primaryContainer,
                child: Icon(product.icon, size: 60, color: cs.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 20),
            Text(product.name, style: text.headlineSmall),
            const SizedBox(height: 4),
            Text('${product.price.toStringAsFixed(2)} DH',
                style: text.titleLarge?.copyWith(color: cs.primary)),
            const SizedBox(height: 12),
            Text(product.description, style: text.bodyLarge),
            const SizedBox(height: 20),
            StockBadge(product),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Ajuster le stock :', style: text.titleMedium),
                const Spacer(),
                StockControl(product),
              ],
            ),
            const Divider(height: 32),
            Text('Dans le panier : $inCart', style: text.titleMedium),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: AddToCartButton(product)),
          ],
        ),
      ),
    );
  }
}
