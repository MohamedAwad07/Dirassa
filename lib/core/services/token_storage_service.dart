import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _tokenTimestampKey = 'auth_token_timestamp';
  static const int _tokenExpirationDays = 3;

  // ANSI color codes for colored logs
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _reset = '\x1B[0m';

  /// Save token with timestamp
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(
        _tokenTimestampKey,
        DateTime.now().toIso8601String(),
      );
      log('$_green✅ Token saved: $token$_reset');
    } catch (e) {
      log('$_red❌ Error saving token: $e$_reset');
    }
  }

  /// Get cached token if it's still valid (not expired)
  static Future<String?> getValidToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final timestampString = prefs.getString(_tokenTimestampKey);

      if (token == null || timestampString == null) {
        log('$_yellow⚠️ No token found$_reset');
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      final difference = now.difference(timestamp).inDays;

      // Check if token is expired (more than 3 days old)
      if (difference >= _tokenExpirationDays) {
        // Token expired, clear it
        await clearToken();
        log(
          '$_red⏰ Token expired ($difference days old), clearing token$_reset',
        );
        return null;
      }

      log(
        '$_green🔑 Token is valid: ${token.substring(0, token.length > 10 ? 10 : token.length)}...$_reset',
      );
      return token;
    } catch (e) {
      // If there's an error parsing, clear the token
      await clearToken();
      log('$_red💥 Error parsing token, clearing token: $e$_reset');
      return null;
    }
  }

  /// Check if token exists and is valid
  static Future<bool> hasValidToken() async {
    final token = await getValidToken();
    final hasToken = token != null && token.isNotEmpty;
    log(
      '${hasToken ? _green : _red}${hasToken ? '✅' : '❌'} Token exists: $hasToken$_reset',
    );
    return hasToken;
  }

  /// Clear stored token
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_tokenTimestampKey);
      log('$_blue🗑️ Token cleared successfully$_reset');
    } catch (e) {
      log('$_red❌ Error clearing token: $e$_reset');
    }
  }

  /// Get token expiration date
  static Future<DateTime?> getTokenExpirationDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampString = prefs.getString(_tokenTimestampKey);

      if (timestampString == null) {
        log('$_yellow⚠️ No timestamp found$_reset');
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final expirationDate = timestamp.add(
        const Duration(days: _tokenExpirationDays),
      );
      log('$_cyan📅 Token expiration date: $expirationDate$_reset');
      return expirationDate;
    } catch (e) {
      log('$_red❌ Error getting token expiration date: $e$_reset');
      return null;
    }
  }

  /// Get remaining days until token expires
  static Future<int?> getRemainingDays() async {
    try {
      final expirationDate = await getTokenExpirationDate();
      if (expirationDate == null) {
        log('$_yellow⚠️ No expiration date found$_reset');
        return null;
      }

      final now = DateTime.now();
      final difference = expirationDate.difference(now).inDays;
      final remainingDays = difference > 0 ? difference : 0;

      if (remainingDays > 0) {
        log('$_green⏳ Remaining days: $remainingDays$_reset');
      } else {
        log('$_red⏰ Token expired!$_reset');
      }

      return remainingDays;
    } catch (e) {
      log('$_red❌ Error getting remaining days: $e$_reset');
      return null;
    }
  }

  /// Log all token information for debugging
  static Future<void> logTokenInfo() async {
    try {
      log('$_cyan🔍 === TOKEN DEBUG INFO ===$_reset');

      final hasToken = await hasValidToken();
      log('$_cyan🔍 Has valid token: $hasToken$_reset');

      if (hasToken) {
        final token = await getValidToken();
        final expirationDate = await getTokenExpirationDate();
        final remainingDays = await getRemainingDays();

        log(
          '$_cyan🔍 Token: ${token?.substring(0, token.length > 10 ? 10 : token.length)}...$_reset',
        );
        log('$_cyan🔍 Expiration date: $expirationDate$_reset');
        log('$_cyan🔍 Remaining days: $remainingDays$_reset');
      }

      log('$_cyan🔍 === END TOKEN DEBUG ===$_reset');
    } catch (e) {
      log('$_red❌ Error logging token info: $e$_reset');
    }
  }
}
