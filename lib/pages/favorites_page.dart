import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/stock_widgets.dart';
import 'details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: favorites.isEmpty
          ? const Center(child: Text('Aucun favori'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, i) {
                final p = favorites[i];
                return ListTile(
                  leading: Icon(p.icon),
                  title: Text(p.name),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: StockBadge(p),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        context.read<FavoritesProvider>().toggle(p),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailsPage(product: p)),
                  ),
                );
              },
            ),
    );
  }
}
