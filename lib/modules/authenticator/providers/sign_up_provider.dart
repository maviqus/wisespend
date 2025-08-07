import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class SignUpProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
        final userInfo = {
          "displayName": userCredential.user!.displayName,
          "email": userCredential.user!.email,
        };
        await FirebaseService.createUser(userCredential.user!.uid, userInfo);
      } else {
        _errorMessage = 'Lỗi đăng ký';
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(BuildContext context) async {}
}
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(BuildContext context) async {}
}
