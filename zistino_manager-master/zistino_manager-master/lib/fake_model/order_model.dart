class OrdersModel {
  int id;
  String image;
  String text;
  int? status;

  OrdersModel({
    required this.id,
    required this.image,
    required this.text,
    required this.status,
  });
}