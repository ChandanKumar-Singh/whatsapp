import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/app/Models/user.dart';
import 'package:whatsapp/constants/strings.dart';

class InitalDataController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController nameController = TextEditingController();
  var initialImage = ''.obs;
  var profilePicUrl = ''.obs;

  @override
  void onInit() {

    super.onInit();
    getPPUrl();
  }

  Future<User?> currentUser() async {
    User? user = await auth.currentUser;
    return user;
  }

 void getPPUrl() async {
    Reference reference =  storage.ref(auth.currentUser!.phoneNumber).child('WhatsAppProfilePic');
    if(reference.getDownloadURL().hashCode!= -13010){
      print(reference);
      profilePicUrl.value = await reference.getDownloadURL();
      print('-----------------------got url-------${profilePicUrl.value}');
    }

  }

  var isPermissionEnabled = false.obs;

  List<Permission> permissions = [
    Permission.camera,
    Permission.photos,
    Permission.storage,
  ];

  Future<bool> allPermissionsGranted() async {
    bool resVideo = await Permission.camera.isGranted;
    bool resAudio = await Permission.microphone.isGranted;
    return resVideo && resAudio;
  }

  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    if (statuses.values.every((status) => status == PermissionStatus.granted)) {
      isPermissionEnabled.value = true;
      await takePic(ImageSource.gallery);
    } else {
      Get.snackbar('PerMission Status', 'PerMission not Granted',
          duration: Duration(seconds: 1));
    }
  }

  Future<void> takePic(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      initialImage.value = pickedFile.path;
    } else {
      Get.snackbar('Image Error', 'Picking image Failed',
          backgroundColor: Colors.red);
    }
  }

  Future<void> uploadAndGetProfilePicUrl(String uid, String imagePath) async {
    Reference reference =  storage.ref(uid).child('WhatsAppProfilePic');
    if(reference.getDownloadURL().hashCode!= -13010){
      print(reference);
      profilePicUrl.value = await reference.getDownloadURL();
      print('-----------------------got url-------${profilePicUrl.value}');
    }else{
    //
    if (profilePicUrl.value == null) {
      await reference
          .putFile(File(imagePath))
          .then((p0) => print('uploaded---------------------'));
      profilePicUrl.value = await reference.getDownloadURL();
    }
      }
    // await firestore
    //     .collection('WhatsAppUsers')
    //     .doc(uid)
    //     .collection('info')
    //     .doc('info')
    //     .update({'profilePhoto': url});
  }

  void initiateUserDataBase({required String uid, String? name}) async {
    await uploadAndGetProfilePicUrl(uid, initialImage.value)
        .then((value) => print('--------------uploadAndGetProfilePicUrl'));
    Users users = Users(
      uid: uid,
      profilePhoto: profilePicUrl.value,
      name: nameController.text,
    );
    await firestore
        .collection(USERS_COLLECTION)
        .doc(uid).set(users.toMap(users) as Map<String, dynamic>)
        .then((value) => print('All Done')).then((value) => Get.offNamed('/home'));
    // await firestore
    //     .collection('WhatsAppUsers')
    //     .doc(uid)
    //     .collection('info')
    //     .doc('info')
    //     .set(users.toMap(users) as Map<String, dynamic>)
    //     .then((value) => print('All Done')).then((value) => Get.offNamed('/home'));
  }
}
