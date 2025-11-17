import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style/dimens.dart';

Widget loadingWidget({double? height}) {
  return Container(
      width: fullWidth,
      height: height ?? fullHeight / 2.3,
      alignment: AlignmentDirectional.center,
      child: const CupertinoActivityIndicator());
}
