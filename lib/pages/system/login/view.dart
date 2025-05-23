import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';
import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget _buildHint() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        left: 16,
      ),
      height: 48,
      width: double.infinity,
      child: Text(
        "未注册的手机号验证通过后将自动注册",
        style: TextStyle(color: Colors.black.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildRemind() {
    return GetBuilder<LoginController>(
        init: controller,
        id: "agree",
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              controller.agreeClick();
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                child: Row(children: [
                  Image(
                      image: controller.agreeStatus == true
                          ? AssetImage(AssetsImages.checkboxPng)
                          : AssetImage(AssetsImages.uncheckboxPng),
                      width: 16,
                      height: 16),
                  SizedBox(
                    width: 6,
                  ),
                  Text("同意<<用户协议>>")
                ]),
              ),
            ),
          );
        });
  }

  Widget _buildSep() {
    return GetBuilder<LoginController>(
      init: controller,
      id: "loginbtn",
      builder: (_) {
        return Container(
          margin: const EdgeInsets.only(left: 16),
          width: double.infinity,
          height: 0.5,
          color: AppColors.outline,
        );
      },
    );
  }

  Widget _buildLoginBtn() {
    return GetBuilder<LoginController>(
        init: controller,
        id: "loginbtn",
        builder: (_) {
          return GestureDetector(
            onTap: () {
              controller.loginBtnClick();
            },
            child: Container(
                margin: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 16, right: 16),
                alignment: Alignment.center,
                width: double.infinity,
                height: 48,
                child: Text(
                  "验证并登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                )),
          );
        });
  }

  Widget _buildInput() {
    return GetBuilder<LoginController>(
      init: controller,
      id: "input",
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          width: double.infinity,
          height: 56,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Todo... 选择弹窗
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  width: 65,
                  height: 56,
                  child: Row(
                    children: [
                      Text(controller.countryCode),
                      Image(image: AssetImage(AssetsImages.caretDownSmallPng))
                    ],
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: 32,
                color: AppColors.outline,
              ),
              InputWidget.text(
                  controller: controller.inputController,
                  hintText: "请输入手机号",
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    controller.inputChange(value);
                  }).expanded()
            ],
          ),
        );
      },
    );
  }

  Container _buildTitle() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20, top: 52, bottom: 16),
        child: const Text(
          "Welcome to Woo",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ));
  }

  // 主视图
  Widget _buildView() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitle(),
        _buildInput(),
        _buildSep(),
        _buildHint(),
        _buildRemind(),
        _buildLoginBtn(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
