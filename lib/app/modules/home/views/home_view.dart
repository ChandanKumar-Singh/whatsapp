import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/Models/message.dart';
import 'package:whatsapp/app/modules/home/SearchUser/SearchUserView/SearchUsersWidget.dart';
import 'package:whatsapp/app/modules/CallPage/CallPage/CallPage.dart';
import 'package:whatsapp/app/modules/CamraView/Controllers/CameraViewController.dart';
import 'package:whatsapp/app/modules/LoginView/Controller/InitalDataController.dart';
import '../../../Models/user.dart';
import '../../../dataBase/FireBaseMethods/auth_methods.dart';
import '../../CamraView/Views/CameraView.dart';
import '../../StatusView/StatusView/StatusView.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  FirebaseAuth auth = FirebaseAuth.instance;

  InitalDataController initalDataController = Get.put(InitalDataController());
  // CameraViewController cameraViewController = Get.put(CameraViewController());
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double h = s.height;
    double w = s.width;

    double cameraWidth = w / 24;
    double yourWidth = (w - cameraWidth) / 5;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WhatsApp'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (Get.isDarkMode) {
                      Get.changeThemeMode(ThemeMode.light);
                    } else {
                      Get.changeThemeMode(ThemeMode.dark);
                    }
                    print('DarkMode->' + Get.isDarkMode.toString());
                  },
                  icon: Icon(Icons.dark_mode),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(SearchUsersPage());
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    // auth.signOut();
                    // Get.offNamed('/login');
                    // initalDataController.initialImage.value =
                    //     cameraViewController.image.value;
                    // initalDataController.initiateUserDataBase(
                    //     uid: '+919693559248');
                  },
                  icon: Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
            controller: controller.tabController,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(
                horizontal: (w - (cameraWidth + yourWidth * 3)) / 8),
            isScrollable: true,
            tabs: [
              Container(
                child: Tab(icon: Icon(Icons.camera_alt)),
                width: cameraWidth,
              ),
              Container(
                child: Row(
                  children: [
                    Tab(
                      child: Text(
                        'CHATS',
                        style: TextStyle(fontSize: w * 0.035),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: NotificationCountWidget(
                        count: 33,
                        max: 9,
                        TColor: Colors.green,
                        CColor: Colors.white,
                      ),
                    )
                  ],
                ),
                width: yourWidth,
              ),
              Container(
                child: Row(
                  children: [
                    Tab(
                      child: Text(
                        'STATUS',
                        style: TextStyle(fontSize: w * 0.035),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Obx(() {
                        return CircleAvatar(
                          radius: Get.width * 0.01,
                          backgroundColor: controller.currentTab.value == 2
                              ? Colors.white
                              : Colors.white70,
                        );
                      }),
                    )
                  ],
                ),
                width: yourWidth,
              ),
              Container(
                child: Tab(
                  child: Text(
                    'CALLS',
                    style: TextStyle(fontSize: w * 0.035),
                  ),
                ),
                width: yourWidth,
              ),
            ]),
      ),
      body: BodyTabBarView(controller: controller),
      floatingActionButton: Obx(() {
        return controller.currentTab.value == 0
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: Get.width * 0.1),
                child: FloatingActionButton(
                  onPressed: () {
                    controller.currentTab.value == 1
                        ? print('chat')
                        : controller.currentTab.value == 2
                            ? print('status')
                            : print('call');
                  },
                  child: Obx(() {
                    return Icon(controller.currentTab.value == 1
                        ? Icons.message_rounded
                        : controller.currentTab.value == 2
                            ? Icons.camera_alt_outlined
                            : Icons.add_call);
                  }),
                ),
              );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class BodyTabBarView extends StatelessWidget {
  const BodyTabBarView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: [
        CameraView(),
        ChatListItems(),
        Container(child: StatusView(), color: Colors.grey[300]),
        CallPageView(),
      ],
    );
  }
}

class ChatListItems extends StatelessWidget {
  ChatListItems({
    Key? key,
  }) : super(key: key);

  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (context) {
        return ListView.builder(
            itemCount: controller.contactLists.value.length,
            itemBuilder: (context, i) {
              return FutureBuilder(
                  future: AuthMethods()
                      .getUserDetailsById(controller.contactLists.value[i].uid),
                  builder: (context, AsyncSnapshot snapshot) {
                    controller.contactLists.value[i].uid;
                    if (snapshot.hasData) {
                      Users? user = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: InkWell(
                          onTap: () =>
                              Get.toNamed('/chatView', arguments: user),
                          child: Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  // backgroundColor: Colors.tealAccent,
                                  radius: Get.width * 0.09,
                                  backgroundImage:
                                      AssetImage('images/icons/user.png'),
                                  foregroundImage:
                                      NetworkImage(user!.profilePhoto!),
                                ),
                                SizedBox(width: Get.width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name!),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/icons/greenDouble.png',
                                          width: Get.width * 0.05,
                                        ),
                                        StreamBuilder(
                                            stream: controller
                                                .fetchLastMessageBetween(
                                                    senderId: controller
                                                        .auth
                                                        .currentUser!
                                                        .phoneNumber!,
                                                    receiverId: user.uid!),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              print(snapshot.hasData);
                                              // print(snapshot.data);
                                              print(snapshot.data);
                                              if (snapshot.hasData) {
                                                Message message = snapshot.data;
                                                print(message.message);
                                                return Text(
                                                  message.type == 'image'
                                                      ? 'Photo 📸'
                                                      : message.message!,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                );
                                              }
                                              return Text(
                                                '',
                                              );
                                            }),
                                        // Text(
                                        //   'Photosssssssssssssssssssssssssssssssssssssssss 📸',
                                        //   style: TextStyle(color: Colors.grey,overflow: TextOverflow.ellipsis),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(child: Container()),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'yesterday',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/icons/mute.png',
                                          width: Get.width * 0.04,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                        NotificationCountWidget(
                                          count: 13,
                                          max: 99,
                                          TColor: Colors.white,
                                          CColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Some Problem \n Here');
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0x19777B74),
                      ),
                    );
                  });
            });
      },
    );
  }
}

class NotificationCountWidget extends StatelessWidget {
  const NotificationCountWidget({
    Key? key,
    required this.count,
    required this.max,
    required this.TColor,
    required this.CColor,
  }) : super(key: key);
  final int count;
  final int max;
  final Color TColor;
  final Color CColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: CColor, borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
        child: Row(
          children: [
            count <= max
                ? Text(
                    count.toString(),
                    style: TextStyle(color: TColor, fontSize: Get.width * 0.03),
                  )
                : Text(
                    max.toString(),
                    style: TextStyle(color: TColor, fontSize: Get.width * 0.03),
                  ),
            count > max
                ? Text(
                    '+',
                    style: TextStyle(color: TColor, fontSize: Get.width * 0.03),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
