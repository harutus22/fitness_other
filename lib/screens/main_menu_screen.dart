// import 'package:alarm/alarm.dart';
import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/bottom_navigation_item.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/create/create_main_screen.dart';
import 'package:fitness/screens/plan/work_out_plan_main_screen.dart';
import 'package:fitness/screens/profile/profile_main_screen.dart';
import 'package:fitness/screens/splash_screen.dart';
import 'package:fitness/utils/custom_icons/create_final_custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/Routes.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../utils/notification_class.dart';
import '../utils/open_ad_manager.dart';
import '../utils/words.dart';
import 'onboarding/paywall_screen.dart';

class MainMenuScreen extends StatefulWidget {
  MainMenuScreen({Key? key, this.numer}) : super(key: key);

  int? numer = null;

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  var _selectedIndex = 0;
  final iconSize = 25.0;
  final pages = [
    const WorkOutPlanMainScreen(),
    const ChallengeMainScreen(),
    const CreateMainScreen(),
    const ProfileMainScreen()
  ];
  bool pageActive1 = false, pageActive2 = false,pageActive3 = false, pageActive4 = false;
  BottomNavigationItem bottomNavigationItem = BottomNavigationItem();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
    if(!user.isSubscribed && !OpenAdManager.haveShowed && SplashScreen.isAdToShow){
      openAdManager.createOpenAd("", (){
        OpenAdManager.haveShowed = true;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return PaywallScreen();
        }), (r){
          return false;
        });
      });
    }
    super.initState();

    if(widget.numer != null){
      _selectedIndex = widget.numer!;
    }
    inita();
  }

  void inita() async {

    initStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState((){
      _selectedIndex == 0 ? pageActive1 = true : pageActive1 = false;
      _selectedIndex == 1 ? pageActive2 = true : pageActive2 = false;
      _selectedIndex == 2 ? pageActive3 = true : pageActive3 = false;
      _selectedIndex == 3 ? pageActive4 = true : pageActive4 = false;
    });
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        // type: BottomNavigationBarType.fixed,
        // selectedItemColor: Colors.black,

        // unselectedItemColor: bottomItemColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: <BottomNavigationBarItem>[
          bottomNavigationItem.showItem(pageActive1, plan.tr(), iconSize, "assets/images/home.svg"),
          bottomNavigationItem.showItem(pageActive2, challenges.tr(), iconSize, "assets/images/fire.svg"),
          bottomNavigationItem.showItem(pageActive3, create.tr(), iconSize, "assets/images/create.svg"),
          bottomNavigationItem.showItem(pageActive4, profile.tr(), iconSize, "assets/images/profile.svg"),
        ],
      ),
    );
  }

  void _onItemTapped(int index) async {
    if(index == 2 && !user.isSubscribed){
      await changeScreen(payWallScreen, context, argument: canPop);
      setState(() {});
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
