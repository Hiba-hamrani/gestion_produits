import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/stock_summary.dart';

void main() => runApp(const AppRoot());

/// Étape 3 : MultiProvider enveloppe MaterialApp.
/// Tous les écrans (y compris ceux ouverts avec Navigator.push)
/// ont donc accès aux mêmes instances de providers.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        // StockProvider travaille sur la même liste de produits.
        ChangeNotifierProvider(
          create: (ctx) =>
              StockProvider(ctx.read<ProductsProvider>().products)..load(),
        ),
        // Exercice avancé : ProxyProvider -> total du stock recalculé
        // automatiquement à chaque changement de stock.
        ProxyProvider2<ProductsProvider, StockProvider, StockSummary>(
          update: (_, products, __, ___) =>
              StockSummary.from(products.products),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Colors.teal;
    return MaterialApp(
      title: 'Gestion de Produits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomePage(),
    );
  }
}
