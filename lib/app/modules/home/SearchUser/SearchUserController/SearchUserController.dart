import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/Models/user.dart';
import 'package:whatsapp/app/modules/CamraView/Controllers/CameraViewController.dart';
import 'package:whatsapp/app/modules/home/ChatScreen/controllers/home_controller.dart';

import '../../../../dataBase/FireBaseMethods/auth_methods.dart';

class SearchUserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthMethods _authMethods = AuthMethods();
  // ChatViewController chatViewController = Get.put(ChatViewController());
  var query = "".obs;
  TextEditingController searchController = TextEditingController();

  var userList = <Users>[].obs;
  var usersInfoList = [].obs;
  Users? searchedUser;

  @override
  void onInit() {
    super.onInit();
    _authMethods.getCurrentUser().then((User user) {
      print('current user--------------------$user');
      _authMethods.fetchAllUsers(user).then((List<Users> list) {
        userList.value = list;
        userList.forEach((element) {
          print(element);
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              WidgetsBinding.instance
                  ?.addPostFrameCallback((_) => searchController.clear());
              query.value = '';
              Get.back();
            },
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                query.value = val;
              },
              autofocus: true,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 25,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    WidgetsBinding.instance
                        ?.addPostFrameCallback((_) => searchController.clear());
                  },
                ),
                border: InputBorder.none,
                hintText: "Search...",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Color(0xFF131212),
                ),
              ),
            ),
          ),
        ],
      ),
      elevation: 0,
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      //   child:
      // Padding(
      //     padding: EdgeInsets.only(left: 20),
      //     child: TextField(
      //       controller: searchController,
      //       onChanged: (val) {
      //         query.value = val;
      //       },
      //       autofocus: true,
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white,
      //         fontSize: 35,
      //       ),
      //       decoration: InputDecoration(
      //         suffixIcon: IconButton(
      //           icon: Icon(Icons.close, color: Colors.white),
      //           onPressed: () {
      //             WidgetsBinding.instance
      //                 ?.addPostFrameCallback((_) => searchController.clear());
      //           },
      //         ),
      //         border: InputBorder.none,
      //         hintText: "Search",
      //         hintStyle: TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 35,
      //           color: Color(0x88ffffff),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildSuggestions(String q) {
    print(q);
    var suggestionList = q.isEmpty
        ? <Users>[].obs
        : userList.value != null
            ? userList.value
                .where((user) {
                  print(userList.value);
                  print(user.uid);
                  String _getUsername = user.uid!.toLowerCase();
                  String _query = q.toLowerCase();
                  String _getName = user.name!.toLowerCase();
                  bool matchesUsername = _getUsername.contains(_query);
                  bool matchesName = _getName.contains(_query);

                  return (matchesUsername || matchesName);

                  // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
                  //     (user.name.toLowerCase().contains(query.toLowerCase()))),
                })
                .toList()
                .obs
            : <Users>[].obs;

    return Obx(() {
      return ListView.builder(
        itemCount: suggestionList.value.length,
        itemBuilder: ((context, i) {
          print(suggestionList);
          searchedUser = Users(
              uid: suggestionList[i].uid,
              profilePhoto: suggestionList[i].profilePhoto,
              name: suggestionList[i].name,
              username: suggestionList[i].username);
          // chatViewController.receiver = searchedUser!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: InkWell(
              onTap: () {
                Get.toNamed('/chatView', arguments: searchedUser);

                WidgetsBinding.instance
                    ?.addPostFrameCallback((_) => searchController.clear());
                query.value = '';
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        // backgroundColor: Colors.tealAccent,
                        radius: Get.width * 0.09,
                        backgroundImage:
                            NetworkImage(searchedUser!.profilePhoto!),
                      ),
                      SizedBox(width: Get.width * 0.05),
                      Text(
                        searchedUser!.uid.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Stream<List> getUsersIdList() {
    return firestore
        .collection('WhatsAppUsers')
        .snapshots()
        .map((QuerySnapshot query) {
      List user = [];
      for (var items in query.docs) {
        user.add(items.id);
        // getUsersInfoList(items.id,user);
      }

      print(query.docs);
      print(user.map((e) => e));
      return user;
    });
  }

  Stream getUserInfo() {
    return FirebaseFirestore.instance
        .collection('WhatsAppUsers')
        .doc('info')
        .collection('info')
        .doc('info')
        .snapshots();
  }
}
