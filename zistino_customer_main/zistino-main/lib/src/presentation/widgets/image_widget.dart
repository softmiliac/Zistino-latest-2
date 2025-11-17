import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../data/providers/remote/api_endpoint.dart';
import '../style/colors.dart';
import '../style/dimens.dart';

Widget imageWidget(String image,
    {double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    double? radius,
      Color? backgroundColor,
    Widget? placeHolder}) {
  return CachedNetworkImage(
    fit: fit,
    width: width,
    height: height,
    fadeInCurve: Curves.easeInCubic,
    filterQuality: FilterQuality.medium,
    fadeInDuration: const Duration(seconds: 1),
    placeholderFadeInDuration: const Duration(seconds: 1),
    fadeOutDuration: const Duration(seconds: 1),
    imageUrl: imageUrlChecker(image),
    placeholder: (context, url) =>
        placeHolder ??
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  width: width ?? fullWidth,
                  height: height,
                  decoration: BoxDecoration(
                      color: backgroundColor ?? AppColors.homeBackgroundColor,
                      borderRadius: BorderRadius.circular(radius ?? 0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius ?? 0),
                    child: const CupertinoActivityIndicator(
                        color: AppColors.captionTextColor),
                  )),
            ),
          ],
        ),
    errorWidget: (context, url, error) => Container(
        width: width ?? fullWidth,
        padding: EdgeInsetsDirectional.all(xxLargeSize * 1.2),
        height: iconSizeSmall,
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.homeBackgroundColor,
            borderRadius: BorderRadius.circular(smallRadius)),
        child: SvgPicture.asset(
            'assets/ic_image.svg',
            width: iconSizeLarge,
            height: iconSizeLarge,
            color: AppColors.primaryColor)),
  );
}

String imageUrlChecker(String url) {
  if (url.startsWith("http") || url.startsWith("https")) {
    return url;
  } else {
    return APIEndpoint.mediaURL + url;
  }
}
