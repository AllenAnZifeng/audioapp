class AppUser {
  final String uid;

  AppUser({required this.uid});
}

class AppUserData {
  final String uid;
  final String sugars;
  final String name;
  final int strength;

  AppUserData({required this.uid, required this.sugars, required this.name, required this.strength});
}