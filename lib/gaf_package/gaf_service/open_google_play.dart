import 'package:url_launcher/url_launcher.dart';

class OpenGooglePlay {
  static const _appLink = '/details?id=com.gaf.classic_snake';

  void openGooglePlay() async {
    Uri uri = Uri(
        scheme: 'https', host: "play.google.com/store/apps", path: _appLink);
    /*
    * scheme: 'https',
    host: 'dart.dev',
    path: '/guides/libraries/library-tour',
    fragment: 'numbers');
print(httpsUri); // https://dart.dev/guides/libraries/library-tour#numbers
    * */
    await launchUrl(uri);
  }
}
