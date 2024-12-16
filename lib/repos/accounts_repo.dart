import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'helpers/authentication_response.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  // Register a new user
  Future<AuthenticationResponse> registerUser(String username,String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/accounts/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': username,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return AuthenticationResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // Login a user
  // Secure storage instance
  final _secureStorage = const FlutterSecureStorage();

  // Login method
  Future<AuthenticationResponse> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/accounts/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Parse response into AuthenticationResponse object
      final authResponse = AuthenticationResponse.fromJson(jsonResponse);

      // Store JWT token securely
      await _secureStorage.write(key: 'jwt', value: authResponse.token);

      return authResponse;
    } else {
      throw Exception('Failed to log in: ${response.body}');
    }
  }

  // Retrieve the JWT token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt');
  }
  Future<String?> getUserNameFromClaims() async {
    try {
      // Retrieve the token
      String? token = await getToken();

      if (token == null) {
        print("Token not found in secure storage.");
        return null;
      }

      // Decode the JWT to get claims
      Map<String, dynamic> decodedClaims = JwtDecoder.decode(token);

      // Extract the "Name" claim
      String? userName = decodedClaims['Name'];

      return userName;
    } catch (e) {
      print("Error retrieving userName from claims: $e");
      return null;
    }
  }

  Future<String?> getIdFromClaims() async {
    try {
      // Retrieve the token
      String? token = await getToken();

      if (token == null) {
        print("Token not found in secure storage.");
        return null;
      }

      // Decode the JWT to get claims
      Map<String, dynamic> decodedClaims = JwtDecoder.decode(token);

      // Extract the "UserId" claim
      String? userId = decodedClaims['Id'];

      return userId;
    } catch (e) {
      print("Error retrieving UserId from claims: $e");
      return null;
    }
  }

  // Clear the JWT token from secure storage (logout use-case)
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'jwt');
  }
}


