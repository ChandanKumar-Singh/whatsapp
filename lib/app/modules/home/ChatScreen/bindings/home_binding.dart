import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class ChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatViewController>(
      () => ChatViewController(),
    );
  }
}
