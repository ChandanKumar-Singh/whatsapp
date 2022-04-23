import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/Models/message.dart';

import '../../../../constants/strings.dart';
import '../../../../contact.dart';
import '../../../dataBase/FireBaseMethods/auth_methods.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement HomeController
  late TabController tabController;
  var currentTab = 1.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthMethods authMethods = AuthMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<Contact> demo = <Contact>[].obs;
  RxList<Contact> contactLists = <Contact>[].obs;

  final CollectionReference _messageCollection =
      FirebaseFirestore.instance.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  Stream<List<Contact>> fetchContacts({required String userId}) =>
      _userCollection
          .doc(userId)
          .collection(CONTACTS_COLLECTION)
          .snapshots()
          .map((event) {
        // print(event);
        // print(event.docs);
        // print(event.docs.length);
        // print(event.docs.last.id);
        //
        List<Contact> list = [];
        event.docs.forEach((element) {
          // print('element---${element.data()}');
          list.add(Contact.fromMap(element.data()));
        });
        // print('lllllllllllllllll$list');
        contactLists.value=list;
        return list;
      });

  Stream<Message> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp",descending: true)
          .snapshots().first.asStream().map((event) {
            Message message= Message.fromMap(event.docs.first.data());
            print(message);
            return message;

      });

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    demo
        .bindStream(fetchContacts(userId: auth.currentUser!.phoneNumber!));
    tabController = TabController(length: 4, vsync: this, initialIndex: 1)
      ..addListener(() {
        currentTab.value = tabController.index;
      });
  }

  @override
  void onReady() {
    super.onReady();
    print(contactLists.length);
  }

  @override
  void onClose() {}
}
