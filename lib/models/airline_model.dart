import 'package:equatable/equatable.dart';

class AirlineModel extends Equatable {
  final String id;
  final String name;
  final String? price; // Đổi thành String? để chấp nhận null
  final String? image; // Đổi thành String? để chấp nhận null

  const AirlineModel({
    required this.id,
    required this.name,
    this.price, // Tùy chọn
    this.image, // Tùy chọn
  });

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      id: json['id'] as String? ?? 'UNKNOWN',
      name: json['name'] as String? ?? 'Unknown Airline',
      price: json['price'] as String?, // Chấp nhận null
      image: json['image'] as String?, // Chấp nhận null
    );
  }

  Map<String, dynamic> toJson() {
    final map = {'id': id, 'name': name};
    if (price != null) map['price'] = price!;
    if (image != null) map['image'] = image!;
    return map;
  }

  @override
  List<Object?> get props => [id, name, price, image]; // Object? để xử lý null
}
