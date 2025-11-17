class OrderItemsEntity {
  final int id;
  final String productId;
  final String productName;
  final String productImage;
  final int unitPrice;
  final int unitDiscountPrice;
  final int itemCount;
  final int status;

  OrderItemsEntity({
    this.id = 0,
    this.productId = "",
    this.productName = "",
    this.productImage = "",
    this.unitPrice = 0,
    this.unitDiscountPrice = 0,
    this.itemCount = 0,
    this.status = 0,
  });
}
