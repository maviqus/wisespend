import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_spend_app/core/const/key_share_pref.dart';

class SignInProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get errorMessage => _errorMessage;

  // Add this method to reset the provider state
  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  bool get isSignedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // First ensure we're starting with a clean slate
      // Check if there's any existing user and sign them out
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      // Now proceed with sign in
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      if (userCredential.user != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KeySharePref.keyTokenUser, "dummy_token");
        await prefs.setString(
          KeySharePref.keyUserId,
          userCredential.user!.uid,
        );
      } else {
        _errorMessage = 'Đăng nhập thất bại';
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
}
            userCredential.user!.uid,
          );
        } else {
          _errorMessage = 'Failed to get custom token';
        }
      } else {
        _errorMessage = 'Invalid credentials';
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
}
