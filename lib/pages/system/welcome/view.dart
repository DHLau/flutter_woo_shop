import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';
import 'index.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  // slider 视图
  Widget _buildSlider() {
    return GetBuilder<WelcomeController>(
      id: "slider",
      init: controller,
      builder: (controller) => controller.items == null
          ? const SizedBox()
          : WelcomeSliderWidget(controller.items!,
              carouselController: controller.carouselController,
              onPageChanged: controller.onPageChanged),
    );
  }

  // skip + indicator + next
  Widget _buildBar() {
    return GetBuilder<WelcomeController>(
        id: "bar",
        init: controller,
        builder: (controller) {
          return controller.isShowStart
              ?
              // 开始
              ButtonWidget.primary(
                  LocaleKeys.welcomeStart.tr,
                  // 方法定义在了控制器中
                  onTap: controller.onToMain,
                )
              : <Widget>[
                  // 跳过按钮
                  ButtonWidget.text(
                    LocaleKeys.welcomeSkip.tr,
                    onTap: controller.onToMain,
                  ),

                  // 指示器
                  SliderIndicatorWidget(
                      length: 3, currentIndex: controller.currentIndex),

                  // 下一页
                  ButtonWidget.text(
                    LocaleKeys.welcomeNext.tr,
                    onTap: controller.onNext,
                  ),
                ].toRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                );
        });
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      // slider切换
      _buildSlider(),
      // 控制栏
      _buildBar(),
    ]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
        .paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
      init: WelcomeController(),
      id: "welcome",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("welcome")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
