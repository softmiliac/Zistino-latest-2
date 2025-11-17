import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../style/dimens.dart';
import '../progress_button.dart';

Widget errorWidget(String error,
    {required VoidCallback onTap, double? height}) {
  return Container(
      height: height ?? MediaQuery.of(Get.context!).size.height / 2,
      alignment: AlignmentDirectional.center,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(Get.context!).size.width/24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(error.toString()),
          Text("خطای ارتباط با سرور...",
              style: Get.theme.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
          SizedBox(
            height: MediaQuery.of(Get.context!).size.width/33,
          ),
          // GestureDetector(
          //   onTap: onTap,
          //   child: Container(
          //     alignment: Alignment.center,
          //     width: fullWidth,
          //     padding: EdgeInsets.symmetric(vertical: MediaQuery.of(Get.context!).size.width/33),
          //     decoration: BoxDecoration(
          //       color: Colors.transparent,
          //       border: Border.all(color: Colors.grey),
          //     ),
          //     child: Row(
          //       children: [
          //         Text("تلاش دوباره",
          //             style: Get.theme.textTheme.bodyText2!
          //                 .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
          //         SizedBox(width: MediaQuery.of(Get.context!).size.width/33),
          //         const Icon(
          //           Icons.replay,
          //           color: Colors.grey,
          //         ),
          //       ],
          //     ),
          //   ),
          // )
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(Get.context!).size.width/33)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("تلاش دوباره",
                    style: Get.theme.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w700, letterSpacing: 0.2,
                      color: Colors.white,
                    )),
                SizedBox(width: MediaQuery.of(Get.context!).size.width/92),
                const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
              ],
            ),
          )
          // progressButton(isProgress: false, onTap: onTap,text: "تلاش دوباره"
        ],
      ));
}
