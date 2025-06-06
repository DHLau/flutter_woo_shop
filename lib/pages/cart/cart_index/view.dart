import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class CartIndexPage extends GetView<CartIndexController> {
  const CartIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("CartIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartIndexController>(
      init: CartIndexController(),
      id: "cart_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Cart")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
