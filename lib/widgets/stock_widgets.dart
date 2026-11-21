import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/stock_provider.dart';

/// Étiquette d'état du stock (rupture / stock faible / en stock).
/// Elle écoute StockProvider : seule elle se reconstruit quand le stock change.
class StockBadge extends StatelessWidget {
  const StockBadge(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    context.watch<StockProvider>();
    final cs = Theme.of(context).colorScheme;
    final stock = product.stock;

    final (String label, Color bg, Color fg) = switch (stock) {
      0 => ('Rupture de stock', cs.errorContainer, cs.onErrorContainer),
      <= 2 => ('Stock faible : $stock', cs.tertiaryContainer, cs.onTertiaryContainer),
      _ => ('En stock : $stock', cs.primaryContainer, cs.onPrimaryContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}

/// Étape 3 : boutons - / + pour ajuster la quantité en stock.
/// context.read() pour l'action (pas d'écoute), context.watch() pour l'affichage.
class StockControl extends StatelessWidget {
  const StockControl(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    context.watch<StockProvider>();
    final stock = context.read<StockProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          key: ValueKey('dec_${product.id}'),
          icon: const Icon(Icons.remove),
          onPressed: product.stock > 0 ? () => stock.decrement(product) : null,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '${product.stock}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton.outlined(
          key: ValueKey('inc_${product.id}'),
          icon: const Icon(Icons.add),
          onPressed: () => stock.increment(product),
        ),
      ],
    );
  }
}
