import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/modules/StatusView/StatusController/StatusController.dart';

class StatusView extends StatelessWidget {
  StatusView({Key? key}) : super(key: key);
  StatusController controller = Get.put(StatusController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        personalStatusBuildItem(),
        Container(
          color: Colors.grey,
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
            child: Text(
              'Recent Updates',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Get.width * 0.04),
            ),
          ),
        ),
        othersStatusBuildItem()
      ],
    );
  }

  Container personalStatusBuildItem() {
    return Container(
      height: Get.height * 0.1,
      // color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                      'https://us.123rf.com/450wm/yupiramos/yupiramos1905/yupiramos190505227/122760736-little-girl-avatar-character-vector-illustration-design.jpg?ver=6'),
                ),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: CircleAvatar(
                    radius: Get.width * 0.035,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: Get.width * 0.03,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: Get.width * 0.05,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: Get.width * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY Status',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Get.width * 0.04),
                ),
                Text(
                  'Today 3:33 PM',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: Get.width * 0.035),
                ),
              ],
            ),
            Expanded(child: Container()),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.green,
                )),
          ],
        ),
      ),
    );
  }

  Expanded othersStatusBuildItem() {
    return Expanded(
      child: Container(
        // color: Colors.white,
        child: ListView.builder(
            itemCount: 13,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: i == 0 ? 8.0 : 0, bottom: i == 12 ? 8 : 0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Get.width * 0.09,
                            child: CircleAvatar(
                              radius: Get.width * 0.08,
                              backgroundImage: NetworkImage(
                                  'https://us.123rf.com/450wm/yupiramos/yupiramos1905/yupiramos190505227/122760736-little-girl-avatar-character-vector-illustration-design.jpg?ver=6'),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.05),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Didi 👩‍🏫',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.04),
                              ),
                              Text(
                                'Today 3:33 PM',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: Get.width * 0.035),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    i != 12 ? Divider(thickness: 1) : Container(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
