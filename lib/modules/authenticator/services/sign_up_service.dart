import 'package:firebase_auth/firebase_auth.dart';

class SignUpService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error signing up: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}
