import 'package:zistino/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../../../base/home_page/controller/home_controller.dart';
import '../../../base/request_detail_page/view/request_detail_page.dart';
import '../controller/review_controller.dart';

// ignore: must_be_immutable
class ReviewPage extends StatelessWidget {
  ReviewPage({this.entity , Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  DriverDeliveryEntity? entity;

  final ReviewController controller = Get.put(ReviewController());



  @override
  Widget build(BuildContext context) {
    var a = Get.arguments as DriverDeliveryEntity;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: AppColors.shadowColor.withOpacity(0.2),
        elevation: 15,
        title: Text('بازخورد جمع آوری',
            style: theme.textTheme.subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          splashRadius: standardSize,
          splashColor: AppColors.splashColor,
          icon: Icon(CupertinoIcons.clear_thick,
              size: iconSizeSmall, color: Colors.black),
          onPressed: () {
            Get.off(RequestDetailPage(entity: a));
            // Get.back();
          },
        ),
        backgroundColor: theme.backgroundColor,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: standardSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(
                  start: standardSize, end: standardSize, bottom: standardSize),
              child: Obx(() {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 130),
                  opacity: controller.rating.value == 0.0 ? 0.5 : 1,
                  child: progressButton(
                      text: 'ثبت بازخورد',
                      isDisable: false,
                      isProgress: controller.isBusyReview.value,
                      onTap: () {
                        controller.sendDataToServer(a);
                      }),
                );
              }),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(
                  start: standardSize, end: standardSize),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.eye_slash,
                        size: iconSizeSmall, color: AppColors.captionColor),
                    SizedBox(width: smallSize),
                    Text(
                      "نظرات شما با حفظ حریم شخصیتان ثبت خواهد شد.",
                      style: theme.textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.captionColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(standardSize),
        child: Column(
          children: [
            RatingBar.builder(
              itemCount: 5,
              unratedColor: theme.primaryColor.withOpacity(0.25),
              allowHalfRating: false,
              minRating: 1,
              glowColor: theme.dividerColor,
              textDirection: TextDirection.ltr,
              itemPadding: EdgeInsets.symmetric(horizontal: xxSmallSize),
              initialRating: controller.rating.value,
              itemBuilder: (context, index) {
                return Icon(CupertinoIcons.star_fill,
                    color: theme.primaryColor);
              },
              onRatingUpdate: (double value) {
                controller.fake.clear();
                controller.rating.value = value;
                if (value <= 2) {
                  controller.selectedType.value = 1;
                } else {
                  controller.selectedType.value = 0;
                }
                controller.getData();
              },
            ),
            SizedBox(height: largeSize),
            Obx(() {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(smallRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectedType.value = 0;
                          controller.getData();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(smallSize),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallRadius),
                              color: controller.selectedType.value == 0
                                  ? theme.primaryColor
                                  : Colors.transparent),
                          child: Text("نقاط قوت",
                              style: theme.textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedType.value == 0
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ),
                    SizedBox(width: standardSize),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectedType.value = 1;
                          controller.getData();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(smallSize),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallRadius),
                              color: controller.selectedType.value == 1
                                  ? theme.primaryColor
                                  : Colors.transparent),
                          child: Text("نقاط ضعف",
                              style: theme.textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedType.value == 1
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: largeSize),
            Obx(() {
              return GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.fakeReview.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 8 / 5,
                      crossAxisSpacing: standardSize,
                      mainAxisSpacing: standardSize),
                  itemBuilder: (context, index) {
                    RxBool isSelected = false.obs;
                    return Obx(() {
                      return GestureDetector(
                        onTap: () {
                          isSelected.value = !isSelected.value;
                          controller
                              .addFavoriteItem(controller.fakeReview[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(smallSize),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallRadius),
                              color: controller.selectedType.value == 1 &&
                                  isSelected.value
                                  ? Colors.red.withOpacity(0.1)
                                  : isSelected.value
                                  ? theme.primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                  color: controller.selectedType.value == 1
                                      ? Colors.red
                                      : theme.primaryColor)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible: false,
                                child: Checkbox(
                                  value: isSelected.value,
                                  onChanged: (value) {
                                    isSelected.value = value ?? false;
                                  },
                                ),
                              ),
                              Text(controller.fakeReview[index].text,
                                style: theme.textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                // maxLines: 2,
                                // overflow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
            }),
          ],
        ),
      ),
    );
  }




}
