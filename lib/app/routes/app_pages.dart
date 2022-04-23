import 'package:get/get.dart';
import 'package:whatsapp/app/Call/Bindings/CallBindings.dart';
import 'package:whatsapp/app/Call/View/CallScreen.dart';
import 'package:whatsapp/app/modules/LoginView/Binding/LoginBinding.dart';
import 'package:whatsapp/app/modules/LoginView/Views/UploadPicandUserName.dart';
import 'package:whatsapp/app/modules/home/ChatScreen/bindings/home_binding.dart';
import 'package:whatsapp/app/modules/home/ChatScreen/controllers/home_controller.dart';
import 'package:whatsapp/app/modules/home/ChatScreen/views/home_view.dart';

import 'package:whatsapp/app/modules/home/bindings/home_binding.dart';
import 'package:whatsapp/app/modules/home/views/home_view.dart';

import '../modules/LoginView/Views/LoginPage.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static const HOME = Routes.HOME;
  static const CHATVIEW = Routes.CHATVIEW;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page:()=> HomeView(),
      binding: HomeBinding(),
    ),GetPage(
      name: _Paths.LOGIN,
      page:()=> LoginPage(),
      binding: LoginBinding(),
    ),GetPage(
      name: _Paths.CHATVIEW,
      page:()=> ChatView(),
      binding: ChatViewBinding(),
    ),GetPage(
      name: _Paths.CALLSCREEN,
      page:()=> CallScreen(),
      binding:CallBindings(),
    ),GetPage(
      name: _Paths.UPAName,
      page:()=> UploadPicAndName(),

    ),
  ];
}
