class User {
  final String userId;
  final String userName;
  final String? profilePicture;

  User({
    required this.userId,
    this.profilePicture,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      profilePicture: json['profilePicture'],
      userName: json ['userName']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profilePicture': profilePicture,
      'userName': userName
    };
  }
}