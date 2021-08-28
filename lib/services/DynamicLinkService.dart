// import 'dart:developer';
//
// import 'package:artnext/models/event.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
//
// class DynamicLinkService {
//
//   static Future<String> createDynamicLink(String parameter) async {
//     String uriPrefix = "https://artnext.page.link";
//
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: uriPrefix,
//       link: Uri.parse('https://artnext.page.link/$parameter'),
//       androidParameters: AndroidParameters(
//         packageName: 'ch.hevs.students.artnext.grp2',
//         minimumVersion: 0,
//       ),
//       iosParameters: IosParameters(
//         bundleId: 'your_ios_bundle_identifier',
//         minimumVersion: '1',
//         appStoreId: '123456789',
//       ),
//         socialMetaTagParameters: SocialMetaTagParameters(
//     title: 'Example of a Dynamic Link',
//     description: 'This link works whether app is installed or not!',
//     imageUrl: Uri.parse(
//     "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
//     );
//
//     final shortDynamicLink  = await parameters.buildShortLink();
//     final Uri shortUrl = shortDynamicLink.shortUrl;
//     return shortUrl.toString();
//   }
//
//   static void initDynamicLinks() async {
//
//     // TODO Débuguer cette partie (pourquoi les données sont null)
//     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
//
//     _handleDynamicLink(data!);
//
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//           _handleDynamicLink(dynamicLink!);
//         }, onError: (OnLinkErrorException e) async {
//       print('onLinkError');
//       print(e.message);
//     });
//   }
//
//   static _handleDynamicLink(PendingDynamicLinkData data) async {
//     final Uri? deepLink = data?.link;
//
//     if (deepLink == null) {
//       return;
//     }
//     if (deepLink.pathSegments.contains('refer')) {
//       var title = deepLink.queryParameters['code'];
//       if (title != null) {
//         print("refercode=$title");
//
//
//       }
//     }
//   }
// }
//
//
//
//   ///
// ///
// //     final Uri? shortUrl  = data?.link;
// //     if (shortUrl  != null) {
// //       log("deepLink from open app : " + shortUrl .path);
// //       //Navigator.pushNamed(context, deepLink.path);
// //     }
//
