import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/app/modules/LoginView/Controller/LoginController.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Enter your Phone Number',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ),
                      PopupMenuButton(itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'help',
                            child: Text('Help'),
                          ),
                        ];
                      }),
                    ],
                  ),
                  Text('We will send an sms to verify your number'),
                  Text('Whats my number?'),
                  Obx(() {
                    String? selectedValue;
                    List<String> items = [
                      'Item1',
                      'India',
                      'Item3',
                      'Item4',
                    ];
                    return DropdownButton2<String>(
                      hint: Text(
                        'Your Country',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: controller.dropdwonValue.value,
                      onChanged: (value) {
                        controller.dropdwonValue.value = value!;
                        print(controller.dropdwonValue.value);
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    );
                  }),
                  TextField(
                    controller: controller.phoneNuController,
                    keyboardType: TextInputType.phone,
                  ),
                  Obx(() {
                    return Visibility(
                      visible: controller.otpCodeVisible.value,
                      child: TextField(
                        controller: controller.otpCodeController,
                        keyboardType: TextInputType.number,
                      ),
                    );
                  }),
                ],
              ),
              Obx(() {
                return ElevatedButton(
                  onPressed: () {
                    controller.otpCodeVisible.value
                        ? controller.verifyCode()
                        : controller.verifyPhoneNumber();
                  },
                  child: controller.otpCodeVisible.value
                      ? Text('Verify')
                      : Text('Next'),
                );
              }),
              // RaisedButton(
              //   onPressed: () {
              //     controller.clear();
              //   },
              //   child: Text('Logout'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


