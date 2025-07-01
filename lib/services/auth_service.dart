// auth_service.dart
// auth_service.dart
// Dịch vụ xác thực với Firebase
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception('Đăng nhập thất bại: Không tìm thấy người dùng');
      }
    } catch (e) {
      throw Exception('Đăng nhập thất bại: $e');
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception('Đăng ký thất bại: Không tạo được người dùng');
      }
    } catch (e) {
      throw Exception('Đăng ký thất bại: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
