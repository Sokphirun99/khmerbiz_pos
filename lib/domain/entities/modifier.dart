import 'package:equatable/equatable.dart';

class Modifier extends Equatable {

  const Modifier({
    required this.name,
    this.price = 0,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }
  final String name;
  final double price;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [name, price];
}
