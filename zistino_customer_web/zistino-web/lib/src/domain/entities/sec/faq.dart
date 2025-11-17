
import 'faq_item.dart';


// part 'faq.g.dart';

// @Collection()
class FaqEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;

  final int categoryId;
  final String categoryName;
  final List<FaqsItemEntity> faqs;

  FaqEntity({this.categoryId = 0, this.categoryName = '', this.faqs = const []});
}


