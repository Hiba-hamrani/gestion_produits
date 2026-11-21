import '../models/product.dart';

/// Exercice avancé : valeur calculée par un ProxyProvider à partir de
/// ProductsProvider et StockProvider. Elle est recalculée à chaque
/// notifyListeners() de l'un des deux.
class StockSummary {
  final int totalUnits;
  final int outOfStockCount;

  const StockSummary(this.totalUnits, this.outOfStockCount);

  factory StockSummary.from(List<Product> products) => StockSummary(
        products.fold(0, (sum, p) => sum + p.stock),
        products.where((p) => p.isOutOfStock).length,
      );
}
