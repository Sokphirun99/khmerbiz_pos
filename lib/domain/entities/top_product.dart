import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

class TopProduct extends Equatable {

  const TopProduct({
    required this.product,
    required this.quantitySold,
    required this.totalRevenue,
  });
  final Product product;
  final double quantitySold;
  final double totalRevenue;

  @override
  List<Object?> get props => [
        product,
        quantitySold,
        totalRevenue,
      ];
}
