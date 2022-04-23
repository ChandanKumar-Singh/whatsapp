import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/modules/CallPage/CallPageController/CallPageController.dart';

class CallPageView extends StatelessWidget {
  CallPageView({Key? key}) : super(key: key);

  CallPageController controller = Get.put(CallPageController());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: ListView.builder(
          itemCount: 13,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(
                  top: i == 0 ? 8.0 : 5,
                  bottom: i == 12 ? 8 : 5,
                  left: 15,
                  right: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: Get.width * 0.075,
                    child: CircleAvatar(
                      radius: Get.width * 0.065,
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
                      Row(
                        children: [
                          Obx(() {
                            return Transform.rotate(
                              angle: !controller.dialedCall.value
                                  ? pi * 4 / 5
                                  : -pi * 1 / 4,
                              child: Image.asset(
                                'images/icons/callArrow.png',
                                width: Get.width * 0.04,
                                color: controller.missedCall.value
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          }),
                          Text(
                            '(${controller.callCount.value})',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: Get.width * 0.035),
                          ),Text(
                            'Today 3:33 PM',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: Get.width * 0.035),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon(
                    controller.audioCall.value
                        ? Icons.dialer_sip
                        : Icons.videocam,
                    color: Colors.green,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
