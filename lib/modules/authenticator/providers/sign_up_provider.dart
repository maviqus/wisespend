import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wise_spend_app/data/services/api_token_service.dart'; // Import ApiTokenService
import 'package:wise_spend_app/modules/authenticator/services/sign_in_service.dart'; // Import SignInService

class SignUpProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiTokenService apiTokenService = ApiTokenService(
    baseUrl: 'https://us-central1-wisespend-ae50c.cloudfunctions.net',
  );
  final SignInService signInService = SignInService();

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user with email ,password
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      if (userCredential.user != null) {
        // custom token
        final String? customToken = await apiTokenService.getCustomToken(
          userCredential.user!.uid,
        );

        if (customToken != null) {
          // 3. Sign in  custom token
          await signInService.signInWithCustomToken(customToken);
        } else {
          _errorMessage = 'Dang nhap khong thanh cong';
        }
      } else {
        _errorMessage = ' Loi dang nhap';
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      print('Failed with error code: ${e.code}');
      print(e.message);
    } catch (e) {
      _errorMessage = e.toString();
      print('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
