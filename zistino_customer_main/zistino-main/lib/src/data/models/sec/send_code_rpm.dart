//
//
// import '../base/safe_convert.dart';
//
// class SendCodeRPM {
//   final List<String> messages;
//   final bool succeeded;
//
//   SendCodeRPM({
//     required this.messages,
//     this.succeeded = false,
//   });
//
//   factory SendCodeRPM.fromJson(Map<String, dynamic>? json) => SendCodeRPM(
//     messages: asT<List>(json, 'messages').map((e) => e.toString()).toList(),
//     succeeded: asT<bool>(json, 'succeeded'),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'messages': messages.map((e) => e),
//     'succeeded': succeeded,
//   };
// }
//
