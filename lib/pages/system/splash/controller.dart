import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';

class SplashController extends GetxController {
  SplashController();

  // _initData() {
  //   update(["splash"]);
  // }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();

    // 删除设备启动页
    FlutterNativeSplash.remove();
    _jumpToPage();
  }

  void _jumpToPage() {
    // 欢迎页
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(RouteNames.systemWelcome);
      // // 欢迎页从来没有展示过
      // if (!ConfigService.to.isAlreadyOpen) {
      //   Get.offAllNamed(RouteNames.systemWelcome);
      // } else {
      //   // 欢迎页已展示过
      //   Get.offAllNamed(RouteNames.main);
      //   // 未登录时展示登录页
      // }
    });
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
