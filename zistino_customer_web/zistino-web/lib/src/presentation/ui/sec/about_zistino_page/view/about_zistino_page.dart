import 'package:admin_dashboard/src/common/utils/number_format.dart';
import 'package:admin_dashboard/src/presentation/style/animation/slide_transition.dart';
import 'package:admin_dashboard/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';

class AboutZistinoPage extends GetResponsiveView {
  AboutZistinoPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  final CarouselController buttonCarouselController = CarouselController();
  RxInt categoryIndex = 0.obs;

  RxDouble height = (fullHeight / 6).obs;
  RxDouble width = (fullHeight / 7).obs;

  @override
  Widget desktop() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          // backgroundColor: Colors.blue,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            title: Text('دربـاره زیستینو',
                style: theme.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          body: Container(
            padding: EdgeInsetsDirectional.all(
                MediaQuery.of(Get.context!).size.width / 40),
            decoration: BoxDecoration(
                color: AppColors.homeBackgroundColor,
                borderRadius: BorderRadius.circular(16)),
            child: Text(
                'امروزه به احتمال فراوان همه ی ما از وضعیت خطرناک محیط زیست و فضای شهری خود به دلیل روند فزاینده ی تولید پسماند و به دنبال آن روش های عمدتا غیر اصولی و قدیمی جمع آوری و دفع پسماندها ؛ آگاه داریم.همین اوضاع و احوال ناگوار و تلخ محیط زیست فعلی ما ، که به طور قطع در زندگی نسل های آینده نیز تاثیر مستقیم خواهد داشت ، ما را بر آن داشت تا در حد توان و سهم خود به عنوان شهروند به دنبال یافتن یک راهکار اصولی و تاثیرگذار پیرامون این مسئله حیاتی باشیم. به همین منظور پس از بررسی های کارشناسانه و مشورت با افراد مختلف و دلسوز به این باور رسیدیم که در بخش جمع آوری پسماندهای خشک که بازیافت طبیعی شان برای طبیعت به شدت مشکل و بسیار طوالنی مدت است ، با روشی اصولی و هوشمند باید ورود کرد و این حوزه را باید مورد توجه قرار داد. در دنیای امروز که مبتنی بر بستر وب و سامانه های برخط است ؛ به این نتیجه رسیدیم که باید یک سامانه ی هوشمند خرید و جمع آوری انواع پسماند خشک در هر زمان و مکانی که کاربران محترم انتخاب نمایند ، ایجاد نماییم. پس با گردآوری یک تیم جوان ، مستعد و دغدغه مند به حوزه محیط زیست ، یک شرکت دانش بنیان را پدید آوردیم و با راه اندازی سامانه هوشمند » زیستینو « به دنبال تحقق اهداف متعالی خود خواهیم بود. ماموریت و اهداف زیستینو هدف و ماموریت گروه زیستینو در وهله ی نخست یاری رساندن به محیط زیست و داشتن فضای شهری پاکیزه و پر نشاط برای تمامی شهروندان محترم است. در کنار این هدف و ماموریت واالی خود ، تالش می کنیم با خرید پسماند خشک از شهروندان عزیز یک کمک مالی هر چند کوچک به ایشان شود و هم یک مشوق مالی برای شهروندان جهت جمع آوری و تحویل پسماندهای خشک شان ایجاد شود و در پایان بتوانیم سبب ایجاد چند شغل مستقیم و غیر مستقیم برای هموطنان خود شویم.\n به امید محیط زیستی پاک و پر نشاط برای همه ی مخلوقات'),
          )),
    );
  }

  @override
  Widget phone() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            shadowColor: AppColors.shadowColor.withOpacity(0.2),
            elevation: 15,
            title: Text('دربـاره زیستینو',
                style: theme.textTheme.subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold)),
            leading: backIcon(iconColor: Colors.black),
            backgroundColor: theme.backgroundColor,
          ),
          body: Container(
            color: Colors.white,
          )),
    );
  }

  @override
  Widget tablet() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            shadowColor: AppColors.shadowColor.withOpacity(0.2),
            elevation: 15,
            title: Text('دربـاره زیستینو',
                style: theme.textTheme.subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold)),
            leading: backIcon(iconColor: Colors.black),
            backgroundColor: theme.backgroundColor,
          ),
          body: Container(
            color: Colors.white,
          )),
    );
  }
}
