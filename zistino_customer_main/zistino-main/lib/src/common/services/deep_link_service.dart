// import 'dart:async';
// import 'package:flutter/services.dart';
//
// import 'locator.dart';
//
// class DeepLinkService {
//   Future handleDynamicLinks() async {
//     NavigationService _navigationService = locator<NavigationService>();
//     StreamSubscription sub;
//     await getInitialLink();
//
//
//
//     try {
//
//       sub = getUriLinksStream().listen((Uri? uri) {
//
//         var convertUriToString = uri.toString();
//
//         String id = convertUriToString.replaceAll(RegExp('[^0-9]'),'');
//
//         if (uri != null) {
//
//           if (convertUriToString.contains("/podcast/?p=") || convertUriToString.contains("/audiobook/?p=")) {
//
//             uri = null;
//             _navigationService.clearTillFirstAndShow(Routes.basePodcastPage,
//                 arguments: BasePodcastPageArguments(id: id,isFromSplash: false));
//             uri = null;
//
//           } else if (convertUriToString.contains("/ebook/?p=")) {
//
//             uri = null;
//             _navigationService.clearTillFirstAndShow(Routes.baseEBookPage,
//                 arguments: BaseEBookPageArguments(id: id,isFromSplash: false));
//             uri = null;
//
//           } else if(convertUriToString.contains("/episode/?p=")) {
//
//             uri = null;
//             _navigationService.clearTillFirstAndShow(Routes.baseEpisodePage,
//                 arguments: BaseEpisodePageArguments(id: id,isFromSplash: false));
//             uri = null;
//
//           }else{
//             debugPrint("Not Found Initial Link");
//           }
//         }
//
//       }, onError: (err) {
//         debugPrint("onError");
//       });
//     } on PlatformException {
//       debugPrint("PlatformException");
//     } on Exception {
//       debugPrint('Exception thrown');
//     }
//
//   }
// }
