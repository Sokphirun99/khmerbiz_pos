import 'package:equatable/equatable.dart';
import 'product.dart';

class TopProduct extends Equatable {
  final Product product;
  final double quantitySold;
  final double totalRevenue;

  const TopProduct({
    required this.product,
    required this.quantitySold,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [
        product,
        quantitySold,
        totalRevenue,
      ];
}
