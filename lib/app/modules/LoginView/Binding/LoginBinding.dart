import 'package:get/get.dart';
import 'package:whatsapp/app/modules/LoginView/Controller/LoginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
