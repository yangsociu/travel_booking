class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String birthDate;
  final String phoneNumber;
  final String gender;
  final String address;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.birthDate,
    required this.phoneNumber,
    required this.gender,
    required this.address,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      birthDate: map['birthDate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'address': address,
    };
  }
}
