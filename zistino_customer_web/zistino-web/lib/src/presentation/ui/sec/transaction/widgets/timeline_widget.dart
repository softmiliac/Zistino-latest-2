import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';

Widget timelineWidget(IndexPlace indexPlace, bool isEnabled) {
  return SizedBox(
    width: MediaQuery.of(Get.context!).size.width/33,
    height: MediaQuery.of(Get.context!).size.width / 6.4,
    child: Stack(
      children: [
        indexPlace == IndexPlace.zero || indexPlace == IndexPlace.last
            ? Align(
                alignment: indexPlace == IndexPlace.zero
                    ? const Alignment(0, 1)
                    : const Alignment(0, -1),
                child: Container(
                  width: 1,
                  height: MediaQuery.of(Get.context!).size.width/16 / 0.85,
                  color: const Color(0xffC4C4C4),
                ),
              )
            : Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  width: 1,
                  height: MediaQuery.of(Get.context!).size.width / 6,
                  color: const Color(0xffC4C4C4),
                ),
              ),
        Align(
          alignment: const Alignment(0, 0),
          child: Container(
            width: MediaQuery.of(Get.context!).size.width / 48,
            height: MediaQuery.of(Get.context!).size.width / 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(Get.context!).size.width/24),
              ),
              color: isEnabled ? AppColors.primaryColor : const Color(0xFFC4C4C4),
            ),
          ),
        ),
      ],
    ),
  );
}
