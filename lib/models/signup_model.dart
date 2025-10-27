class SignupModel {
  final String username;
  final String email;
  final String password;
  final String cnfPassword;

  const SignupModel({
    required this.username,
    required this.email,
    required this.password,
    required this.cnfPassword,
  });

  // ✅ Factory constructor to create an object from JSON
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      cnfPassword: json['cnfPassword'] ?? '',
    );
  }

  // ✅ Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'cnfPassword': cnfPassword,
    };
  }
}
