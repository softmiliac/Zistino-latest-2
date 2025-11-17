import 'package:flutter/material.dart';

import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

Widget timelineWidget(IndexPlace indexPlace, bool isEnabled) {
  return SizedBox(
    width: smallSize,
    height: fullWidth / 6.4,
    child: Stack(
      children: [
        indexPlace == IndexPlace.zero || indexPlace == IndexPlace.last
            ? Align(
                alignment: indexPlace == IndexPlace.zero
                    ? const Alignment(0, 1)
                    : const Alignment(0, -1),
                child: Container(
                  width: 1,
                  height: largeSize / 0.85,
                  color: const Color(0xffC4C4C4),
                ),
              )
            : Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  width: 1,
                  height: fullWidth / 6,
                  color: const Color(0xffC4C4C4),
                ),
              ),
        Align(
          alignment: const Alignment(0, 0),
          child: Container(
            width: fullWidth / 48,
            height: fullWidth / 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(standardSize),
              ),
              color: isEnabled ? AppColors.primaryColor : const Color(0xFFC4C4C4),
            ),
          ),
        ),
      ],
    ),
  );
}
