import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:woo_shop/common/index.dart';
import 'package:woo_shop/pages/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// AutomaticKeepAliveClientMixin 保活
// 这段代码实现了 Flutter 中的页面状态保持功能：
// 当页面被销毁时，状态不会被清除，而是被保存下来，当下次重新创建页面时，状态会被恢复。
// 这样可以避免用户在切换页面时，页面状态被重置，导致用户体验不佳。
class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX();

  // 主视图
  Widget _buildView() {
    DateTime? lastPressedAt;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (lastPressedAt == null ||
            DateTime.now().difference(lastPressedAt!) >
                const Duration(seconds: 1)) {
          lastPressedAt = DateTime.now();
          Loading.toast('Press again to exit');
          return false;
        }
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          controller.onJumpToVideo();
        }),
        // 不拓展底部, 内容显示在bar上方
        extendBody: false,
        // 隐藏键盘
        resizeToAvoidBottomInset: false,
        // 导航栏
        bottomNavigationBar: GetBuilder<MainController>(
          id: 'navigation',
          builder: (controller) {
            return Obx(() => BuildNavigation(
                  currentIndex: controller.currentIndex,
                  items: [
                    // 首页
                    NavigationItemModel(
                      label: LocaleKeys.tabBarHome.tr,
                      icon: AssetsSvgs.navHomeSvg,
                    ),

                    // 购物车
                    NavigationItemModel(
                      label: LocaleKeys.tabBarCart.tr,
                      icon: AssetsSvgs.navCartSvg,
                      count: CartService.to.lineItemsCount,
                    ),

                    // 信息
                    NavigationItemModel(
                      label: LocaleKeys.tabBarMessage.tr,
                      icon: AssetsSvgs.navMessageSvg,
                      count: 9,
                    ),

                    // 我的
                    NavigationItemModel(
                      label: LocaleKeys.tabBarProfile.tr,
                      icon: AssetsSvgs.navProfileSvg,
                    ),
                  ],
                  onTap: controller.onJumpToPage, // 切换tab事件
                ));
          },
        ),

        // 主体内容
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onIndexChanged,
          children: const [
            // 加入空页面占位
            HomePage(),
            CartIndexPage(),
            MsgIndexPage(),
            MyIndexPage(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      id: "main",
      builder: (_) => _buildView(),
    );
  }
}
