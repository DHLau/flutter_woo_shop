import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';

class LoginController extends GetxController {
  LoginController();

  final _countryCode = "+86".obs; // 国家编码
  get countryCode => _countryCode.value;

  final _phoneValue = "".obs;
  get phoneValue => _phoneValue.value;

  final _agreeStatus = false.obs;
  get agreeStatus => _agreeStatus.value;

  final TextEditingController inputController = TextEditingController();

  void inputChange(String value) {
    _phoneValue.value = value;
    update(["loginbtn"]);
  }

  bool get canCommit {
    if (agreeStatus == false || phoneValue.length != 11) {
      return false;
    }
    return true;
  }

  void loginBtnClick() {
    if (agreeStatus == false) {
      Get.snackbar("提示", "请同意协议");
      return;
    }

    if (phoneValue.length != 11) {
      Get.snackbar("提示", "请输入正确的手机号码");
      return;
    }

    // 跳转到首页
    Get.offAllNamed(RouteNames.systemMain);
  }

  void agreeClick() {
    _agreeStatus.value = !_agreeStatus.value;
    update(["agree"]);
    update(["loginbtn"]);
  }

  // _initData() {}

  // void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    // _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
