import 'package:audioapp/models/appUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');


  Future initializeUserData() async {
    return await brewCollection.doc(uid).set({
      'gender': '',
      'dob': '',
      'data': {
        'test1':[],
        'test2':[],
        'test3':[],
      }
    }, SetOptions(merge: true));
  }

  Future updateUserAudioData(String test, Map<String, dynamic> data) async {
    return await brewCollection.doc(uid).set({
      'data': {
        test: FieldValue.arrayUnion([data]),
      }
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
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Brew(
  //       name: doc['name'] ?? '',
  //       sugars: doc['sugars'] ?? '0',
  //       strength: doc['strength'] ?? 0,
  //     );
  //   }).toList();
  // }
  //
  //
  // Stream<List<Brew>> get getBrews {
  //
  //   return brewCollection.snapshots().map(_brewListFromSnapshot);
  // }

  // user data from snapshot
  AppUserData _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid,
      gender: snapshot['gender'] ?? '',
      dob: snapshot['dob'] ?? '',
      data: snapshot['data'] ?? '',
    );
  }

  Stream<AppUserData> get getUserData {
    return brewCollection.doc(uid).snapshots().map(_appUserDataFromSnapshot);
  }
}
