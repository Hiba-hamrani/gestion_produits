# Gestion de Produits – Flutter Provider

TP du module **Développement multiplateforme – Flutter** (EMSI Marrakech, 5ᵉ année 2DSI G3, Pr. H. SBAI).

Migration d'une application de gestion de produits de `setState()` vers **Provider**, avec une gestion réactive du stock.

## Fonctionnalités

- Liste de produits, page de détails, panier et favoris partagés entre toutes les pages
- **Gestion du stock** : boutons +/−, badge « En stock / Stock faible / Rupture de stock »
- Mise à jour automatique du stock dans toutes les pages, y compris le panier (avertissement si la quantité dépasse le stock)
- Persistance du stock avec **SharedPreferences**
- Exercices avancés :
    - badge du panier optimisé avec **Selector**
    - filtre des produits en rupture de stock
    - **ProxyProvider** qui calcule le total du stock et le nombre de produits en rupture

## Architecture

```
lib/
├── main.dart                  # MultiProvider + MaterialApp
├── models/product.dart
├── providers/
│   ├── products_provider.dart
│   ├── cart_provider.dart
│   ├── favorites_provider.dart
│   ├── stock_provider.dart
│   └── stock_summary.dart     # valeur calculée par le ProxyProvider
├── pages/                     # home, details, cart, favorites
└── widgets/                   # StockBadge, StockControl, CartBadge
```

| Provider | Rôle |
|---|---|
| `ProductsProvider` | Liste des produits et filtre « rupture de stock » |
| `CartProvider` | Panier (produit → quantité), total |
| `FavoritesProvider` | Produits favoris |
| `StockProvider` | Incrémenter, décrémenter ou fixer le stock + persistance |

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter analyze   # No issues found!
flutter test      # All tests passed!
```

## Technologies

Flutter 3.47 · Dart 3.13 · provider ^6.1.2 · shared_preferences ^2.3.2

---

Réalisé par **Hamrani Hibatalah** – année universitaire 2026–2027