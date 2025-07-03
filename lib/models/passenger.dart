import 'package:equatable/equatable.dart';

class Passenger extends Equatable {
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? gender;
  final int? birthYear;

  const Passenger({
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.gender,
    this.birthYear,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    email: json['email']?.toString() ?? 'unknown@example.com',
    fullName: json['fullName']?.toString() ?? 'Unknown',
    phoneNumber: json['phoneNumber']?.toString(),
    gender: json['gender']?.toString(),
    birthYear:
        json['birthYear'] is int
            ? json['birthYear'] as int
            : int.tryParse(json['birthYear']?.toString() ?? ''),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'fullName': fullName,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (gender != null) 'gender': gender,
    if (birthYear != null) 'birthYear': birthYear,
  };

  @override
  List<Object?> get props => [email, fullName, phoneNumber, gender, birthYear];
}
