import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../providers/stock_provider.dart';
import '../providers/stock_summary.dart';
import '../widgets/cart_badge.dart';
import '../widgets/stock_widgets.dart';
import 'details_page.dart';
import 'favorites_page.dart';

/// Étape 4 : HomePage devient un StatelessWidget qui consomme les providers.
/// Plus aucun setState() ni état local.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProv = context.watch<ProductsProvider>();
    context.watch<StockProvider>(); // la liste filtrée dépend du stock
    final products = productsProv.visibleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Produits'),
        actions: [
          IconButton(
            tooltip: 'Favoris',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
          const CartBadge(),
        ],
      ),
      body: Column(
        children: [
          const _StockSummaryBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Rupture de stock uniquement'),
                selected: productsProv.onlyOutOfStock,
                onSelected: (_) =>
                    context.read<ProductsProvider>().toggleOutOfStockFilter(),
              ),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('Aucun produit à afficher'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (_, i) => ProductCard(products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Résumé calculé par le ProxyProvider (exercice avancé).
class _StockSummaryBar extends StatelessWidget {
  const _StockSummaryBar();

  @override
  Widget build(BuildContext context) {
    final summary = context.watch<StockSummary>();
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Total en stock : ${summary.totalUnits} unités  •  '
        'En rupture : ${summary.outOfStockCount}',
        style: TextStyle(color: cs.onSecondaryContainer),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFav = context.watch<FavoritesProvider>().isFavorite(product);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsPage(product: product)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(product.icon, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis),
                        Text('${product.price.toStringAsFixed(2)} DH'),
                        const SizedBox(height: 4),
                        StockBadge(product),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: cs.error),
                    onPressed: () =>
                        context.read<FavoritesProvider>().toggle(product),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  StockControl(product),
                  const Spacer(),
                  AddToCartButton(product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bouton partagé par HomePage et DetailsPage.
class AddToCartButton extends StatelessWidget {
  const AddToCartButton(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    context.watch<StockProvider>();
    return FilledButton.icon(
      icon: const Icon(Icons.add_shopping_cart),
      label: const Text('Ajouter'),
      onPressed: product.isOutOfStock
          ? null
          : () {
              final ok = context.read<CartProvider>().add(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(ok
                      ? '${product.name} ajouté au panier'
                      : 'Stock insuffisant pour ${product.name}'),
                  duration: const Duration(seconds: 1),
                ));
            },
    );
  }
}
