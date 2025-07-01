// models/airline_model.dart
// Model cho hãng hàng không
import 'package:equatable/equatable.dart';

class AirlineModel extends Equatable {
  final String name;
  final String price;
  final String image;

  const AirlineModel({
    required this.name,
    required this.price,
    required this.image,
  });

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      name: json['name'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'image': image};
  }

  @override
  List<Object> get props => [name, price, image];
}
