class AppUser {
  final String uid;

  AppUser({required this.uid});
}

class AppUserData {
  final String uid;
  final String dob;
  final String gender;
  final Map<String, dynamic> data;

  AppUserData({required this.uid,
  required this.dob,required this.gender, required this.data});
}