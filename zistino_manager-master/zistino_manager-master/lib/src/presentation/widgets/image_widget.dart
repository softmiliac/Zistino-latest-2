import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../data/providers/remote/api_endpoint.dart';
import '../style/dimens.dart';

Widget imageWidget(String image,
    {double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    double? radius,
    Widget? placeHolder}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 0),
    child: CachedNetworkImage(
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
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(radius ?? 0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius ?? 0),
                      child: const CupertinoActivityIndicator(
                          color: Colors.transparent),
                    )),
              ),
            ],
          ),
      errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
          width: iconSizeSmall,
          padding: EdgeInsetsDirectional.all(xSmallSize),
          height: iconSizeSmall,
          child: SvgPicture.asset(
            'assets/ic_image.svg',
            width: iconSizeSmall,
            height: iconSizeSmall,
          )),
    )
  );
}

String imageUrlChecker(String url) {
  if (url.startsWith("http") || url.startsWith("https")) {
    return url;
  } else {
    return APIEndpoint.mediaURL + url;
  }
}
