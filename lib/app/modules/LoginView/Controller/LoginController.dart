import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneNuController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  var dropdwonValue = 'Item1'.obs;

  var verificationIdRecieved = ''.obs;
  var otpCodeVisible = false.obs;
  void verifyPhoneNumber() async {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNuController.text,
        verificationCompleted: (PhoneAuthCredential credentials) {
          auth.signInWithCredential(credentials).then((value) {
            print('Logged In SuccessFully');
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(
              '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' +
                  exception.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationIdRecieved.value = verificationId;
          otpCodeVisible.value = true;
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          timeOut();
        },timeout: Duration(minutes: 2));
  }

  void verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved.value,
        smsCode: otpCodeController.text);
    await auth
        .signInWithCredential(credential)
        .then((value) => print('Logged in'))
        .then((value) => Get.toNamed('/upan'));
  }

  void timeOut() {
    otpCodeController.clear();
    phoneNuController.clear();
    otpCodeVisible.value = false;
  }

  void clear() async {
    await auth.signOut();
    otpCodeController.clear();
    phoneNuController.clear();
    otpCodeVisible.value = false;
  }
}
