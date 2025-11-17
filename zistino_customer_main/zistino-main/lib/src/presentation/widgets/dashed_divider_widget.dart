import 'package:flutter/material.dart';

Widget dashedDividerWidget({
  double dashWidth = 3.0,
  double dashHeight = 1,
  Color? dashColor,
}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: List.generate(
          dashCount,
          (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: dashColor ?? Colors.grey,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
