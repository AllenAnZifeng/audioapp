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
    });
  }

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
    );
  }

  Stream<AppUserData> get getUserData {
    return brewCollection.doc(uid).snapshots().map(_appUserDataFromSnapshot);
  }
}
