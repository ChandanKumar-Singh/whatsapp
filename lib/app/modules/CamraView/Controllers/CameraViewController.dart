import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_image_provider/local_image_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/app/modules/CamraView/Views/CameraView.dart';
import 'dart:async';
import 'dart:io';
import 'package:whatsapp/main.dart';

class CameraViewController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var image = ''.obs;
  var videoPath = ''.obs;
  var imagesList = [].obs;
  late CameraController cameraController;
  VideoPlayerController? videoPlayerController;

  var isPermissionEnabled = false.obs;
  var _isRecordingInProgress = false.obs;
  List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
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
      startCamera();
    } else {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Permission not granted'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void initScreen() async {
    if (await allPermissionsGranted()) {
      isPermissionEnabled.value = true;
      startCamera();
    } else {
      requestPermission();
    }
  }

  void startCamera() {
    _initCamera();
    getGalleryImages();
  }

  _initCamera() async {
    cameraController = CameraController(firstCamera!, ResolutionPreset.high);
    cameraController.addListener(() {
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }

  void takePicture() async {
    var imagePath = await cameraController.takePicture();
    image.value = imagePath.path;
    if (image.value != null) {
      PictureToSendDialog2(Get.context!, image.value, () {});
    }
  }

  void startVideoRecording() async {
    if (cameraController.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      print(_isRecordingInProgress);
    }
    try {
      await cameraController.startVideoRecording();

      _isRecordingInProgress.value = true;
      print(_isRecordingInProgress);
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  void stopVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      // Recording is already is stopped state
      print(_isRecordingInProgress);
    }
    try {
      var videoFile = await cameraController.stopVideoRecording();
      videoPath.value = videoFile.path;
      // Directory dir = Directory.systemTemp;
      // videoFile.saveTo(dir.path);
      // print(dir.path);
      _isRecordingInProgress.value = false;
      print(_isRecordingInProgress);
      print(videoFile.isBlank);
      print(videoFile.length());
      await _startVideoPlayer();
      PictureToSendDialog3(Get.context!);
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoPath.value != null) {
      videoPlayerController = VideoPlayerController.file(File(videoPath.value));
      await videoPlayerController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
      });
      await videoPlayerController!.setLooping(true);
      await videoPlayerController!.play();
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    initScreen();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  Widget CameraP(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return FutureBuilder<void>(
      future: cameraController.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(cameraController);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void getGalleryImages() async {
    LocalImageProvider imageProvider = LocalImageProvider();
    bool hasPermission = await imageProvider.initialize();
    if (hasPermission) {
      List images = await imageProvider.findLatest(200);
      if (images.isNotEmpty) {
        images.forEach((element) {
          imagesList.add(element);
        });
      } else {
        Get.snackbar('Images Error', 'Images not Found',
            backgroundColor: Colors.red);
      }
    } else {
      await imageProvider.initialize();
      Get.snackbar('Images Error',
          'The user has denied access to images on their device.',
          backgroundColor: Colors.red);
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
// class VideoToSendPage extends StatelessWidget {
//   const VideoToSendPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(10.0),
//         border: Border.all(color: Colors.white, width: 2),
//         image: _imageFile != null
//             ? DecorationImage(
//           image: FileImage(_imageFile!),
//           fit: BoxFit.cover,
//         )
//             : null,
//       ),
//       child: videoController != null && VideoPlayerController.value.isInitialized
//           ? ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: AspectRatio(
//           aspectRatio: VideoPlayerController.value.aspectRatio,
//           child: VideoPlayer(VideoPlayerController),
//         ),
//       )
//           : Container(),
//     );
//   }
// }
