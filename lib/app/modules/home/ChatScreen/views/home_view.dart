import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/app/Call/Controller/CallController.dart';
import 'package:whatsapp/app/Models/message.dart';
import 'package:whatsapp/app/dataBase/FireBaseMethods/auth_methods.dart';
import '../../../../../constants/strings.dart';
import '../../../CamraView/Views/CameraView.dart';
import '../cached_image.dart';
import '../controllers/home_controller.dart';

class ChatView extends GetView<ChatViewController> {
  AuthMethods authMethods = AuthMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  CallController callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double h = s.height;
    double w = s.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  InkWell(onTap: Get.back, child: Icon(Icons.arrow_back)),
                  CircleAvatar(
                    radius: w * 0.05,
                    backgroundImage:
                        NetworkImage(controller.receiver.profilePhoto!),
                  ),
                  SizedBox(width: w * 0.02),
                  Expanded(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        Text(controller.receiver.name!),
                        Obx(() {
                          return Text(
                            controller.typedMessage.value.isNotEmpty
                                ? 'Typing...'
                                : controller.currentState.value,
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed('/callScreen');
                  },
                  icon: Icon(Icons.videocam),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
          color: Color(0x34B9EEDB),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: h * 0.01),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(MESSAGES_COLLECTION)
                          .doc(auth.currentUser!.phoneNumber)
                          .collection(controller.receiver.uid!)
                          .orderBy(TIMESTAMP_FIELD, descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        // print(snapshot.hasData);
                        return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              Message message = Message.fromMap(
                                  snapshot.data!.docs[i].data()
                                      as Map<String, dynamic>);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: message.type == 'text'
                                    ? StringMessageWidget(w, message)
                                    : ImageMessageWidget(w, message),
                              );
                            });
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: h * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: Get.height * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Icon(Icons.emoji_emotions_outlined)),
                                SizedBox(width: Get.width * 0.02),
                                Expanded(
                                  child: TextField(
                                    autofocus: false,
                                    controller: controller.messageController,
                                    enabled: true,
                                    onChanged: (val) {
                                      controller.typedMessage.value = val;
                                      // controller.messageController.text = val;
                                      // controller.currentState.value =
                                      //     'typing...';
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Message',
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.02),
                                InkWell(
                                    onTap: () {
                                      Get.bottomSheet(BottomSheet(
                                          enableDrag: false,
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          onClosing: () {},
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.1,
                                                  horizontal: w * 0.05),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          w * 0.03),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(w * 0.05),
                                                  child: GridView(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3),
                                                    children: [
                                                      BottomCircleIcon(h, w,
                                                          onTap: () {},
                                                          icon: Icons
                                                              .document_scanner,
                                                          color:
                                                              Color(0xC64A12A3),
                                                          text: 'Document'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () async {
                                                        await controller
                                                            .sendImageFromGallery(
                                                                ImageSource
                                                                    .camera,
                                                                controller
                                                                    .receiver
                                                                    .uid!);
                                                      },
                                                          icon:
                                                              Icons.camera_alt,
                                                          color:
                                                              Color(0xE1EF31A3),
                                                          text: 'Camera'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () async {
                                                        await controller
                                                            .sendImageFromGallery(
                                                                ImageSource
                                                                    .gallery,
                                                                controller
                                                                    .receiver
                                                                    .uid!);
                                                      },
                                                          icon: Icons
                                                              .photo_size_select_actual_rounded,
                                                          color:
                                                              Color(0xC6E83FD6),
                                                          text: 'Gallery'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () {},
                                                          icon: Icons
                                                              .headphones_rounded,
                                                          color:
                                                              Color(0xC6E54E12),
                                                          text: 'Audio'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () {},
                                                          icon: Icons
                                                              .document_scanner,
                                                          png:
                                                              'images/icons/rupee.png',
                                                          color:
                                                              Color(0xC41F6D47),
                                                          text: 'Payments'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () {},
                                                          icon: Icons
                                                              .location_on_rounded,
                                                          color:
                                                              Color(0xC618E822),
                                                          text: 'Location'),
                                                      BottomCircleIcon(h, w,
                                                          onTap: () {},
                                                          icon: Icons
                                                              .supervisor_account_outlined,
                                                          color:
                                                              Color(0xC615CDEC),
                                                          text: 'Contacts'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }));
                                    },
                                    child: Transform.rotate(
                                        angle: -45,
                                        child: Icon(Icons.attach_file))),
                                SizedBox(width: Get.width * 0.05),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'images/icons/rupee.png',
                                    width: w * 0.06,
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.05),
                                InkWell(
                                    onTap: () {},
                                    child: Icon(Icons.camera_alt_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.01),
                      Container(
                        height: Get.height * 0.07,
                        width: Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Obx(() {
                          if (controller.typedMessage.value.isNotEmpty) {
                            return IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              onPressed: () => controller.addMessageToDb(
                                Message(
                                    senderId: controller.currentUserId,
                                    receiverId: Get.arguments.uid,
                                    message: controller.messageController.text,
                                    timestamp:
                                        Timestamp.fromDate(DateTime.now()),
                                    type: 'text'),
                                // Message(
                                //     senderId: Get.arguments.uid,
                                //     receiverId: controller.currentUserId,
                                //     message:
                                //         controller.messageController.text,
                                //     timestamp:
                                //         Timestamp.fromDate(DateTime.now()),
                                //     type: 'text'),
                              ),
                            );
                          } else {
                            return IconButton(
                              icon: Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            );
                          }
                        }),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Container BottomCircleIcon(double h, double w,
      {required IconData icon,
      String? png,
      required Color color,
      required VoidCallback onTap,
      required String text}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                //     gradient: LinearGradient(
                //         colors: [
                //   Color(
                //       0x42399434),
                //   Color(
                //       0xB51CEA11),
                // ],
                //         begin: Alignment
                //             .topLeft,
                //         stops:
                //             [5,5]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: png == null
                    ? Icon(
                        icon,
                        color: Colors.white,
                        size: w * 0.07,
                      )
                    : Image.asset(
                        png,
                        color: Colors.white,
                        width: w * 0.07,
                      ),
              ),
            ),
          ),
          SizedBox(height: h * 0.007),
          Text(
            text,
            style: TextStyle(fontSize: w * 0.035),
          ),
        ],
      ),
    );
  }

  Row StringMessageWidget(double w, Message _message) {
    // Message _message = Message.fromMap(snapshot.data() as Map<String, dynamic>);
    bool sent = _message.senderId == controller.currentUserId ? true : false;
    return Row(
      mainAxisAlignment: _message.senderId == controller.currentUserId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            UnconstrainedBox(
              child: LimitedBox(
                maxWidth: w * 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0x7C6BB191),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sent ? 10 : 0),
                        topRight: Radius.circular(!sent ? 10 : 0),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 7, left: 4, right: 60),
                    child: Container(
                      // color: Colors.red,
                      child: Text(_message.message!),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 3,
              bottom: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat()
                        .add_Hm()
                        .format(_message.timestamp!.toDate())
                        .toString(),
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    width: w * 0.005,
                  ),
                  Image.asset(
                    'images/icons/greenDouble.png',
                    width: 13,
                    color: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Row ImageMessageWidget(double w, Message _message) {
    bool sent = _message.senderId == controller.currentUserId ? true : false;
    return Row(
      mainAxisAlignment: sent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            UnconstrainedBox(
              child: LimitedBox(
                maxWidth: w * 0.6,
                child: InkWell(
                  onTap: () {
                    print('tapped');
                    PictureToSendDialog4(Get.context!, _message.photoUrl!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0x7C6BB191),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(sent ? 10 : 0),
                          topRight: Radius.circular(!sent ? 10 : 0),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4, left: 4, right: 4),
                        child: _message.photoUrl != null
                            ? CachedImage(
                                _message.photoUrl!,
                                height: 250,
                                width: 250,
                                radius: 10,
                              )
                            : Text("Url was null")),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 3,
              bottom: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat()
                            .add_E()
                            .format(_message.timestamp!.toDate())
                            .toString() +
                        ' ' +
                        DateFormat()
                            .add_jm()
                            .format(_message.timestamp!.toDate())
                            .toString(),
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  SizedBox(
                    width: w * 0.005,
                  ),
                  Image.asset(
                    'images/icons/greenDouble.png',
                    width: 13,
                    color: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
