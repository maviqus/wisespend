import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wise_spend_app/data/services/api_token_service.dart'; // Import ApiTokenService
import 'package:wise_spend_app/modules/authenticator/services/sign_in_service.dart'; // Import SignInService

class SignInProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiTokenService apiTokenService = ApiTokenService(
    baseUrl: 'https://us-central1-wisespend-ae50c.cloudfunctions.net',
  );
  final SignInService signInService = SignInService();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Sign in with email
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      if (userCredential.user != null) {
        //  custom token
        final String? customToken = await apiTokenService.getCustomToken(
          userCredential.user!.uid,
        );

        if (customToken != null) {
          // Sign in custom token
          await signInService.signInWithCustomToken(customToken);
        } else {
          _errorMessage = 'Failed to get custom token';
        }
      } else {
        _errorMessage = 'Invalid credentials';
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

  Future<void> signInWithFacebook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        // Sign in  Facebook
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        if (userCredential.user != null) {
          // custom token
          final String? customToken = await apiTokenService.getCustomToken(
            userCredential.user!.uid,
          );

          if (customToken != null) {
            // 3. Sign in custom token
            await signInService.signInWithCustomToken(customToken);
          } else {
            _errorMessage = 'Failed to get custom token';
          }
        } else {
          _errorMessage = 'Facebook sign-in failed';
        }
      } else {
        _errorMessage = result.message ?? 'Facebook sign-in failed';
        print(result.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        if (userCredential.user != null) {
          print('User UID: ${userCredential.user!.uid}');
          final String? customToken = await apiTokenService.getCustomToken(
            userCredential.user!.uid,
          );
          print('Custom token: $customToken');

          if (customToken != null) {
            final UserCredential? result = await signInService
                .signInWithCustomToken(customToken);
            print('Sign in with custom token result: $result');
            if (result == null) {
              _errorMessage = 'Sign in with custom token failed';
            }
          } else {
            _errorMessage = 'Failed to get custom token';
          }
        } else {
          _errorMessage = 'Google sign-in failed';
        }
      } else {
        _errorMessage = 'Google sign-in cancelled';
      }
    } catch (e, stack) {
      _errorMessage = e.toString();
      print('Google sign-in error: $e');
      print('Stack: $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
