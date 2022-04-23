// import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/Call/Controller/CallController.dart';

import '../../../constants/strings.dart';

class CallScreen extends GetView<CallController> {

  // AgoraClient client = AgoraClient(
  //     agoraConnectionData: AgoraConnectionData(
  //         appId: APP_ID, channelName: CHANNEL, tempToken: TOKEN),
  //     enabledPermission: [Permission.camera, Permission.microphone]);
  @override
  Widget build(BuildContext context) {
    return controller.buildScaffold(context);
  }
}
