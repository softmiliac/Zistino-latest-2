
class Failure implements Exception {
  final String code;
  final String message;


  Failure({required this.message, required this.code});
}
