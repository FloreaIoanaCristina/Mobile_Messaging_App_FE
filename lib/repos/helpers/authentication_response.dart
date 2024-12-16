// Authentication response model
class AuthenticationResponse {
  final String token;
  final DateTime expiration;

  AuthenticationResponse({required this.token, required this.expiration});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}