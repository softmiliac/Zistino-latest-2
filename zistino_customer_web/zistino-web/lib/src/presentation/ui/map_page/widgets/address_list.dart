import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/services/get_storage_service.dart';
import '../../../style/dimens.dart';
import '../../base/residue_price_page/binding/binding.dart';
import '../../inv/residue_page/view/select_residue_page.dart';

Widget addressList() {
  final LocalStorageService pref = Get.find();
  var theme = Get.theme;

  return SizedBox(
    height: xxLargeSize,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: pref.addresses.length,
      padding: EdgeInsetsDirectional.only(
        start: standardSize,
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
  debugPrint('${pref.addresses[index].id} asdasdsad');
        return GestureDetector(
          onTap: () {
            Get.to(
                SelectResiduePage(
                  addressId: pref.addresses[index].id,
                ),
                binding: ResiduePriceBinding());
            // Get.to(CreateDriverDelivery(
            // address: pref.addresses[index],
            // ));
          },
          child: Container(
            width: fullWidth / 2.8,
            margin: EdgeInsetsDirectional.only(end: standardSize),
            padding: EdgeInsets.symmetric(
                horizontal: smallSize, vertical: xSmallSize),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(smallRadius),
            ),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.all(xxSmallSize),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryColor.withOpacity(0.15)),
                    child: SvgPicture.asset(
                      'assets/ic_location.svg',
                      color: theme.primaryColor,
                    )),
                SizedBox(width: xxSmallSize),
                Expanded(
                  child: Text(pref.addresses[index].title?.trim() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2),
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}
