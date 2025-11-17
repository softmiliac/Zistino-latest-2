
// @Collection()
class FaqsItemEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;
  final int id;
  final String title;
  final String description;

  FaqsItemEntity({this.id=0, this.title ='', this.description =''});
}