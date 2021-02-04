class UserUid {
  final String uid;

  UserUid({this.uid});
}

class UserData {
  String uid;
  String name;
  String phoneNum;
  String address;
  String location;
  String photoURL;
  String userType;

  UserData(
      {this.uid,
      this.name,
      this.phoneNum,
      this.address,
      this.location,
      this.photoURL,
      this.userType});
}
