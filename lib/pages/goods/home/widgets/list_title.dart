import 'package:flutter/material.dart';
import 'package:woo_shop/common/index.dart';
import 'package:get/get.dart';

class BuildListTitle extends StatelessWidget {
  final String title;
  final String? subTitle;

  final Function? onTap;

  const BuildListTitle(
      {super.key, required this.title, this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextWidget.title1(title),
        TextWidget.title2(
          subTitle ?? "",
          color: AppColors.primary,
        ).paddingLeft(AppSpace.listItem).expanded(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget.body1(
              LocaleKeys.gHomeMore.tr,
            ),
            const IconWidget.icon(Icons.chevron_right)
          ],
        )
      ],
    );
  }
}
