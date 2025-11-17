
class TransactionModel {
  final String description;
  final int value;
  final String date;
  final bool isEnabled;

  TransactionModel({
    required this.description,
    required this.value,
    required this.date,
    required this.isEnabled,
  });
}
