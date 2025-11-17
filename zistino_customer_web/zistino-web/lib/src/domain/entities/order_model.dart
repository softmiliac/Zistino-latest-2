class OrdersModel {
  int id;
  String image;
  String text;
  int statusRequest;

  OrdersModel({
    required this.id,
    required this.image,
    required this.text,
    required this.statusRequest,
  });
}

List<OrdersModel> orderCategoryData() {
  List<OrdersModel> orderCategoryFake = [];

  orderCategoryFake.add(OrdersModel(
      id: 0,image: 'assets/ic_active_order.png', text: 'سفارش فعال' ,statusRequest: 0));
  orderCategoryFake.add(OrdersModel(
      id: 1,image: 'assets/ic_finish_order.png', text: 'سفارش پایان یافته',statusRequest: 0));
  orderCategoryFake.add(OrdersModel(
      id: 2,image: 'assets/ic_cancel_order.png', text: 'سفارش لغو شده',statusRequest: 0));

  return orderCategoryFake;
}