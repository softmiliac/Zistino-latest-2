// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../fake_model/bonus_model.dart';
import '../../../fake_model/introduction_model.dart';
import '../../../fake_model/order_model.dart';
import '../../../fake_model/product_model.dart';
import '../../../fake_model/request_model.dart';
import '../../../fake_model/residual_model.dart';
import '../../../fake_model/residue_fake_model.dart';
import '../../../fake_model/residue_type_model.dart';
import '../../../fake_model/transaction_model.dart';
import '../../presentation/style/colors.dart';
import '../../presentation/style/dimens.dart';

List<IntroductionModel> introductionData() {
  List<IntroductionModel> introductionDataFake = [];

  introductionDataFake.add(IntroductionModel(
      image: 'assets/pic_intro1.svg',
      text: '« با زیستینو پاکیزگی خانه و شهر »'));
  introductionDataFake.add(IntroductionModel(
      image: 'assets/pic_intro2.svg', text: '« با زیستینو هر زمان و هر کجا »'));
  introductionDataFake.add(IntroductionModel(
      image: 'assets/pic_intro3.svg', text: '« با زیستینو راحت و سریع »'));

  return introductionDataFake;
}

List<ResidueFakeModel> residueData() {
  List<ResidueFakeModel> residue = [];

  residue.add(ResidueFakeModel(
      id: 0,
      name: "کفش",
      colors: [const Color(0xff00e4f3), const Color(0xff01add3)],
      icon: 'assets/ic_shoe.png',
      picture: 'https://s6.uupload.ir/files/shoes-17775_977s.png',
      highestPrice: '1,540',
      pricePerKg: '1,540',
      description: 'پسماند تمامی کفشها'));
  residue.add(ResidueFakeModel(
      id: 0,
      name: "آهـن",
      colors: [Colors.pink.shade300, Colors.pink.shade400],
      icon: 'assets/ic_iron.png',
      picture: 'https://s6.uupload.ir/files/ahan_1dzl.png',
      highestPrice: '5,225',
      pricePerKg: '5,225',
      description:
          'لوله های چدنی، سینک های چدنی، رادیاتور های چدنی، تیر آهن، میلگرد، بدنه موتور سیکلت...'));
  residue.add(ResidueFakeModel(
      id: 0,
      name: "پـت",
      colors: [Colors.yellow.shade300, Colors.yellow.shade400],
      icon: 'assets/ic_bottle.png',
      picture: 'https://s6.uupload.ir/files/roghan_jx7s.png',
      highestPrice: '7,150',
      pricePerKg: '7,150',
      description:
          'گت یکی از انواع پلیمر های پلاستیکی است که به صورت مخفف نام علمی polyethylene terephthalate شناخته میشود.\n***در واقع پت بیشتر پلاستیک شفافی است که از ویژگی هایی مانند مقاومت در برابر آفتاب و نیز حل شدن کمتر در مایعات خوراکی برخوردار است.'));

  return residue;
}

List<ProductModel> productData() {
  List<ProductModel> product = [];

  product.add(ProductModel(
    id: 0,
    picture: 'https://s6.uupload.ir/files/green_shampoo_ba4h.png',
    name: "شامپو تقویت مو اکسیر برای آقایان",
    price: '480,000',
  ));
  product.add(ProductModel(
    id: 1,
    picture: 'https://s6.uupload.ir/files/purple_shampoo_9e6l.png',
    name: "شامپو تقویت مو اکسیر برای بانوان",
    price: '490,000',
  ));
  product.add(ProductModel(
    id: 0,
    picture: 'https://s6.uupload.ir/files/green_shampoo_ba4h.png',
    name: "شامپو تقویت مو اکسیر برای آقایان",
    price: '480,000',
  ));
  product.add(ProductModel(
    id: 1,
    picture: 'https://s6.uupload.ir/files/purple_shampoo_9e6l.png',
    name: "شامپو تقویت مو اکسیر برای بانوان",
    price: '490,000',
  ));
  product.add(ProductModel(
    id: 0,
    picture: 'https://s6.uupload.ir/files/green_shampoo_ba4h.png',
    name: "شامپو تقویت مو اکسیر برای آقایان",
    price: '480,000',
  ));
  product.add(ProductModel(
    id: 1,
    picture: 'https://s6.uupload.ir/files/purple_shampoo_9e6l.png',
    name: "شامپو تقویت مو اکسیر برای بانوان",
    price: '490,000',
  ));
  product.add(ProductModel(
    id: 0,
    picture: 'https://s6.uupload.ir/files/green_shampoo_ba4h.png',
    name: "شامپو تقویت مو اکسیر برای آقایان",
    price: '480,000',
  ));
  product.add(ProductModel(
    id: 1,
    picture: 'https://s6.uupload.ir/files/purple_shampoo_9e6l.png',
    name: "شامپو تقویت مو اکسیر برای بانوان",
    price: '490,000',
  ));

  return product;
}

// List<FlSpot> walletChartSpots() {
//   List<FlSpot> items = const [
//     FlSpot(0, 1.5),
//     FlSpot(1, 1.9),
//     FlSpot(2, 2.9),
//     FlSpot(3, 3.9),
//     FlSpot(4, 4.0),
//     FlSpot(5, 3.0),
//     FlSpot(6, 4.0),
//     FlSpot(6.5, 4.2),
//   ];
//   return items;
// }

List<BonusModel> bonusItems(int category) {
  List<BonusModel> items = [];
  if (category == 0 || category == 4) {
    items.add(
      BonusModel(
        icon: "assets/ic_medal_star.svg",
        title: "Activation Bonus",
        descriptionWidget: RichText(
          text: TextSpan(
            text: "Activate Your Account ",
            style: Get.theme.textTheme.bodyText2?.copyWith(
              color: Get.theme.primaryColor, //TODO: Set color
            ),
            children: [
              TextSpan(
                text: " To Get 5\$ Activation bonus for free",
                style: Get.theme.textTheme.bodyText2?.copyWith(
                  color: const Color(0xFFB3B3B3), //TODO: Set color
                ),
              )
            ],
          ),
        ),
        progress: 1,
        total: 1,
      ),
    );
    items.add(
      const BonusModel(
        icon: "assets/ic_magic_star.svg",
        title: "Welcome Bonus +50%",
        description: "Redeem The 50% Welcome Bonus On Your First Deposit",
        progress: 0,
        total: 100,
      ),
    );
  }
  if (category == 1 || category == 4) {
    items.add(
      const BonusModel(
        icon: "assets/ic_eye.svg",
        title: "1000 Views Bonus",
        description:
            "Get 10\$ bonus once you reach a total number of 1000 views your posts.",
        progress: 50,
        total: 1000,
      ),
    );
  }
  if (category == 2 || category == 4) {
    items.add(
      const BonusModel(
        icon: "assets/ic_heart.svg",
        title: "1000 Likes Bonus",
        description:
            "Get 10\$ bonus once you reach a total number of 1000 likes your posts.",
        progress: 100,
        total: 1000,
      ),
    );
  }
  if (category == 3 || category == 4) {
    items.add(
      const BonusModel(
        icon: "assets/ic_eye.svg",
        title: "1,000,000 Views Bonus",
        description:
            "Get 10\$ bonus once you reach a total number of 1,000,000 views your posts.",
        progress: 700000,
        total: 1000000,
      ),
    );
    items.add(
      const BonusModel(
        icon: "assets/ic_heart.svg",
        title: "1,000,000 Likes Bonus",
        description:
            "Get 10\$ bonus once you reach a total number of 1,000,000 likes your posts.",
        progress: 950000,
        total: 1000000,
      ),
    );
  }
  items.add(
    BonusModel(
      icon: "assets/ic_profile_2user.svg",
      title: "Invitation Rewards",
      description:
          "Get 10\$ bonus once you reach a total number of 1,000,000 likes your posts.",
      progress: 1,
      total: 10,
      separateCounter: true,
      footer: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(smallRadius),
            border: Border.all(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
          margin: EdgeInsetsDirectional.only(
            top: standardSize,
            bottom: standardSize,
          ),
          padding: EdgeInsetsDirectional.only(
            start: standardSize,
            top: xSmallSize,
            bottom: xSmallSize,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: xxSmallSize,
                    bottom: xxSmallSize,
                  ),
                  child: SvgPicture.asset(
                    "assets/ic_link.svg",
                  ),
                ),
                SizedBox(width: xSmallSize),
                Expanded(
                  child: Text(
                    "https://metayork.com/?ref=4595456",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFAEAEAE), // TODO: Set color
                    ),
                  ),
                ),
                SizedBox(width: xSmallSize),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: const Color(0xFF474747).withOpacity(0.3),
                ),
                SizedBox(width: xxSmallSize),
                Container(
                  padding: EdgeInsetsDirectional.only(
                      top: xxSmallSize,
                      bottom: xxSmallSize,
                      start: xSmallSize,
                      end: standardSize),
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text: "https://metayork.com/?ref=4595456",
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/ic_copy.svg",
                        ),
                        SizedBox(width: xxSmallSize),
                        Text("copy".tr),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actionText: "share".tr,
      actionForceEnabled: true,
      onTap: () {
        Share.share("https://baxbeauty.com/ref?=4595456");
      },
      onActionTap: () {
        Share.share("https://baxbeauty.com/ref?=4595456");
      },
    ),
  );
  return items;
}

List<String> walletTabBarItems() {
  List<String> items = [
    "همه".tr,
    "سالانه".tr,
    "ماهانه".tr,
    "هفتگی".tr,
    "روزانه",
  ];
  return items;
}

List<TransactionModel> transactionsData() {
  List<TransactionModel> items = [];
  items.add(TransactionModel(
    description: "واریز",
    value: 64,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: -6,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: 5,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: -6,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: -6,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: 64,
    date: "10/07/2020",
    isEnabled: true,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: 5,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: 64,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: 5,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: 64,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "واریز",
    value: -6,
    date: "10/07/2020",
    isEnabled: false,
  ));
  items.add(TransactionModel(
    description: "برداشت",
    value: 5,
    date: "10/07/2020",
    isEnabled: false,
  ));

  return items;
}

List<RequestModel> requestModelFake() {
  List<RequestModel> requestList = [];
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3198405,
    long: 59.5909562,
  ));
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3128405,
    long: 59.5901562,
  ));
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3928405,
    long: 59.5909562,
  ));
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3128405,
    long: 59.5909962,
  ));
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3128405,
    long: 59.5909569,
  ));
  requestList.add(RequestModel(
    name: 'علیرضا اسلمی',
    address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
    phoneNumber: '07515151515',
    lat: 36.3128409,
    long: 59.5909562,
  ));
  return requestList;
}

List<OrdersModel> orderCategoryData() {
  List<OrdersModel> orderCategoryFake = [];

  orderCategoryFake.add(OrdersModel(
      id: 0,image: 'assets/ic_active_order.png', text: 'سفارش فعال',status: 0));
  orderCategoryFake.add(OrdersModel(
      id: 2,image: 'assets/ic_cancel_order.png', text: 'در انتظار تایید کاربر',status: 4));
  orderCategoryFake.add(OrdersModel(
      id: 2,image: 'assets/ic_cancel_order.png', text: 'سفارش لغو شده',status: 3));//todo status change to list<status>
  orderCategoryFake.add(OrdersModel(
      id: 1,image: 'assets/ic_finish_order.png', text: 'سفارش پایان یافته',status: 5));//todo status change to list<status>



  return orderCategoryFake;
}
List<BonusModel> ordersDetailData() {
  List<BonusModel> ordersDetailFake = [];

  ordersDetailFake.add(BonusModel(
      icon: '', title: 'درخواست جمع آوری',description: 'خانه'
  ));
  ordersDetailFake.add(BonusModel(
      icon: '', title: 'تاریخ ثبت سفارش',description: '16 آبان 1401'
  ));

  return ordersDetailFake;
}

List<ResidueModel> residualModelFake() {
  List<ResidueModel> list = [];
  list.add(const ResidueModel(
      title: 'پسماند شیشه',
      priceKG: '200',
      highPrice: '200',
      total: '200',
      kg: '2',
      image: 'assets/images/glass_residual.png'));
  list.add(const ResidueModel(
      title: 'پسماند پلاستیک',
      priceKG: '200',
      highPrice: '200',
      total: '200',
      kg: '2',
      image: 'assets/images/pelastic_residual.png'));
  list.add(const ResidueModel(
      title: 'پسماند کاغذ و کارتن',
      priceKG: '200',
      highPrice: '200',
      total: '200',
      kg: '2',
      image: 'assets/images/paper_residual.png'));

  return list;
}

List<ResidueTypeModel> residueTypeFakeData() {
  List<ResidueTypeModel> list = [];
  list.add(ResidueTypeModel(
      name: "پسماند شیشه", image: "assets/images/glass_residual.png"));
  list.add(ResidueTypeModel(
      name: "پسماند فلزات", image: "assets/images/glass_residual.png"));
  list.add(ResidueTypeModel(
      name: "پسماند پلاستیک", image: "assets/images/pelastic_residual.png"));
  list.add(ResidueTypeModel(
      name: "پسماند کاغذ و کارتن", image: "assets/images/paper_residual.png"));
  list.add(
      ResidueTypeModel(name: "پسماند درهم", image: "assets/images/img.png"));
  return list;
}
