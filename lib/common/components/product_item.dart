import 'package:flutter/material.dart';
import 'package:woo_shop/common/index.dart';
import 'package:get/get.dart';

class ProductItemWidget extends StatelessWidget {
  /// 点击事件
  final Function()? onTap;

  /// 商品数据模型
  final ProductModel product;

  /// 图片宽
  final double? imgWidth;

  /// 图片高
  final double? imgHeight;

  const ProductItemWidget(
    this.product, {
    super.key,
    this.onTap,
    this.imgWidth,
    this.imgHeight,
  });

  Widget _buildView(BoxConstraints constraints) {
    var ws = <Widget>[
      // 图片
      IconWidget.url(product.images?.first.src ?? '',
          fit: BoxFit.cover,
          width: imgWidth ?? constraints.minWidth,
          height: imgHeight),

      // 描述
      <Widget>[
        // 标题
        TextWidget.body2(product.name ?? ''),

        // 价格
        if (product.price != null)
          TextWidget.body2(
            product.price ?? '',
            weight: FontWeight.bold,
          ),
      ]
          .toColumn(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .paddingHorizontal(5)
          .expanded(),
    ];

    return ws
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .card(
          blurRadius: 5,
        )
        .padding(all: 5)
        .onTap(() {
      if (onTap != null) {
        onTap?.call();
      } else {
        Get.toNamed(RouteNames.goodsProductDetails, arguments: {
          "id": product.id,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildView(constraints);
      },
    );
  }
}
