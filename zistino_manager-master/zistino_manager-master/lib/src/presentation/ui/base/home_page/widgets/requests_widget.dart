// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../../../../domain/entities/base/driver_delivery.dart';
// import '../../../../style/dimens.dart';
// import '../../../inv/residue_page/binding/binding.dart';
// import '../../../inv/residue_page/view/select_residue_page.dart';
//
// Widget requestWidgetMap(DriverDeliveryEntity model) {
//   return GestureDetector(
//     onTap: () {
//       Get.to(
//           SelectResiduePage(
//             isFromMain: false,
//             driverDeliveryEntity: model,
//           ),
//           binding: ResiduePriceBinding());
//     },
//     child: Container(
//       width: fullWidth / 1.2,
//       margin: EdgeInsetsDirectional.only(
//           top: standardSize, end: smallSize, start: smallSize),
//       padding: EdgeInsetsDirectional.all(standardSize),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(xSmallRadius),
//         color: Colors.white,
//         // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
//         // spreadRadius: 3
//         // )]
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SvgPicture.asset('assets/ic_close-circle.svg'),
//           _rowItems('assets/ic_frame.svg', model.creator),
//           SizedBox(
//             height: smallSize,
//           ),
//           _rowItems('assets/ic_location.svg', model.address),
//           SizedBox(
//             height: smallSize,
//           ),
//           _rowItems('assets/ic_call.svg', model.phoneNumber),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget requestEmptyWidgetMap() {
//   return Container(
//     width: fullWidth,
//     margin: EdgeInsetsDirectional.only(
//         top: standardSize, end: standardSize, start: standardSize),
//     padding: EdgeInsetsDirectional.all(standardSize),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(xSmallRadius),
//       color: Colors.white,
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "سفارشی ثبت نشده است.",
//           style: Get.theme.textTheme.bodyText1
//               ?.copyWith(fontWeight: FontWeight.w600),
//         )
//       ],
//     ),
//   );
// }
//
// Widget _rowItems(String icon, String name) {
//   final theme = Get.theme;
//
//   return Row(
//     children: [
//       SvgPicture.asset(
//         icon,
//         color: theme.primaryColor,
//       ),
//       SizedBox(width: smallSize),
//       Expanded(
//         child: Text(
//           name,
//           style: theme.textTheme.subtitle1,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ),
//       )
//     ],
//   );
// }
