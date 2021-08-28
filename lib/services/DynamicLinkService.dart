import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {

  Future<Uri> createDynamicLink(String eventId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://artnext.page.link',
      link: Uri.parse('https://artnext.page.link?eventId=' + eventId),
      androidParameters: AndroidParameters(
        packageName: 'ch.hevs.students.artnext.grp2',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: '123456789',
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {

    // TODO Débuguer cette partie (pourquoi les données sont null)

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      log("deepLink from open app : " + deepLink.path);
      //Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            log("deepLink from closed app : " + deepLink.data!.uri.toString());
            //Navigator.pushNamed(context, deepLink.path);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
  }

}