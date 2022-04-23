import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

CameraDescription? firstCamera;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;
  FirebaseAuth auth = FirebaseAuth.instance;
  // print(auth.currentUser!.uid);
  print('current user--------------------${auth.currentUser}');
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: Themes.light,
      darkTheme: Themes.dark,
      initialRoute: auth.currentUser == null ? AppPages.INITIAL : AppPages.HOME,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Themes {
  static final light = ThemeData(primarySwatch: Colors.teal);
  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(),


  );
}
//
// @override
// void didUpdateWidget(FlutterLayoutArticle oldWidget) {
//   super.didUpdateWidget(oldWidget);
//   var example = widget.examples[count - 1];
//   code = example.code;
//   explanation = example.explanation;
// }
