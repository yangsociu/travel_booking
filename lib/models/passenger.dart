import 'package:equatable/equatable.dart';

class Passenger extends Equatable {
  final String firstName;
  final String lastName;
  final String idNumber;
  final int birthYear;
  final String gender;
  final String phoneNumber;
  final String email;

  const Passenger({
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.birthYear,
    required this.gender,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'idNumber': idNumber,
    'birthYear': birthYear,
    'gender': gender,
    'phoneNumber': phoneNumber,
    'email': email,
  };

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    idNumber: json['idNumber'] as String,
    birthYear: json['birthYear'] as int,
    gender: json['gender'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String,
  );

  @override
  List<Object> get props => [
    firstName,
    lastName,
    idNumber,
    birthYear,
    gender,
    phoneNumber,
    email,
  ];
}
