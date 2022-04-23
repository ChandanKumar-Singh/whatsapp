import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter/material.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/app/modules/home/ChatScreen/cached_image.dart';

import '../Controllers/CameraViewController.dart';

class CameraView extends StatelessWidget {
  CameraView({
    Key? key,
  }) : super(key: key);
  CameraViewController controller = Get.put(CameraViewController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller.CameraP(context),
        Positioned(
          bottom: 0,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.red, width: 2, style: BorderStyle.solid),
                    image: DecorationImage(
                        image: FileImage(
                          File(controller.image.value),
                        ),
                        fit: BoxFit.cover)),
                height: Get.height * 0.1,
                width: Get.height * 0.07,
              );
            }),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: GestureDetector(
              onTap: controller.takePicture,
              onLongPress: controller.startVideoRecording,
              onLongPressUp: controller.stopVideoRecording,
              child: Container(
                height: Get.height * 0.1,
                width: Get.height * 0.1,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: Colors.white,
                        width: 3,
                        style: BorderStyle.solid)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
              padding: EdgeInsets.only(
                  left: Get.height * 0.03, bottom: Get.height * 0.05),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.flip_camera_android_rounded,
                      color: Colors.white,
                      size: Get.height * 0.04,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.flash_off),
                    color: Colors.white,
                    onPressed:
                        controller.isPermissionEnabled.value ? () {} : null,
                  ),
                ],
              )),
        ),
        Positioned(
          bottom: Get.height * 0.15,
          child: Column(
            children: [
              Container(
                height: Get.height * 0.055,
                width: Get.width,
                // color: Colors.grey,
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      'Swipe up for gallery',
                      style: TextStyle(color: Colors.white,fontSize: Get.height * 0.015),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.001),
              Container(
                height: Get.height * 0.1,
                width: Get.width,
                // color: Colors.grey,
                child: Obx(() {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.imagesList.value.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: i == 0 ? 20 : 5, right: 1),
                          child: InkWell(
                            onTap: () {
                              PictureToSendDialog(
                                  context, controller.imagesList.value[i]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white70,
                                    width: 0.5,
                                    style: BorderStyle.solid),
                                image: DecorationImage(
                                    image: DeviceImage(
                                        controller.imagesList.value[i]),

                                    // FileImage(
                                    //   File(controller.imagesList.value[i]),
                                    // ),
                                    fit: BoxFit.cover),
                              ),
                              height: Get.height * 0.1,
                              width: Get.height * 0.09,
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
        )
      ],
    );
  }
}

Future<dynamic> PictureToSendDialog(BuildContext context, LocalImage image) {
  return showDialog(
      context: context,
      builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                    // color: Colors.lightBlue,
                    image: DecorationImage(
                        image: DeviceImage(image), fit: BoxFit.cover)),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          print('go back');
                          Get.back();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.crop_rotate_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.text_fields_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: Get.height * 0.03,
                  child: Row(
                    children: [
                      Container(
                        height: Get.height * 0.07,
                        width: Get.width - Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_sharp),
                              SizedBox(width: Get.width * 0.01),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: 'Add a caption',
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.01),
                              Icon(Icons.slow_motion_video_rounded),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.07,
                        width: Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.done_rounded),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ))
            ],
          )));
}

Future<dynamic> PictureToSendDialog2(
    BuildContext context, String image, VoidCallback onTap) {
  return showDialog(
      context: context,
      builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                    // color: Colors.lightBlue,
                    image: DecorationImage(
                        image: FileImage(File(image)), fit: BoxFit.cover)),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          print('go back');
                          Get.back();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.crop_rotate_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.text_fields_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: Get.height * 0.03,
                  child: Row(
                    children: [
                      Container(
                        height: Get.height * 0.07,
                        width: Get.width - Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_sharp),
                              SizedBox(width: Get.width * 0.01),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: 'Add a caption',
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.01),
                              Icon(Icons.slow_motion_video_rounded),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.07,
                        width: Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.done_rounded),
                          onPressed: onTap,
                        ),
                      )
                    ],
                  ))
            ],
          )));
}

Future<dynamic> PictureToSendDialog3(BuildContext context) {
  CameraViewController controller = Get.put(CameraViewController());
  return showDialog(
      context: context,
      builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                    // color: Colors.lightBlue,
                    // image: DecorationImage(
                    //     image: FileImage(File(image)), fit: BoxFit.cover),
                    ),
                child: controller.videoPlayerController == null &&
                        controller.videoPlayerController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: controller
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(controller.videoPlayerController!),
                        ),
                      )
                    : Container(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          print('go back');
                          controller.videoPlayerController!.pause();
                          Get.back();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.crop_rotate_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.text_fields_rounded,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: Get.height * 0.03,
                  child: Row(
                    children: [
                      Container(
                        height: Get.height * 0.07,
                        width: Get.width - Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_sharp),
                              SizedBox(width: Get.width * 0.01),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: 'Add a caption',
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.01),
                              Icon(Icons.slow_motion_video_rounded),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.07,
                        width: Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.done_rounded),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ))
            ],
          )));
}

Future<dynamic> PictureToSendDialog4(BuildContext context, String image) {
  return showDialog(
      context: context,
      builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: Get.height,
                decoration: BoxDecoration(
                  // color: Colors.lightBlue,
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover),
                ),
                child: CachedImage(image, height: Get.height, width: Get.width),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          print('go back');
                          Get.back();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          print('Send');
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          )));
}
