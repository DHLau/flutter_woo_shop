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

  // 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  // 页码
  int _page = 1;
  // 页尺寸
  final int _limit = 20;

  _loadCacheData() {
    var stringBanner = Storage().getString(Constants.storageHomeBanner);
    var stringCategories = Storage().getString(Constants.storageHomeCategories);
    var stringFlashSell = Storage().getString(Constants.storageHomeFlashSell);
    var stringNewSell = Storage().getString(Constants.storageHomeNewSell);

    bannerItems = stringBanner != ""
        ? jsonDecode(stringBanner).map<KeyValueModel>((item) {
            return KeyValueModel.fromJson(item);
          }).toList()
        : [];

    categoryItems = stringCategories != ""
        ? jsonDecode(stringCategories).map<CategoryModel>((item) {
            return CategoryModel.fromJson(item);
          }).toList()
        : [];

    flashSellProductList = stringFlashSell != ""
        ? jsonDecode(stringFlashSell).map<ProductModel>((item) {
            return ProductModel.fromJson(item);
          }).toList()
        : [];

    newProductProductList = stringNewSell != ""
        ? jsonDecode(stringNewSell).map<ProductModel>((item) {
            return ProductModel.fromJson(item);
          }).toList()
        : [];
    if (bannerItems.isNotEmpty ||
        categoryItems.isNotEmpty ||
        flashSellProductList.isNotEmpty ||
        newProductProductList.isNotEmpty) {
      update(["home"]);
    }
  }

  Future<void> _initData() async {
    var stringBanner = Storage().getString(Constants.storageHomeBanner);
    var stringCategories = Storage().getString(Constants.storageHomeCategories);
    var stringFlashSell = Storage().getString(Constants.storageHomeFlashSell);
    var stringNewSell = Storage().getString(Constants.storageHomeNewSell);

    // 原版这里是串行, 但我觉得没必要, 直接并行
    // 首页数据
    final futures = await Future.wait([
      // Banner
      SystemApi.banners(),
      // 分类
      ProductApi.categories(),
      // 推荐商品
      ProductApi.products(ProductsReq(featured: true)),
      // 最新商品
      ProductApi.products(ProductsReq()),
    ]);

    // 将结果分别赋值给对应变量
    bannerItems = futures[0] as List<KeyValueModel>;
    categoryItems = futures[1] as List<CategoryModel>;
    flashSellProductList = futures[2] as List<ProductModel>;
    newProductProductList = futures[3] as List<ProductModel>;

    // 颜色
    var attributeColors = await ProductApi.attributes(1);
    // 尺寸
    var attributeSizes = await ProductApi.attributes(2);
    // 品牌
    var attributeBrand = await ProductApi.attributes(3);
    // 性别
    var attributeGender = await ProductApi.attributes(4);
    // 新旧
    var attributeCondition = await ProductApi.attributes(5);

    // 保存离线数据 - 基础数据
    Storage().setJson(Constants.storageProductCategories, categoryItems);
    // 颜色
    Storage()
        .setJson(Constants.storageProductsAttributesColors, attributeColors);
    // 尺寸
    Storage().setJson(Constants.storageProductsAttributesSizes, attributeSizes);
    // 品牌
    Storage().setString(
        Constants.storageProductsAttributesBrand, jsonEncode(attributeBrand));
    // 性别
    Storage().setString(
        Constants.storageProductsAttributesGender, jsonEncode(attributeGender));
    // 新旧
    Storage().setString(Constants.storageProductsAttributesCondition,
        jsonEncode(attributeCondition));
    // 保存离线数据 - 首页业务
    Storage().setJson(Constants.storageHomeBanner, bannerItems);
    Storage().setJson(Constants.storageHomeCategories, categoryItems);
    Storage().setJson(Constants.storageHomeFlashSell, flashSellProductList);
    Storage().setJson(Constants.storageHomeNewSell, newProductProductList);

    // 模拟网络延迟 1 s
    await Future.delayed(const Duration(seconds: 2));

    update(["home"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();

    /// 刷新控制器释放
    refreshController.dispose();
  }
}
