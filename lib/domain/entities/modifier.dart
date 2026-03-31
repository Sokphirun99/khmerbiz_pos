import 'package:equatable/equatable.dart';

/// Represents an optional modification to a product (e.g., "Extra shot", "Less sugar").
class Modifier extends Equatable {
  /// Creates a [Modifier] with a [name] and optional [price].
  const Modifier({
    required this.name,
    this.price = 0,
  });

  /// Factory constructor to create a [Modifier] from JSON.
  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Display name of the modifier.
  final String name;

  /// Additional cost for this modifier (in KHR).
  final double price;

  /// Converts this [Modifier] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [name, price];
}
