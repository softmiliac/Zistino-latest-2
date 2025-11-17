import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/providers/fake_data.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../widgets/terms_and_conditions_widget.dart';

class TermsAndConditionsPage extends StatelessWidget {
  TermsAndConditionsPage({Key? key}) : super(key: key);

  ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: AppColors.shadowColor.withOpacity(0.2),
          elevation: 15,
          centerTitle: true,
          leading: backIcon(),
          title: Text(
            'حریم خصوصی',
            style: theme.textTheme.subtitle1,
          )),
      drawerEnableOpenDragGesture: true,
      backgroundColor: theme.backgroundColor,
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Container(
          alignment: AlignmentDirectional.centerStart,
          margin: EdgeInsetsDirectional.only(
              start: largeSize,
              end: standardSize,
              bottom: standardSize,
              top: largeSize),
          child: Text(
              'اولویت اصلی ما در شرکت فناورانه گیل آوای هیراد با برند تجاری "زیستینو"، حفاظت از اطلاعات شخصی شما است. ما کاملاً واقف هستیم که اطلاعات شخصی شما به خود شما تعلق دارد و تمام تلاشمان را می‌کنیم تا از اطلاعاتی که با ما به اشتراک گذاشته‌اید به خوبی محافظت کنیم و با دقت آنها را پردازش نماییم. ما بیشترین ارزش را برای اعتماد شما قائلیم. از این رو حداقل اطلاعات را که در هر چه بهتر ارائه نمودن خدمات به شما نیاز داریم، با اجازه خودتان از شما دریافت میکنیم و از این اطلاعات تنها برای مقاصد در نظر گرفته شده استفاده می‌نماییم. ما این اطلاعات را به هیچ وجه نزد اشخاص ثالث افشا نمی‌کنیم. ما در زیستینو، با  استفاده از روش‌هایی از قبیل مدیریت داخلی و امنیت اطلاعات فنی و همچنین اقدامات حفاظت از اطلاعات فیزیکی تمام تلاشمان را می‌کنیم تا مطمئن شویم از اطلاعات شما محافظت می‌شود. علی الخصوص، تکنولوژی رمزگذاری قوی‌ای را ایجاد کرده‌ایم که مبتنی بر وب است. ما این تکنولوژی را در سیستم‌های نرم افزاری خود عمال کرده‌ایم و این ویژگی وجه تمایز ما با دیگران است. ما در تلاشیم که زندگی شما را با ارائه تجارب امیدبخش و جذاب دیجیتالی بهبود ببخشیم.  به همین منظور، اعتماد شما برای ما از اهمیت زیادی برخوردار است و بنابراین تمام تلاشمان را می‌کنیم تا از اطلاعات شخصی شما حفاظت کنیم. از علاقه و حمایت همیشگی شما متشکریم. مجموعه زیستینو با اپلیکیشنی با همین نام در فروشگاه اینترنتی کافه بازار و صرفا در ۲ سایت zistino.com و zistinoo.ir قابل دسترسی و دانلود می باشد و نسبت به هیچ اپلیکیشن و سایت دیگری تعهد و مسئولیتی به عهده ندارد و از شما عزیزان خواهشمندیم که در مراجعه به سایت و یا دانلود اپلیکیشن نهایت دقت و مراقبت را داشته باشید. وظیفه خود می دانیم که در کمال صداقت، نحوه عملکرد برنامه و اپلیکیشن های زیستینو را در حد توان، به کاربران و بازدید کنندگان خود از طریق بروز رسانی مطالب یا سایر رسانه های اجتماعی گزارش دهیم. بنابراین در خصوص کلاهبرداری های احتمالی سایتها و اپلیکیشین هایی که از نام تجاری ما سواستفاده نمایند، مسئولیتی را نخواهیم پذیرفت ، بنابراین در انتخاب هر سایت یا اپلیکیشن برای فعالیت به دقت راجع به آن تحقیق و بررسی نمایید و با قبول کلیه مسئولیت های ناشی از آن به فعالیت یا عدم فعالیت اقدام کنید .',
              textAlign: TextAlign.justify,
              style: theme.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        ListView.builder(
          padding: EdgeInsets.only(
            left: standardSize,
            right: standardSize,
          ),
          primary: false,
          shrinkWrap: true,
          itemCount: termsAndConditionsData().length,
          itemBuilder: (context, index) {
            return termsAndConditionsWidget(context,termsAndConditionsData()[index]);
          },
        ),
      ]),
    );
  }
}
