import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woo_shop/common/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  Widget _buildLeftNav() {
    return GetBuilder<CategoryController>(
      id: "left_nav",
      builder: (_) {
        return ListView.separated(
          itemBuilder: (context, index) {
            var item = controller.categoryItems[index];
            return CategoryListItemWidget(
              category: item,
              selectId: controller.categoryId, // 分类id
              onTap: controller.onCategoryTap, // 点击回调
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              // 间隔
              height: AppSpace.listRow.w,
            );
          },
          itemCount: controller.categoryItems.length, // 分裂数量
        )
            .width(100.w)
            .decorated(
              color: AppColors.surfaceVariant,
            )
            .clipRRect(
              topRight: AppRedius.card.w,
              bottomRight: AppRedius.card.w,
            );
      },
    );
  }

  Widget _buildRightList() {
    return GetBuilder<CategoryController>(
      id: "product_list",
      builder: (_) {
        return Container();
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildLeftNav(),
      _buildRightList().expanded(),
    ].toRow();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      init: CategoryController(),
      id: "category",
      builder: (_) {
        return Scaffold(
          appBar: mainAppBarWidget(
            titleString: LocaleKeys.gCategoryTitle.tr,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
