import 'package:equatable/equatable.dart';

class Modifier extends Equatable {
  final String name;
  final double price;

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [name, price];
}
