import 'package:firebase_auth/firebase_auth.dart';

class SignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithCustomToken(String token) async {
    try {
      UserCredential userCredential = await _auth.signInWithCustomToken(token);
      return userCredential;
    } catch (e, stack) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
