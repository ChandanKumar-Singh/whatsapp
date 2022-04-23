import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/strings.dart';
import '../../Models/call.dart';

class CallController extends GetxController {
  int? _remoteUid;
  var _localUserJoined = false.obs;
  late RtcEngine _engine;
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({required String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({required Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({required Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  late StreamSubscription callStreamSubscription;

  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  @override
  void onInit() {
    super.onInit();
    // addPostFrameCallback();
    initAgora();
  }

  // AgoraClient client = AgoraClient(
  //     agoraConnectionData: AgoraConnectionData(
  //         appId: APP_ID, channelName: CHANNEL, tempToken: TOKEN),
  //     enabledPermission: [Permission.camera, Permission.microphone]);

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");

          _localUserJoined.value = true;
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");

          _remoteUid = uid;
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");

          _remoteUid = null;
        },
      ),
    );

    await _engine.joinChannel(TOKEN, CHANNEL, null, 0);
  }

  // Widget buildCallView(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Agora Video Call'),
  //     ),
  //     body: Stack(
  //       children: [
  //         Center(
  //           child: _remoteVideo(),
  //         ),
  //         Align(
  //           alignment: Alignment.topLeft,
  //           child: Container(
  //             width: 100,
  //             height: 150,
  //             child: Center(
  //               child: _localUserJoined.value
  //                   ? RtcLocalView.SurfaceView()
  //                   : CircularProgressIndicator(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Display remote user's video
  // Widget _remoteVideo() {
  //   if (_remoteUid != null) {
  //     return RtcRemoteView.SurfaceView(
  //       uid: _remoteUid!,
  //       channelId: channel,
  //     );
  //   } else {
  //     return Text(
  //       'Please wait for remote user to join',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }

  // addPostFrameCallback() {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     userProvider = Provider.of<UserProvider>(context, listen: false);
  //
  //     callStreamSubscription = callMethods
  //         .callStream(uid: userProvider.getUser.uid)
  //         .listen((DocumentSnapshot ds) {
  //       // defining the logic
  //       switch (ds.data) {
  //         case null:
  //           // snapshot is null which means that call is hanged and documents are deleted
  //           Navigator.pop(context);
  //           break;
  //
  //         default:
  //           break;
  //       }
  //     });
  //   });
  // }

  /// Create agora sdk instance and initialize
  // Future<void> _initAgoraRtcEngine() async {
  //   await RtcEngine.create(APP_ID);
  //   await RtcEngine.enableVideo();
  // }

  /// Add agora event handlers
  // void _addAgoraEventHandlers() {
  //   RtcEngine.onError = (dynamic code) {
  //     setState(() {
  //       final info = 'onError: $code';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onJoinChannelSuccess = (
  //     String channel,
  //     int uid,
  //     int elapsed,
  //   ) {
  //     setState(() {
  //       final info = 'onJoinChannel: $channel, uid: $uid';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onUserJoined = (int uid, int elapsed) {
  //     setState(() {
  //       final info = 'onUserJoined: $uid';
  //       _infoStrings.add(info);
  //       _users.add(uid);
  //     });
  //   };
  //
  //   RtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
  //     setState(() {
  //       final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
  //     setState(() {
  //       final info = 'onRejoinChannelSuccess: $string';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onUserOffline = (int a, int b) {
  //     callMethods.endCall(call: widget.call);
  //     setState(() {
  //       final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onRegisteredLocalUser = (String s, int i) {
  //     setState(() {
  //       final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onLeaveChannel = () {
  //     setState(() {
  //       _infoStrings.add('onLeaveChannel');
  //       _users.clear();
  //     });
  //   };
  //
  //   RtcEngine.onConnectionLost = () {
  //     setState(() {
  //       final info = 'onConnectionLost';
  //       _infoStrings.add(info);
  //     });
  //   };
  //
  //   RtcEngine.onUserOffline = (int uid, int reason) {
  //     // if call was picked
  //
  //     setState(() {
  //       final info = 'userOffline: $uid';
  //       _infoStrings.add(info);
  //       _users.remove(uid);
  //     });
  //   };
  //
  //   RtcEngine.onFirstRemoteVideoFrame = (
  //     int uid,
  //     int width,
  //     int height,
  //     int elapsed,
  //   ) {
  //     setState(() {
  //       final info = 'firstRemoteVideo: $uid ${width}x $height';
  //       _infoStrings.add(info);
  //     });
  //   };
  // }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));


    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }
  //
  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }
  //
  // / Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {

      muted = !muted;
      _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  /// Toolbar layout
  // Widget _toolbar() {
  //   return Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           child: Icon(
  //             muted ? Icons.mic : Icons.mic_off,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => callMethods.endCall(
  //             call: widget.call,
  //           ),
  //           child: Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           child: Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }


  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            // _toolbar(),
          ],
        ),
      ),
    );
  }
}
