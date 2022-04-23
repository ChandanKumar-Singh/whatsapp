import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/app/modules/LoginView/Controller/InitalDataController.dart';

class UploadPicAndName extends StatelessWidget {
  InitalDataController initalDataController = Get.put(InitalDataController());
  @override
  Widget build(BuildContext context) {
    print(initalDataController.profilePicUrl.value);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                      InkWell(
                        onTap: () async {
                          if (await initalDataController
                              .allPermissionsGranted()) {
                            initalDataController.isPermissionEnabled.value =
                                true;
                            await initalDataController
                                .takePic(ImageSource.camera);
                          } else {
                            initalDataController.requestPermission();
                          }
                        },
                        child: Obx(() {
                          return CircleAvatar(
                            radius: Get.width * 0.07,
                            backgroundImage: initalDataController
                                        .profilePicUrl.value ==
                                    ''
                                ? FileImage(File(
                                    initalDataController.initialImage.value))
                                : NetworkImage(initalDataController
                                    .profilePicUrl.value) as ImageProvider,
                          );
                        }),
                      ),
                    TextField(
                      controller: initalDataController.nameController,
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    initalDataController.initiateUserDataBase(
                        uid: initalDataController
                            .auth.currentUser!.phoneNumber!);
                  },
                  child: Text('Next'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
