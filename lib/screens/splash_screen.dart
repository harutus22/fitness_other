import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:notification_permissions/notification_permissions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static bool isAdToShow = true;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;


  @override
  void initState() {
    // TODO: implement initState
    SplashScreen.isAdToShow = false;
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _controller = VideoPlayerController.asset("assets/videos/splash_video.mp4")
      ..initialize().then((value) => {
            _controller.play(),
            _controller.setLooping(true),
            // Ensure the first frame is shown after the video is initialized.
            setState(() {})
          });
    Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions(iosSettings: const NotificationSettingsIos(
        sound: true, badge: true, alert: true));
    // AwesomeNotifications().isNotificationAllowed().then((allowed) =>
    // {
    //   if (!allowed)
    //     {
    //       showDialog(
    //           context: context,
    //           builder: (builder) =>
    //               AlertDialog(
    //                 title: Text(allowNotification.tr()),
    //                 content: Text(alertText.tr()),
    //                 actions: [
    //                   TextButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Text(
    //                         dontAllow.tr(),
    //                         style:
    //                         TextStyle(color: Colors.grey, fontSize: 18, fontFamily: 'SairaCondensed',),
    //                       )),
    //                   TextButton(
    //                       onPressed: () {
    //                         AwesomeNotifications()
    //                             .requestPermissionToSendNotifications()
    //                             .then((value) => Navigator.pop(context));
    //                       },
    //                       child: Text(
    //                         allowText.tr(),
    //                         style: TextStyle(
    //                           color: Colors.teal,
    //                           fontSize: 18,
    //                           fontWeight: FontWeight.bold, fontFamily: 'SairaCondensed',),
    //                       )),
    //                 ],
    //               ))
    //     }
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              // fit: BoxFit.cover
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
                // child: Image.asset("assets/images/splash_image.png"),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                next(context, genderScreen, true, () {}),
                const SizedBox(
                  height: 35,
                ),
                RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'SairaCondensed',),
                        children: [
                      TextSpan(
                        text: termsOfUse.tr(),
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          final uri = Uri.parse(termsUrl);
                          if (!await launchUrl(uri)) {
                          throw Exception('Could not launch $uri');
                          }
                        },
                        style: const TextStyle(
                            decoration:
                                TextDecoration.underline, fontFamily: 'SairaCondensed',), //<-- SEE HERE
                      ),
                      TextSpan(text: " ${and.tr()} "),
                      TextSpan(
                        text: privacy.tr(),
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          final uri = Uri.parse(privacyUrl);
                          if (!await launchUrl(uri)) {
                            throw Exception('Could not launch $uri');
                          }
                        },
                        style: const TextStyle(
                            decoration:
                                TextDecoration.underline, fontFamily: 'SairaCondensed',), //<-- SEE HERE
                      ),
                    ])),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
