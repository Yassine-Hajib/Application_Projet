class Chauffeur {
  String name;
  String email;
  String phone;

  Chauffeur({required this.name, required this.email, required this.phone});

  // Update profile
  void updateProfile(String newName, String newEmail, String newPhone) {
    name = newName;
    email = newEmail;
    phone = newPhone;
  }
}
