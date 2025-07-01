// models/destination_model.dart
// Model cho điểm đến
import 'package:equatable/equatable.dart';

class DestinationModel extends Equatable {
  final String name;
  final String price;
  final String description;
  final String image;

  const DestinationModel({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      name: json['name'] as String,
      price: json['price'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  @override
  List<Object> get props => [name, price, description, image];
}
