class AppUser {
  final String uid;

  AppUser({required this.uid});
}

class AppUserData {
  final String uid;
  final String sugars;
  final String name;
  final int strength;
  final String dob;
  final String gender;

  AppUserData({required this.uid, required this.sugars,
    required this.name, required this.strength,
  required this.dob,required this.gender});
}