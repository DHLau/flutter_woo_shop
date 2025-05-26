// import 'package:woo_shop/pages/system/demoGetX/login/index.dart';
// import 'package:woo_shop/pages/system/demoGetX/splash/index.dart';
import 'package:flutter/material.dart';
import 'package:woo_shop/pages/index.dart';
import 'index.dart';
import 'package:get/get.dart';

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.systemMain,
      page: () => const MainPage(),
      // GetX 框架的 Bindings 接口，用于管理应用主界面所需的所有控制器
      binding: MainBinding(),
    ),
    GetPage(
      name: RouteNames.videosUpload,
      page: () => const UploadPage(),
    ),
    GetPage(
      name: RouteNames.cartCartIndex,
      page: () => const CartIndexPage(),
    ),
    GetPage(
      name: RouteNames.goodsHome,
      page: () => const HomePage(),
    ),
    GetPage(
      name: RouteNames.goodsCategory,
      page: () => const CategoryPage(),
    ),
    GetPage(
      name: RouteNames.goodsProductDetails,
      page: () => const ProductDetailsPage(),
    ),
    GetPage(
      name: RouteNames.goodsProductList,
      page: () => const ProductListPage(),
    ),
    GetPage(
      name: RouteNames.msgMsgIndex,
      page: () => const MsgIndexPage(),
    ),
    GetPage(
      name: RouteNames.myMyIndex,
      page: () => const MyIndexPage(),
    ),
    GetPage(
      name: RouteNames.searchSearchIndex,
      page: () => const SearchIndexPage(),
    ),
    GetPage(
      name: RouteNames.systemLogin,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteNames.systemSplash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: RouteNames.systemWelcome,
      page: () => const WelcomePage(),
    ),
  ];
}
