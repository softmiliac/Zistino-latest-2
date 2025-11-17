import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style/dimens.dart';

Widget loadingWidget({bool defaultHeight = true,double? height}) {
  return Container(
      width: fullWidth,
      height: defaultHeight ? height ?? fullHeight / 2.3 : null,
      alignment: AlignmentDirectional.center,
      child: const CupertinoActivityIndicator());
}

