import 'package:firebase_auth/firebase_auth.dart';

class SignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithCustomToken(String token) async {
    try {
      UserCredential userCredential = await _auth.signInWithCustomToken(token);
      print(
        'Sign in with custom token successful: ${userCredential.user?.uid}',
      );
      return userCredential;
    } catch (e, stack) {
      print('Error signing in with custom token: $e');
      print('Stack: $stack');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
