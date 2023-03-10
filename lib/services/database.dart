import 'package:audioapp/models/appUser.dart';
import 'package:audioapp/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    }, SetOptions(merge: true));
  }

  Future initializeUserData() async {
    return await brewCollection.doc(uid).set({
      'sugars': '0',
      'name': 'new member',
      'strength': 100,
      'gender': '',
      'dob': '',
    }, SetOptions(merge: true));
  }


  Future updateUserProfile(String gender, String dob) async {
    return await brewCollection.doc(uid).update({
      'gender': gender,
      'dob': dob,
    });
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snapshot = await brewCollection.doc(uid).get();
    return snapshot.exists;
  }

  // Future<bool> checkUserProfileInit() async {
  //   DocumentSnapshot snapshot = await brewCollection.doc(uid).get();
  //   if (snapshot['gender']!='' && snapshot['dob']!='') {
  //
  //     return true;
  //   } else {
  //
  //     return false;
  //   }
  //
  // }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc['name'] ?? '',
        sugars: doc['sugars'] ?? '0',
        strength: doc['strength'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Brew>> get getBrews {

    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // user data from snapshot
  AppUserData _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid,
      name: snapshot['name'] ?? '',
      sugars: snapshot['sugars'] ?? '0',
      strength: snapshot['strength'] ?? 0,
      gender: snapshot['gender'] ?? '',
      dob: snapshot['dob'] ?? '',
    );
  }

  Stream<AppUserData> get getUserData {
    return brewCollection.doc(uid).snapshots().map(_appUserDataFromSnapshot);
  }
}
