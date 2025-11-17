

import '../base/safe_convert.dart';

class CheckCodeRPM {
  final bool isCorrect;

  CheckCodeRPM({
    this.isCorrect = false,
  });

  factory CheckCodeRPM.fromJson(Map<String, dynamic>? json) => CheckCodeRPM(
    isCorrect: asT<bool>(json, 'isCorrect'),
  );

  Map<String, dynamic> toJson() => {
    'isCorrect': isCorrect,
  };
}

