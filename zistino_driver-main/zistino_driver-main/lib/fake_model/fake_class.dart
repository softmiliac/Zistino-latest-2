import 'daily_model.dart';
import 'education_model.dart';
import 'hour_model.dart';

List<DailyModel> dailyList(){
  List<DailyModel> list = [];
    list.add(DailyModel(day: 'شنبه 4 آبان'));
    list.add(DailyModel(day: 'یک شنبه 5 آبان'));
    list.add(DailyModel(day: 'دو شنبه 6 آبان'));
    list.add(DailyModel(day: 'سه شنبه 7 آبان'));
    list.add(DailyModel(day: 'چهار شنبه 8 آبان'));
    list.add(DailyModel(day: 'پنج شنبه 9 آبان'));
    list.add(DailyModel(day: 'جمعه 10 آبان'));
  return list;
}
List<HourModel> hourList(){
  List<HourModel> list = [];
  list.add(HourModel(time: 'اکنون',icon: ''));
  list.add(HourModel(time: 'چهارشنبه',icon: '9 الی 12'));
  list.add(HourModel(time: 'چهارشنبه',icon: ' الی 12'));
  list.add(HourModel(time: 'چهارشنبه',icon: ' الی 12'));
  list.add(HourModel(time: 'چهارشنبه',icon: ' الی 12'));
  list.add(HourModel(time: 'چهارشنبه',icon: ' الی 12'));
  list.add(HourModel(time: 'چهارشنبه',icon: ' الی 12'));
  return list;
}
List<EducationFakeModel> edFakeModel(){
  List<EducationFakeModel> list = [];
  list.add(EducationFakeModel(educationLevel: 'زیر دیپلم'));
  list.add(EducationFakeModel(educationLevel: 'دیپلم'));
  list.add(EducationFakeModel(educationLevel: 'فوق دیپلم'));
  list.add(EducationFakeModel(educationLevel: 'لیسانس'));
  list.add(EducationFakeModel(educationLevel: 'فوق لیسانس'));
  list.add(EducationFakeModel(educationLevel: 'دکترا'));
  return list;
}