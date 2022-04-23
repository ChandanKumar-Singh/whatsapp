import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/app/Models/user.dart';

import '../../../constants/strings.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser!;
    return currentUser;
  }

  Future<Users> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();
    return Users.fromMap(documentSnapshot.data as Map<String, dynamic>);
  }

  Future<Users?> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return Users.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print('---------------------------$e');
      return null;
    }
  }

  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = [];

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.phoneNumber) {
        // print(
            // '-------${querySnapshot.docs.length}----${querySnapshot.docs[i].id}---------yes-------');
        userList.add(Users.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      } else {
        print('-------${querySnapshot.docs.length}-------------No-------');
      }
    }
    print(userList);
    return userList;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    Users user = Users(
        uid: currentUser.phoneNumber,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: currentUser.displayName);

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user) as Map<String, dynamic>);
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // void setUserState({@required String userId, @required UserState userState}) {
  //   int stateNum = Utils.stateToNum(userState);
  //
  //   _userCollection.doc(userId).updateData({
  //     "state": stateNum,
  //   });
  // }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      _userCollection.doc(uid).snapshots();
}
