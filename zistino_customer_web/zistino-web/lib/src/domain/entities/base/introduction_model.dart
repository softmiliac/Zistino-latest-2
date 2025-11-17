class IntroductionModel {
  String image;
  String text;

  IntroductionModel({
    required this.image,
    required this.text,
  });
}

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
