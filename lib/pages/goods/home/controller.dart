import 'dart:convert';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  HomeController();

  void onAppBarTap() {
    Get.toNamed(RouteNames.searchSearchIndex);
  }

  // Barnner 当前索引
  int bannerCurrentIndex = 0;
  // Barnner 数据
  List<KeyValueModel> bannerItems = [];

  // Banner 点击事件
  void onChangeBanner(int index, reason) {
    bannerCurrentIndex = index;
    update(["home_banner"]);
  }

  // 分类导航数据
  List<CategoryModel> categoryItems = [];

  // 推荐商品列表数据
  List<ProductModel> flashSellProductList = [];

  // 最新商品列表数据
  List<ProductModel> newProductProductList = [];

  // 分类点击事件
  void onCategoryTap(int categoryId) {
    Get.toNamed(
      RouteNames.goodsCategory,
      arguments: {
        "id": categoryId,
      },
    );
  }

  // All点击事件
  void onAllTap(bool featured) {
    Get.toNamed(RouteNames.goodsProductList, arguments: {
      "featured": featured,
    });
  }

  _initData() {
    update(["home"]);
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
