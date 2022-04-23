import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:whatsapp/app/Models/user.dart';
import 'package:whatsapp/app/modules/home/SearchUser/SearchUserController/SearchUserController.dart';
import 'dart:io';

class SearchUsersPage extends StatelessWidget {
  SearchUsersPage({Key? key}) : super(key: key);
  SearchUserController controller = Get.put(SearchUserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.searchAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Chips(onTap: (){}, label: 'Photos', icon: Icons.photo),
                  Chips(onTap: (){}, label: 'Videos', icon: Icons.videocam),
                  Chips(onTap: (){}, label: 'Links', icon: Icons.link),
                  Chips(onTap: (){}, label: 'Gifs', icon: Icons.gif_box_rounded),
                  Chips(onTap: (){}, label: 'Audio', icon: Icons.headphones_rounded),
                  Chips(onTap: (){}, label: 'Documents', icon: Icons.file_copy_sharp),

                ],
              ),
            ),
            Obx(() => Expanded(
                child: controller.buildSuggestions(controller.query.value))),
          ],
        ),
      ),
    );
  }
}

class Chips extends StatelessWidget {
  const Chips({
    Key? key, required this.onTap, required this.label, required this.icon,
  }) : super(key: key);
final VoidCallback onTap;
final String label;
final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Chip(

          elevation: 3,
          padding: EdgeInsets.all(8),
          backgroundColor: Colors.grey[200],
          shadowColor: Colors.black,
          avatar: Icon(
           icon,
            color: Colors.black54,
          ), //CircleAvatar
          label: Text(
            label,
            style: TextStyle(fontSize: 15),
          ), //Text
        ),
      ),
    );
  }
}
