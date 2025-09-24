import 'package:jwt_decoder/jwt_decoder.dart';

class JWTDecoder {
  static bool isValid(String token) {
    if (token.isEmpty) return false;
    return !JwtDecoder.isExpired(token);
  }

  static Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }

  static DateTime? getExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }
}
