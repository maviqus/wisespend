import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordResetCodeProvider extends ChangeNotifier {
  // State
  bool sending = false;
  bool verifying = false;
  String? error;
  bool codeVerified = false;
  String? _email;
  String? _lastCode; // last verified code

  String? get email => _email;
  String? get lastCode => _lastCode;

  // Direct Cloud Run function base URLs (Gen2). Consider moving to env/remote config for flexibility.
  static const String _sendUrlPrimary = 'https://sendresetcodehttp-lkpxiw2z6a-uc.a.run.app';
  static const String _verifyUrlPrimary = 'https://verifyresetcodehttp-lkpxiw2z6a-uc.a.run.app';
  static const String _changeUrlPrimary = 'https://changepasswordwithcodehttp-lkpxiw2z6a-uc.a.run.app';
  // Legacy Firebase domain (often still publicly open even if Cloud Run direct URL locked)
  static const String _legacyBase = 'https://us-central1-wisespend-ae50c.cloudfunctions.net';
  static const String _sendUrlLegacy = '$_legacyBase/sendResetCodeHttp';
  static const String _verifyUrlLegacy = '$_legacyBase/verifyResetCodeHttp';
  static const String _changeUrlLegacy = '$_legacyBase/changePasswordWithCodeHttp';
  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, dynamic>> _postJsonMulti(List<String> urls, Map<String, dynamic> body) async {
    Exception? lastError;
    for (final u in urls) {
      try {
        final resp = await http
            .post(
              Uri.parse(u),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            )
            .timeout(_timeout);
        Map<String, dynamic> decoded = {};
        try { decoded = jsonDecode(resp.body) as Map<String, dynamic>; } catch (_) {}
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          return decoded;
        }
        // If unauthorized (401/403) try next fallback
        if (resp.statusCode == 401 || resp.statusCode == 403) {
          lastError = Exception('Auth ${resp.statusCode} on $u');
          continue; // try next URL
        }
        // Other error -> throw immediately
        throw Exception(decoded['error']?.toString() ?? 'HTTP ${resp.statusCode}');
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
      }
    }
    throw lastError ?? Exception('Request failed');
  }

  Future<bool> sendCode(String email) async {
    sending = true;
    error = null;
    codeVerified = false;
    _email = email.trim().toLowerCase();
    notifyListeners();
    try {
  await _postJsonMulti([
        _sendUrlPrimary,
        _sendUrlLegacy,
      ], {'email': _email});
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  Future<bool> verifyCode(String code) async {
    if (_email == null) return false;
    verifying = true;
    error = null;
    notifyListeners();
    try {
      await _postJsonMulti([
        _verifyUrlPrimary,
        _verifyUrlLegacy,
      ], {
        'email': _email,
        'code': code.trim(),
      });
      codeVerified = true;
      _lastCode = code.trim();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      verifying = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    if (!codeVerified || _email == null || _lastCode == null) {
      error = 'Thiếu thông tin';
      return false;
    }
    error = null;
    try {
      await _postJsonMulti([
        _changeUrlPrimary,
        _changeUrlLegacy,
      ], {
        'email': _email,
        'code': _lastCode,
        'newPassword': newPassword,
      });
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    sending = false;
    verifying = false;
    error = null;
    codeVerified = false;
    _email = null;
    _lastCode = null;
    notifyListeners();
  }
}
