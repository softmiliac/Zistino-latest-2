import 'package:fl_chart/fl_chart.dart';
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
import '../../../fake_model/residue_fake_model.dart';
import '../../../fake_model/review_model.dart';
import '../../../fake_model/terms_and_conditions_model.dart';
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

List<OrdersModel> orderCategoryData() {
  List<OrdersModel> orderCategoryFake = [];

  orderCategoryFake.add(OrdersModel(
      id: 0,
      image: 'assets/ic_active_order.png',
      text: 'سفارش فعال',
      statusRequest: 1));
  orderCategoryFake.add(OrdersModel(
      id: 1,
      image: 'assets/ic_finish_order.png',
      text: 'سفارش پایان یافته',
      statusRequest: 5));
  orderCategoryFake.add(OrdersModel(
      id: 2,
      image: 'assets/ic_cancel_order.png',
      text: 'سفارش لغو شده',
      statusRequest: 3));

  return orderCategoryFake;
}

List<BonusModel> ordersDetailData() {
  List<BonusModel> ordersDetailFake = [];

  ordersDetailFake.add(
      BonusModel(icon: '', title: 'درخواست جمع آوری', description: 'خانه'));
  ordersDetailFake.add(BonusModel(
      icon: '', title: 'تاریخ ثبت سفارش', description: '16 آبان 1401'));

  return ordersDetailFake;
}

List<TermsAndConditionsModel> termsAndConditionsData() {
  List<TermsAndConditionsModel> termsAndConditionsFake = [];

  termsAndConditionsFake
      .add(TermsAndConditionsModel(title: 'سیاست حفظ حریم خصوصی', desc: 'بدون شک احتمال این وجود دارد که در بخشی از سایت مشکل خاصی بوجود بیاید یا اینکه لینکی به خارج از سایت حتی در بخش نظرات وجود داشته باشد که امنیت اطلاعات شخصی کاربران عزیزمان را به مخاطره بیاندازد، در هر شرایط و موقعیتی ما نیازمند نظارت دقیق شما کاربران هستیم و در صورت مشاهده‌ی هر گونه مشکلی، درخواست می‌کنیم که به بخش تماس با ما فورا اطلاع دهید و به طور کامل مشکل را توضیح دهید. اینگونه ما نیاز با خیالی آسوده تر از حریم خصوصی شما محافظت خواهیم کرد و می‌دانیم که حتی اگر چشمان ما توان مشاهده همه مشکلات را نداشت، نظارت شما ما را هدایت خواهد کرد.'));
  termsAndConditionsFake
      .add(TermsAndConditionsModel(title: 'محدوده', desc: 'این سیاست حفظ حریم خصوصی به هر نوع دستگاه دیجیتالی که از این برنامه و اپلیکیشن استفاده می نماید، اعمال میشود. سیاست حفظ حریم خصوصی بدون توجه به نوع دستگاه مورد استفاده شما(انواع رایانه، تلفن همراه، تبلت) برای دسترسی به سرویسهای ما  اعمال میشود.'));
  termsAndConditionsFake
      .add(TermsAndConditionsModel(title: 'اطلاعاتی که جمع آوری می کنیم', desc: 'ما اطلاعات محدودی را در رابطه با سرویس¬هایمان جمع آوری میکنیم، شامل: اطلاعاتی که شما مستقیماً در اختیار ما قرارمیدهید اطلاعاتی که ما درباره استفاده شما از سرویسهایمان جمع آوری میکنیم؛ همچنين ممکن است برای جمع آوری اطلاعاتی که در سیاست حفظ حریم خصوصی بیان نشده است، رضایت شما را بخواهیم.'));
  termsAndConditionsFake
      .add(TermsAndConditionsModel(title: 'استفاده و اشتراک گذاری اطلاعات', desc: 'ما از اطلاعات جمع آوری¬شده، علاوه بر اهداف دیگر، برای موارد زیر استفاده میکنیم: فراهم نمودن سرویسهای درخواستی شما؛ اطلاع از نحوه استفاده شما از سرویسها بدین منظور که بتوانیم تجربه شما را بهبود دهیم؛ فراهم نمودن محتوا و تبلیغات سفارشی؛ و موارد دیگر با رضایت شما.'));
  termsAndConditionsFake
      .add(TermsAndConditionsModel(title: 'نحوه تماس با ما', desc: 'ایمیل: لطفاً با بخش خدمات مشتری در آدرس zistino.com@gmail.com  تماس بگیرید.'));


  return termsAndConditionsFake;
}

List<ResidueFakeModel> residueData() {
  List<ResidueFakeModel> residue = [];

  residue.add(ResidueFakeModel(
      id: 0,
      colors: [const Color(0xff00e4f3), const Color(0xff01add3)],
      icon: 'assets/ic_shoe.png',
      picture: 'https://s6.uupload.ir/files/shoes-17775_977s.png',
      highestPrice: '1,540',
      pricePerKg: '1,540',
      description: 'پسماند تمامی کفشها'));
  residue.add(ResidueFakeModel(
      id: 0,
      colors: [Colors.pink.shade300, Colors.pink.shade400],
      icon: 'assets/ic_iron.png',
      picture: 'https://s6.uupload.ir/files/ahan_1dzl.png',
      highestPrice: '5,225',
      pricePerKg: '5,225',
      description:
          'لوله های چدنی، سینک های چدنی، رادیاتور های چدنی، تیر آهن، میلگرد، بدنه موتور سیکلت...'));
  residue.add(ResidueFakeModel(
      id: 0,
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

List<FlSpot> walletChartSpots() {
  List<FlSpot> items = const [
    FlSpot(0, 1.5),
    FlSpot(1, 1.9),
    FlSpot(2, 2.9),
    FlSpot(3, 3.9),
    FlSpot(4, 4.0),
    FlSpot(5, 3.0),
    FlSpot(6, 4.0),
    FlSpot(6.5, 4.2),
  ];
  return items;
}

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

List<ReviewModel> reviewFakeData() {
  List<ReviewModel> items = [];
  items.add(ReviewModel(
    "رفتار محترمانه",
    true,
  ));
  items.add(ReviewModel(
    "حفظ حریم شخصی",
    true,
  ));
  items.add(ReviewModel(
    "وقت شناسی و تحویل به موقع کالا",
    true,
  ));
  items.add(ReviewModel(
    "وضعیت ظاهری و بهداشتی راننده",
    true,
  ));items.add(ReviewModel(
    "کیفیت مناسب کالای سفارش داده شده و بسته بندی آن",
    true,
  ));items.add(ReviewModel(
    "وقت شناسی و دریافت به موقع پسماند",
    true,
  ));

  items.add(ReviewModel(
    "رفتار نامناسب",
    false,
  ));

  items.add(ReviewModel(
    "عدم حفظ حریم شخصی",
    false,
  )); items.add(ReviewModel(
    "عدم تطابق راننده",
    false,
  )); items.add(ReviewModel(
    "عدم تطابق خودرو",
    false,
  )); items.add(ReviewModel(
    "عد وقت شناسی و تحویل به موقع کالا",
    false,
  )); items.add(ReviewModel(
    "پیشنهاد خرید شخصی پسماند توسط راننده",
    false,
  )); items.add(ReviewModel(
    "عدم تطابق کالای سفارش داده شده با کالایی که تحویل داده شده",
    false,
  ));items.add(ReviewModel(
    "معیوب بودن و پاره شدن بسته بندی کالا",
    false,
  ));items.add(ReviewModel(
    "وضعیت ظاهری و بهداشتی راننده",
    false,
  ));
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
      phoneNumber: '07515151515'));
  requestList.add(RequestModel(
      name: 'علیرضا اسلمی',
      address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
      phoneNumber: '07515151515'));
  requestList.add(RequestModel(
      name: 'علیرضا اسلمی',
      address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
      phoneNumber: '07515151515'));
  requestList.add(RequestModel(
      name: 'علیرضا اسلمی',
      address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
      phoneNumber: '07515151515'));
  requestList.add(RequestModel(
      name: 'علیرضا اسلمی',
      address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
      phoneNumber: '07515151515'));
  requestList.add(RequestModel(
      name: 'علیرضا اسلمی',
      address: 'خ جمهوری-بین فرودین و اردیبهشت-پ392',
      phoneNumber: '07515151515'));
  return requestList;
}
