import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/app/modules/CamraView/Views/CameraView.dart';

import '../../../../../constants/strings.dart';
import '../../../../../contact.dart';
import '../../../../Models/message.dart';
import '../../../../Models/user.dart';
import '../../../../dataBase/FireBaseMethods/auth_methods.dart';
import '../cached_image.dart';

class ChatViewController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthMethods authMethods = AuthMethods();
  FirebaseAuth auth = FirebaseAuth.instance;

  var currentState = 'Today 3:33 pm'.obs;
  var isTyping = false.obs;
  var typedMessage = ''.obs;
  TextEditingController messageController = TextEditingController();

  var pickedFilePath = ''.obs;
  var galleryImageUrl = ''.obs;

  final CollectionReference _messageCollection =
      FirebaseFirestore.instance.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  late Users sender;
  late Users receiver;
  late String currentUserId;


  @override
  void onInit() {
    print(Get.arguments);
    // TODO: implement onInit
    super.onInit();
    messageController.addListener(() {
      isTyping.value = true;
    });
    authMethods.getCurrentUser().then((user) {
      currentUserId = user.phoneNumber!;
      sender = Users(
        uid: user.phoneNumber,
        name: user.displayName,
        profilePhoto: user.photoURL,
      );

    });
    receiver=Get.arguments;
  }


  addMessageToDb(
    Message message,
  ) async {
    messageController.clear();
    typedMessage.value = '';
    var map = message.toMap();
    await _messageCollection.doc(message.senderId).set({'hiii': 'hiii'});

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map as Map<String, dynamic>)
        .then((value) => print('messEGE ADDED'));

    addToContacts(senderId: message.senderId!, receiverId: message.receiverId!);
    await _messageCollection.doc(message.receiverId).set({'hiii': 'hiii'});
    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  addToContacts({required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  sendImageFromGallery(ImageSource source, String uid) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    pickedFilePath.value = pickedFile!.path;
    Reference ref = FirebaseStorage.instance
        .ref('Messages')
        .child(uid)
        .child(DateTime.now().toString());
    await ref
        .putFile(File(pickedFile.path))
        .then((p0) => print('Uploaded'))
        .then((value) => Get.back());
    String url = await ref.getDownloadURL();
    PictureToSendDialog2(
        Get.context!,
        pickedFile.path,
        () => setImageMsg(
              url,
              receiver.uid!,
              currentUserId,
            ));
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map as Map<String, dynamic>);

    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map)
        .then((value) => Get.back());
  }


}
