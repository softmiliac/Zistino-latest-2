// import 'package:admin_zistino/src/presentation/ui/inv/basket_controller/basket_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive_flutter/adapters.dart';
// import '../../common/utils/hive_utils/hive_utils.dart';
// import '../../domain/entities/inv/basket_item.dart';
// import '../style/colors.dart';
// import '../style/dimens.dart';
//
// Widget counterBoxWidget({
//   required BasketItem item,
//
//   RxInt? count,
//   required TextEditingController textEditingController,
//   bool isDisabled = false,
//   Widget? prefixWidget,
//   Widget? suffixWidget,
//   Color? labelEnabledColor,
//   Color? labelDisabledColor,
// }) {
//   final BasketController basketController = Get.find();
//   final theme = Get.theme;
//   // return Obx(() {
//  return ValueListenableBuilder(
//       valueListenable: Boxes.getBasketBox().listenable(),
//   builder: (context, box, widget) {
//   return
//   Container(
//         height: xxLargeSize/1.3,
//         width: xxLargeSize/1.3,
//         decoration: BoxDecoration(
//           color: AppColors.splashColor,
//           border: Border.all(
//             color: Colors.white,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(xSmallRadius),
//         ),
//         // padding: EdgeInsetsDirectional.only(
//         //   start: xSmallSize,
//         //   end: xSmallSize,
//         // ),
//         child: Row(
//           children: [
//             suffixWidget ??
//                 GestureDetector(
//                   onTap: () {
//                     basketController.increase(item.id);
//                       // if (count != null) {
//                       //   count.value = count.value + 1;
//                       //   textEditingController.text = count.value.toString();
//                       // }
//                   },
//                   child: Container(
//                     height: xxLargeSize/1.3,
//                     width: xxLargeSize/1.3,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       border: Border.all(
//                         color: AppColors.backgroundColor,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(xSmallRadius),
//                     ),
//                     child: Icon(
//                       Icons.add,
//                       color: theme.backgroundColor,
//                     ),
//                   ),
//                 ),
//             Expanded(
//               child: Text(basketController.checkItemCount(item.id).toString(),
//               style: theme.textTheme.subtitle2,
//                 textAlign: TextAlign.center,
//               ),
// /*
//               child: TextFormField(
//                 controller: textEditingController,
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 enabled: isDisabled,
//                 textInputAction: TextInputAction.done,
//                 style: theme.textTheme.bodyText1?.copyWith(
//                     color: Colors.black),
//                 onChanged: (value) => count?.value = int.parse(value),
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     top: standardSize / 1.2,
//                     bottom: standardSize / 1.2,
//                   ),
//                   border: InputBorder.none,
//                   fillColor: Colors.transparent,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   focusedErrorBorder: InputBorder.none,
//                 ),
//               ),
// */
//             ),
//             prefixWidget ??
//                 GestureDetector(
//                   onTap: () {
//                     basketController.decrease(item.id);
//
//                     // if (count != null) {
//                       //   if (count.value != 0) {
//                       //     count.value = count.value - 1;
//                       //   }
//                       //   textEditingController.text = count.value.toString();
//                       // }
//                   },
//                   child: Container(
//                     height: xxLargeSize/1.3,
//                     width: xxLargeSize/1.3,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       border: Border.all(
//                         color: AppColors.backgroundColor,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(xSmallRadius),
//                     ),
//                     child: Icon(
//                       Icons.remove,
//                       color: theme.backgroundColor,
//                     ),
//                   ),
//                 ),
//           ],
//         ),
//       );
//     }
//   );
// }
