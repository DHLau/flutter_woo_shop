import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';

class MainController extends GetxController {
  MainController();

  // 分页管理
  final PageController pageController = PageController();

  // 当前的 tab index
  int currentIndex = 0;

  // 导航栏切换
  void onIndexChanged(int index) {
    currentIndex = index;
    update(['navigation']);
  }

  // 切换页面
  void onJumpToPage(int page) {
    pageController.jumpToPage(page);
    // if ((page != 0) && !UserService.to.isLogin) {
    //   Get.toNamed(RouteNames.systemLogin);
    // } else {
    //   pageController.jumpToPage(page);
    // }
  }

  // 跳转到视频页面
  void onJumpToVideo() {
    Get.toNamed(RouteNames.videosUpload);
  }

  _initData() async {
    // 读取用户 profile 信息
    await UserService.to.getProfile();
    update(['main']);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    // 释放分页控制器资源
    pageController.dispose();
  }
}
