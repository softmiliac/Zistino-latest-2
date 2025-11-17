import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../binding/address_binding.dart';
import '../controller/transaction_controller.dart';
import '../widgets/transaction_card_wdiget.dart';

class TransactionPage
    extends ResponsiveLayoutBaseGetView<TransactionController> {
  TransactionPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    TransactionBinding().dependencies();
    return GetBuilder(
        init: controller,
        initState: (state) => controller.fetchData(),
        builder: (_) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: AppBar(
              title: const Text('کیف پول'),
              leading: backIcon(),
            ),
            body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  // padding: EdgeInsets.all(standardSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: AlignmentDirectional.center,
                        margin: EdgeInsets.only(
                            right: standardSize,
                            left: standardSize,
                            bottom: xxSmallSize,
                            top: standardSize),
                        child: Text(
                          'اعتبـار کیـف پول',
                          style: theme.textTheme.subtitle1!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: xxSmallSize/2),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: standardSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatNumber(
                                  controller.pref.totalWallet?[0].price ?? 0),
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: xxSmallSize),
                            Text(
                              'ریال',
                              style: theme.textTheme.subtitle1!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: standardSize, top: xxLargeSize),
                        child: Text(
                          'تاریخچه تراکنشات',
                          style: theme.textTheme.subtitle1!
                              .copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      controller.obx((state) {
                          return ListView.builder(
                            padding: EdgeInsetsDirectional.only(
                              top: smallSize,
                              bottom: smallSize,
                            ),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.rpm?.length ?? 0,
                            itemBuilder: (context, index) {
                              return transactionCardWidget(
                                controller.rpm?[index] ?? Wallet(),
                                index == 0
                                    ? IndexPlace.zero
                                    : index + 1 == (controller.rpm?.length ?? 0)
                                        ? IndexPlace.last
                                        : IndexPlace.normal,
                              );
                            },
                          );
                        },
                        onLoading: loadingWidget(),
                        onEmpty: emptyWidget('تبادلی انجام نشده است'),
                        onError: (error) => errorWidget('$error',onTap: () => controller.fetchData()),
                      ),
/*
                    Obx(
                          () {
                        List<BonusModel> items = bonusItems(
                          controller.selectedTab.value,
                        );
                        return
                          ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                bottom: index + 1 < items.length ? standardSize : 0,
                              ),
                              child: bonusItemWidget(
                                bonus: items[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
*/
                    ],
                  ),
                )
          );
        });
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}
