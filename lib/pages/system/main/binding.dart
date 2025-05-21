import 'package:woo_shop/pages/cart/cart_index/index.dart';
import 'package:woo_shop/pages/goods/home/index.dart';
import 'package:woo_shop/pages/msg/msg_index/index.dart';
import 'package:woo_shop/pages/index.dart';
import 'package:get/get.dart';
import 'package:woo_shop/pages/my/my_index/controller.dart';
import 'package:woo_shop/pages/system/main/index.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    // 主界面依赖
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartIndexController>(() => CartIndexController());
    Get.lazyPut<MsgIndexController>(() => MsgIndexController());
    Get.lazyPut<MyIndexController>(() => MyIndexController());
    Get.lazyPut<MainController>(() => MainController());
  }
}
