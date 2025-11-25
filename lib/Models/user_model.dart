class UserModel {
  final String email;
  final String password;
  final String type; // admin, chauffeur, supporteur

  UserModel({
    required this.email,
    required this.password,
    required this.type,
  });
}
