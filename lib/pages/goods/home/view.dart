import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woo_shop/common/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './widgets/index.dart';
import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      // 背景透明
      backgroundColor: Colors.transparent,
      // 取消阴影
      elevation: 0,
      // 标题栏左侧间距
      titleSpacing: AppSpace.page,
      // 搜索栏
      title: InputWidget.search(
        contentPadding: EdgeInsets.only(top: 14),
        // 提示文字，多语言
        hintText: LocaleKeys.gHomeNewProduct.tr,
        // 点击事件
        onTap: controller.onAppBarTap,
        // 只读
        readOnly: true,
      ),
      // 右侧的按钮区域
      actions: [
        // 图标
        const IconWidget.svg(
          AssetsSvgs.pNotificationsBellSvg,
          size: 20,
          isDot: true,
        )
            .unconstrained() // 去掉约束， appBar 会有个约束下来
            .padding(
              left: AppSpace.listItem,
              right: AppSpace.page,
            ),
      ],
    );
  }

  // 轮播广告
  Widget _buildBanner() {
    return GetBuilder<HomeController>(
            init: controller,
            id: "home_banner",
            builder: (_) {
              return CarouselWidget(
                items: controller.bannerItems,
                currentIndex: controller.bannerCurrentIndex,
                onPageChanged: controller.onChangeBanner,
                height: 190.w,
              );
            })
        .clipRRect(all: AppSpace.button)
        // SliverToBoxAdapter 的作用是把普通的 Widget（比如 Container、Text 等）包装成一个 Sliver，
        // 以便可以放进 CustomScrollView 这类只接受 Sliver 的滚动组件中使用。
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

// 分类导航
  Widget _buildCategorys() {
    return <Widget>[
      for (var i = 0; i < controller.categoryItems.length; i++)
        CategoryListItemWidget(
          category: controller.categoryItems[i],
          onTap: (categoryId) => controller.onCategoryTap(categoryId),
        ).paddingRight(AppSpace.listItem)
    ]
        .toListView(
          scrollDirection: Axis.horizontal,
        )
        .height(90.w)
        .paddingVertical(AppSpace.listRow)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // 推荐商品
  Widget _buildFlashSell() {
    return <Widget>[
      for (var i = 0; i < controller.flashSellProductList.length; i++)
        ProductItemWidget(
          controller.flashSellProductList[i],
          imgHeight: 117.w,
          imgWidth: 120.w,
        )
            .constrained(
              width: 120.w,
              height: 170.w,
            )
            .paddingRight(AppSpace.listItem)
    ]
        .toListView(
          scrollDirection: Axis.horizontal,
        )
        .height(170.w)
        .paddingBottom(AppSpace.listRow)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // New Sell
  Widget _buildNewSell() {
    return GetBuilder<HomeController>(
        id: "home_new_sell",
        init: controller,
        builder: (_) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int position) {
                var product = controller.newProductProductList[position];
                return ProductItemWidget(
                  product,
                  imgHeight: 170.w,
                );
              },
              childCount: controller.newProductProductList.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpace.listRow,
              crossAxisSpacing: AppSpace.listItem,
              childAspectRatio: 0.8,
            ),
          )
              .sliverPadding(bottom: AppSpace.page)
              .sliverPaddingHorizontal(AppSpace.page);
        });
  }

  // 主视图
  Widget _buildView() {
    return controller.flashSellProductList.isEmpty ||
            controller.newProductProductList.isEmpty
        ?
        //占位图
        const PlaceholdWidget()
        : CustomScrollView(
            slivers: [
              // 轮播广告
              _buildBanner(),

              // 分类导航
              _buildCategorys(),

              // 热卖商品
              // 标题栏
              controller.flashSellProductList.isNotEmpty
                  ? BuildListTitle(
                      title: LocaleKeys.gHomeFlashSell.tr,
                      subTitle: "03. 30. 30",
                      onTap: () => controller.onAllTap(true),
                    )
                      .sliverToBoxAdapter()
                      .sliverPaddingHorizontal(AppSpace.page)
                  : const SliverToBoxAdapter(),
              Text(LocaleKeys.gHomeFlashSell.tr)
                  .sliverToBoxAdapter()
                  .sliverPaddingHorizontal(AppSpace.page),

              // 商品列表
              _buildFlashSell(),

              // 最新商品
              // 栏位标题
              controller.newProductProductList.isNotEmpty
                  ? BuildListTitle(
                      title: LocaleKeys.gHomeNewProduct.tr,
                      onTap: () => controller.onAllTap(false),
                    )
                      .sliverToBoxAdapter()
                      .sliverPaddingHorizontal(AppSpace.page)
                  : const SliverToBoxAdapter(),
              // 列表
              _buildNewSell(),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: false, // 启用上拉加载更多
            enablePullUp: true, // 启用下拉刷新
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: _buildView(),
          ),
        );
      },
    );
  }
}
