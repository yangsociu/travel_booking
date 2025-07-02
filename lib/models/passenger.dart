import 'package:equatable/equatable.dart';

class Passenger extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? gender;
  final int? birthYear;
  final String? idNumber;

  const Passenger({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.gender,
    this.birthYear,
    this.idNumber,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    email: json['email']?.toString() ?? 'unknown@example.com',
    firstName: json['firstName']?.toString() ?? 'Unknown',
    lastName: json['lastName']?.toString() ?? 'Unknown',
    phoneNumber: json['phoneNumber']?.toString(),
    gender: json['gender']?.toString(),
    birthYear:
        json['birthYear'] is int
            ? json['birthYear'] as int
            : int.tryParse(json['birthYear']?.toString() ?? ''),
    idNumber: json['idNumber']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (gender != null) 'gender': gender,
    if (birthYear != null) 'birthYear': birthYear,
    if (idNumber != null) 'idNumber': idNumber,
  };

  @override
  List<Object?> get props => [
    email,
    firstName,
    lastName,
    phoneNumber,
    gender,
    birthYear,
    idNumber,
  ];
}
