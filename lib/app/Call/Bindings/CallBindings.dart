import 'package:get/get.dart';
import 'package:whatsapp/app/Call/Controller/CallController.dart';

class CallBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CallController>(() => CallController());
  }
}
