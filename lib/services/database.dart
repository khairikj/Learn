import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn/model/update.dart';
import 'package:learn/model/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference accountCollection =
      FirebaseFirestore.instance.collection('User');

  Future updateUserData(String name, String phoneNum, String address,
      String location, String photoURL,
      {String userType}) async {
    var data;

    var x = {
      'name': name,
      'phoneNum': phoneNum,
      'address': address,
      'location': location,
      'photoURL': photoURL,
      'userType': userType,
    };

    var y = {
      'name': name,
      'phoneNum': phoneNum,
      'address': address,
      'location': location,
      'photoURL': photoURL,
    };

    if (userType != null) {
      data = x;
    } else {
      data = y;
    }

    return await accountCollection.doc(uid).set(data);
  }

  //user list form snapshot
  List<UpdAcc> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UpdAcc(
        name: doc.data()['name'] ?? '',
        phoneNum: doc.data()['phoneNum'] ?? '',
        address: doc.data()['address'] ?? '',
        location: doc.data()['location'] ?? '',
        photoURL: doc.data()['photoURL'] ?? '',
      );
    }).toList();
  }

  // get user stream
  Stream<List<UpdAcc>> get user {
    return accountCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<UserData> get userData {
    return accountCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      phoneNum: snapshot.data()['phoneNum'],
      address: snapshot.data()['address'],
      location: snapshot.data()['location'],
      photoURL: snapshot.data()['photoURL'],
    );
  }
}
